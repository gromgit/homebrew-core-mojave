class Luajit < Formula
  desc "Just-In-Time Compiler (JIT) for the Lua programming language"
  homepage "https://luajit.org/luajit.html"
  license "MIT"
  head "https://luajit.org/git/luajit-2.0.git", branch: "v2.1"

  stable do
    url "https://luajit.org/download/LuaJIT-2.0.5.tar.gz"
    sha256 "874b1f8297c697821f561f9b73b57ffd419ed8f4278c82e05b48806d30c1e979"

    # Fix for macOS 10.15 Catalina SDK
    # https://github.com/LuaJIT/LuaJIT/issues/521
    patch :DATA
  end

  livecheck do
    url "https://luajit.org/download.html"
    regex(/href=.*?LuaJIT[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 4
    sha256 cellar: :any,                 monterey:     "10a01bd4413425300be480b6e0a7c951886f2a43b0c12dc89d6077a2d1cf11f4"
    sha256 cellar: :any,                 big_sur:      "b3d7fd95cf9b72f89bc95cbc86e19786e9353b353c409e19b721d9ac98c9216b"
    sha256 cellar: :any,                 catalina:     "0a37eaa5b05ab2e30fcdbfb0355265404b7030655344d79394f9b957df4f317d"
    sha256 cellar: :any,                 mojave:       "0b6cad395e49805dfa9b3dc70fd775c416d997ea4774ee8453e87deeaf5fdffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c958527ccb075bdc9e61adacd371a2372ffa731c53ffb191fe71f0889ea24869"
  end

  def install
    # 1 - Override the hardcoded gcc.
    # 2 - Remove the "-march=i686" so we can set the march in cflags.
    # Both changes should persist and were discussed upstream.
    inreplace "src/Makefile" do |f|
      f.change_make_var! "CC", ENV.cc
      f.change_make_var! "CCOPT_x86", ""
    end

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    args = %W[PREFIX=#{prefix}]

    # Build with 64-bit support
    args << "XCFLAGS=-DLUAJIT_ENABLE_GC64" if build.head?

    system "make", "amalg", *args
    system "make", "install", *args

    # Unstable branch doesn't install symlink for luajit.
    # This breaks tools like `luarock` who requires the `luajit` bin to be present.
    bin.install_symlink Dir[bin/"luajit-*"].first => "luajit" if build.head?

    # LuaJIT doesn't automatically symlink unversioned libraries:
    # https://github.com/Homebrew/homebrew/issues/45854.
    lib.install_symlink lib/"libluajit-5.1.dylib" => "libluajit.dylib"
    lib.install_symlink lib/"libluajit-5.1.a" => "libluajit.a"

    # Fix path in pkg-config so modules are installed
    # to permanent location rather than inside the Cellar.
    inreplace lib/"pkgconfig/luajit.pc" do |s|
      s.gsub! "INSTALL_LMOD=${prefix}/share/lua/${abiver}",
              "INSTALL_LMOD=#{HOMEBREW_PREFIX}/share/lua/${abiver}"
      s.gsub! "INSTALL_CMOD=${prefix}/${multilib}/lua/${abiver}",
              "INSTALL_CMOD=#{HOMEBREW_PREFIX}/${multilib}/lua/${abiver}"
      unless build.head?
        s.gsub! "Libs:",
                "Libs: -pagezero_size 10000 -image_base 100000000"
      end
    end

    # Having an empty Lua dir in lib/share can mess with other Homebrew Luas.
    %W[#{lib}/lua #{share}/lua].each { |d| rm_rf d }
  end

  test do
    system "#{bin}/luajit", "-e", <<~EOS
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV["USER"]}")
    EOS
  end
end

__END__
--- a/src/lj_alloc.c
+++ b/src/lj_alloc.c
@@ -72,13 +72,56 @@
 
 #define IS_DIRECT_BIT		(SIZE_T_ONE)
 
+
+/* Determine system-specific block allocation method. */
 #if LJ_TARGET_WINDOWS
 
 #define WIN32_LEAN_AND_MEAN
 #include <windows.h>
 
+#define LJ_ALLOC_VIRTUALALLOC	1
+
+#if LJ_64 && !LJ_GC64
+#define LJ_ALLOC_NTAVM		1
+#endif
+
+#else
+
+#include <errno.h>
+/* If this include fails, then rebuild with: -DLUAJIT_USE_SYSMALLOC */
+#include <sys/mman.h>
+
+#define LJ_ALLOC_MMAP		1
+
 #if LJ_64
 
+#define LJ_ALLOC_MMAP_PROBE	1
+
+#if LJ_GC64
+#define LJ_ALLOC_MBITS		47	/* 128 TB in LJ_GC64 mode. */
+#elif LJ_TARGET_X64 && LJ_HASJIT
+/* Due to limitations in the x64 compiler backend. */
+#define LJ_ALLOC_MBITS		31	/* 2 GB on x64 with !LJ_GC64. */
+#else
+#define LJ_ALLOC_MBITS		32	/* 4 GB on other archs with !LJ_GC64. */
+#endif
+
+#endif
+
+#if LJ_64 && !LJ_GC64 && defined(MAP_32BIT)
+#define LJ_ALLOC_MMAP32		1
+#endif
+
+#if LJ_TARGET_LINUX
+#define LJ_ALLOC_MREMAP		1
+#endif
+
+#endif
+
+
+#if LJ_ALLOC_VIRTUALALLOC
+
+#if LJ_ALLOC_NTAVM
 /* Undocumented, but hey, that's what we all love so much about Windows. */
 typedef long (*PNTAVM)(HANDLE handle, void **addr, ULONG zbits,
 		       size_t *size, ULONG alloctype, ULONG prot);
@@ -89,14 +132,15 @@
 */
 #define NTAVM_ZEROBITS		1
 
-static void INIT_MMAP(void)
+static void init_mmap(void)
 {
   ntavm = (PNTAVM)GetProcAddress(GetModuleHandleA("ntdll.dll"),
 				 "NtAllocateVirtualMemory");
 }
+#define INIT_MMAP()	init_mmap()
 
 /* Win64 32 bit MMAP via NtAllocateVirtualMemory. */
-static LJ_AINLINE void *CALL_MMAP(size_t size)
+static void *CALL_MMAP(size_t size)
 {
   DWORD olderr = GetLastError();
   void *ptr = NULL;
@@ -107,7 +151,7 @@
 }
 
 /* For direct MMAP, use MEM_TOP_DOWN to minimize interference */
-static LJ_AINLINE void *DIRECT_MMAP(size_t size)
+static void *DIRECT_MMAP(size_t size)
 {
   DWORD olderr = GetLastError();
   void *ptr = NULL;
@@ -119,23 +163,21 @@
 
 #else
 
-#define INIT_MMAP()		((void)0)
-
 /* Win32 MMAP via VirtualAlloc */
-static LJ_AINLINE void *CALL_MMAP(size_t size)
+static void *CALL_MMAP(size_t size)
 {
   DWORD olderr = GetLastError();
-  void *ptr = VirtualAlloc(0, size, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
+  void *ptr = LJ_WIN_VALLOC(0, size, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
   SetLastError(olderr);
   return ptr ? ptr : MFAIL;
 }
 
 /* For direct MMAP, use MEM_TOP_DOWN to minimize interference */
-static LJ_AINLINE void *DIRECT_MMAP(size_t size)
+static void *DIRECT_MMAP(size_t size)
 {
   DWORD olderr = GetLastError();
-  void *ptr = VirtualAlloc(0, size, MEM_RESERVE|MEM_COMMIT|MEM_TOP_DOWN,
-			   PAGE_READWRITE);
+  void *ptr = LJ_WIN_VALLOC(0, size, MEM_RESERVE|MEM_COMMIT|MEM_TOP_DOWN,
+			    PAGE_READWRITE);
   SetLastError(olderr);
   return ptr ? ptr : MFAIL;
 }
@@ -143,7 +185,7 @@
 #endif
 
 /* This function supports releasing coalesed segments */
-static LJ_AINLINE int CALL_MUNMAP(void *ptr, size_t size)
+static int CALL_MUNMAP(void *ptr, size_t size)
 {
   DWORD olderr = GetLastError();
   MEMORY_BASIC_INFORMATION minfo;
@@ -163,10 +205,7 @@
   return 0;
 }
 
-#else
-
-#include <errno.h>
-#include <sys/mman.h>
+#elif LJ_ALLOC_MMAP
 
 #define MMAP_PROT		(PROT_READ|PROT_WRITE)
 #if !defined(MAP_ANONYMOUS) && defined(MAP_ANON)
@@ -174,105 +213,152 @@
 #endif
 #define MMAP_FLAGS		(MAP_PRIVATE|MAP_ANONYMOUS)
 
-#if LJ_64
-/* 64 bit mode needs special support for allocating memory in the lower 2GB. */
-
-#if defined(MAP_32BIT)
-
-#if defined(__sun__)
-#define MMAP_REGION_START	((uintptr_t)0x1000)
+#if LJ_ALLOC_MMAP_PROBE
+
+#ifdef MAP_TRYFIXED
+#define MMAP_FLAGS_PROBE	(MMAP_FLAGS|MAP_TRYFIXED)
 #else
-/* Actually this only gives us max. 1GB in current Linux kernels. */
-#define MMAP_REGION_START	((uintptr_t)0)
-#endif
-
-static LJ_AINLINE void *CALL_MMAP(size_t size)
-{
+#define MMAP_FLAGS_PROBE	MMAP_FLAGS
+#endif
+
+#define LJ_ALLOC_MMAP_PROBE_MAX		30
+#define LJ_ALLOC_MMAP_PROBE_LINEAR	5
+
+#define LJ_ALLOC_MMAP_PROBE_LOWER	((uintptr_t)0x4000)
+
+/* No point in a giant ifdef mess. Just try to open /dev/urandom.
+** It doesn't really matter if this fails, since we get some ASLR bits from
+** every unsuitable allocation, too. And we prefer linear allocation, anyway.
+*/
+#include <fcntl.h>
+#include <unistd.h>
+
+static uintptr_t mmap_probe_seed(void)
+{
+  uintptr_t val;
+  int fd = open("/dev/urandom", O_RDONLY);
+  if (fd != -1) {
+    int ok = ((size_t)read(fd, &val, sizeof(val)) == sizeof(val));
+    (void)close(fd);
+    if (ok) return val;
+  }
+  return 1;  /* Punt. */
+}
+
+static void *mmap_probe(size_t size)
+{
+  /* Hint for next allocation. Doesn't need to be thread-safe. */
+  static uintptr_t hint_addr = 0;
+  static uintptr_t hint_prng = 0;
   int olderr = errno;
-  void *ptr = mmap((void *)MMAP_REGION_START, size, MMAP_PROT, MAP_32BIT|MMAP_FLAGS, -1, 0);
-  errno = olderr;
-  return ptr;
-}
-
-#elif LJ_TARGET_OSX || LJ_TARGET_PS4 || defined(__FreeBSD__) || defined(__FreeBSD_kernel__) || defined(__NetBSD__) || defined(__OpenBSD__) || defined(__DragonFly__) || defined(__sun__) || LJ_TARGET_CYGWIN
-
-/* OSX and FreeBSD mmap() use a naive first-fit linear search.
-** That's perfect for us. Except that -pagezero_size must be set for OSX,
-** otherwise the lower 4GB are blocked. And the 32GB RLIMIT_DATA needs
-** to be reduced to 250MB on FreeBSD.
-*/
-#if LJ_TARGET_OSX || defined(__DragonFly__)
-#define MMAP_REGION_START	((uintptr_t)0x10000)
-#elif LJ_TARGET_PS4
-#define MMAP_REGION_START	((uintptr_t)0x4000)
-#else
-#define MMAP_REGION_START	((uintptr_t)0x10000000)
-#endif
-#define MMAP_REGION_END		((uintptr_t)0x80000000)
-
-#if (defined(__FreeBSD__) || defined(__FreeBSD_kernel__)) && !LJ_TARGET_PS4
-#include <sys/resource.h>
-#endif
-
-static LJ_AINLINE void *CALL_MMAP(size_t size)
-{
-  int olderr = errno;
-  /* Hint for next allocation. Doesn't need to be thread-safe. */
-  static uintptr_t alloc_hint = MMAP_REGION_START;
-  int retry = 0;
-#if (defined(__FreeBSD__) || defined(__FreeBSD_kernel__)) && !LJ_TARGET_PS4
-  static int rlimit_modified = 0;
-  if (LJ_UNLIKELY(rlimit_modified == 0)) {
-    struct rlimit rlim;
-    rlim.rlim_cur = rlim.rlim_max = MMAP_REGION_START;
-    setrlimit(RLIMIT_DATA, &rlim);  /* Ignore result. May fail below. */
-    rlimit_modified = 1;
-  }
-#endif
-  for (;;) {
-    void *p = mmap((void *)alloc_hint, size, MMAP_PROT, MMAP_FLAGS, -1, 0);
-    if ((uintptr_t)p >= MMAP_REGION_START &&
-	(uintptr_t)p + size < MMAP_REGION_END) {
-      alloc_hint = (uintptr_t)p + size;
+  int retry;
+  for (retry = 0; retry < LJ_ALLOC_MMAP_PROBE_MAX; retry++) {
+    void *p = mmap((void *)hint_addr, size, MMAP_PROT, MMAP_FLAGS_PROBE, -1, 0);
+    uintptr_t addr = (uintptr_t)p;
+    if ((addr >> LJ_ALLOC_MBITS) == 0 && addr >= LJ_ALLOC_MMAP_PROBE_LOWER &&
+	((addr + size) >> LJ_ALLOC_MBITS) == 0) {
+      /* We got a suitable address. Bump the hint address. */
+      hint_addr = addr + size;
       errno = olderr;
       return p;
     }
-    if (p != CMFAIL) munmap(p, size);
-#if defined(__sun__) || defined(__DragonFly__)
-    alloc_hint += 0x1000000;  /* Need near-exhaustive linear scan. */
-    if (alloc_hint + size < MMAP_REGION_END) continue;
-#endif
-    if (retry) break;
-    retry = 1;
-    alloc_hint = MMAP_REGION_START;
+    if (p != MFAIL) {
+      munmap(p, size);
+    } else if (errno == ENOMEM) {
+      return MFAIL;
+    }
+    if (hint_addr) {
+      /* First, try linear probing. */
+      if (retry < LJ_ALLOC_MMAP_PROBE_LINEAR) {
+	hint_addr += 0x1000000;
+	if (((hint_addr + size) >> LJ_ALLOC_MBITS) != 0)
+	  hint_addr = 0;
+	continue;
+      } else if (retry == LJ_ALLOC_MMAP_PROBE_LINEAR) {
+	/* Next, try a no-hint probe to get back an ASLR address. */
+	hint_addr = 0;
+	continue;
+      }
+    }
+    /* Finally, try pseudo-random probing. */
+    if (LJ_UNLIKELY(hint_prng == 0)) {
+      hint_prng = mmap_probe_seed();
+    }
+    /* The unsuitable address we got has some ASLR PRNG bits. */
+    hint_addr ^= addr & ~((uintptr_t)(LJ_PAGESIZE-1));
+    do {  /* The PRNG itself is very weak, but see above. */
+      hint_prng = hint_prng * 1103515245 + 12345;
+      hint_addr ^= hint_prng * (uintptr_t)LJ_PAGESIZE;
+      hint_addr &= (((uintptr_t)1 << LJ_ALLOC_MBITS)-1);
+    } while (hint_addr < LJ_ALLOC_MMAP_PROBE_LOWER);
   }
   errno = olderr;
-  return CMFAIL;
-}
-
+  return MFAIL;
+}
+
+#endif
+
+#if LJ_ALLOC_MMAP32
+
+#if defined(__sun__)
+#define LJ_ALLOC_MMAP32_START	((uintptr_t)0x1000)
 #else
-
-#error "NYI: need an equivalent of MAP_32BIT for this 64 bit OS"
-
-#endif
-
+#define LJ_ALLOC_MMAP32_START	((uintptr_t)0)
+#endif
+
+static void *mmap_map32(size_t size)
+{
+#if LJ_ALLOC_MMAP_PROBE
+  static int fallback = 0;
+  if (fallback)
+    return mmap_probe(size);
+#endif
+  {
+    int olderr = errno;
+    void *ptr = mmap((void *)LJ_ALLOC_MMAP32_START, size, MMAP_PROT, MAP_32BIT|MMAP_FLAGS, -1, 0);
+    errno = olderr;
+    /* This only allows 1GB on Linux. So fallback to probing to get 2GB. */
+#if LJ_ALLOC_MMAP_PROBE
+    if (ptr == MFAIL) {
+      fallback = 1;
+      return mmap_probe(size);
+    }
+#endif
+    return ptr;
+  }
+}
+
+#endif
+
+#if LJ_ALLOC_MMAP32
+#define CALL_MMAP(size)		mmap_map32(size)
+#elif LJ_ALLOC_MMAP_PROBE
+#define CALL_MMAP(size)		mmap_probe(size)
 #else
-
-/* 32 bit mode is easy. */
-static LJ_AINLINE void *CALL_MMAP(size_t size)
+static void *CALL_MMAP(size_t size)
 {
   int olderr = errno;
   void *ptr = mmap(NULL, size, MMAP_PROT, MMAP_FLAGS, -1, 0);
   errno = olderr;
   return ptr;
 }
-
-#endif
-
-#define INIT_MMAP()		((void)0)
-#define DIRECT_MMAP(s)		CALL_MMAP(s)
-
-static LJ_AINLINE int CALL_MUNMAP(void *ptr, size_t size)
+#endif
+
+#if LJ_64 && !LJ_GC64 && ((defined(__FreeBSD__) && __FreeBSD__ < 10) || defined(__FreeBSD_kernel__)) && !LJ_TARGET_PS4
+
+#include <sys/resource.h>
+
+static void init_mmap(void)
+{
+  struct rlimit rlim;
+  rlim.rlim_cur = rlim.rlim_max = 0x10000;
+  setrlimit(RLIMIT_DATA, &rlim);  /* Ignore result. May fail later. */
+}
+#define INIT_MMAP()	init_mmap()
+
+#endif
+
+static int CALL_MUNMAP(void *ptr, size_t size)
 {
   int olderr = errno;
   int ret = munmap(ptr, size);
@@ -280,10 +366,9 @@
   return ret;
 }
 
-#if LJ_TARGET_LINUX
+#if LJ_ALLOC_MREMAP
 /* Need to define _GNU_SOURCE to get the mremap prototype. */
-static LJ_AINLINE void *CALL_MREMAP_(void *ptr, size_t osz, size_t nsz,
-				     int flags)
+static void *CALL_MREMAP_(void *ptr, size_t osz, size_t nsz, int flags)
 {
   int olderr = errno;
   ptr = mremap(ptr, osz, nsz, flags);
@@ -294,13 +379,22 @@
 #define CALL_MREMAP(addr, osz, nsz, mv) CALL_MREMAP_((addr), (osz), (nsz), (mv))
 #define CALL_MREMAP_NOMOVE	0
 #define CALL_MREMAP_MAYMOVE	1
-#if LJ_64
+#if LJ_64 && !LJ_GC64
 #define CALL_MREMAP_MV		CALL_MREMAP_NOMOVE
 #else
 #define CALL_MREMAP_MV		CALL_MREMAP_MAYMOVE
 #endif
 #endif
 
+#endif
+
+
+#ifndef INIT_MMAP
+#define INIT_MMAP()		((void)0)
+#endif
+
+#ifndef DIRECT_MMAP
+#define DIRECT_MMAP(s)		CALL_MMAP(s)
 #endif
 
 #ifndef CALL_MREMAP

