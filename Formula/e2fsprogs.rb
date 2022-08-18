class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.46.5/e2fsprogs-1.46.5.tar.gz"
  sha256 "b7430d1e6b7b5817ce8e36d7c8c7c3249b3051d0808a96ffd6e5c398e4e2fbb9"
  license all_of: [
    "GPL-2.0-or-later",
    "LGPL-2.0-or-later", # lib/ex2fs
    "LGPL-2.0-only",     # lib/e2p
    "BSD-3-Clause",      # lib/uuid
    "MIT",               # lib/et, lib/ss
  ]
  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/e2fsprogs[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/e2fsprogs"
    sha256 mojave: "885282f2be9495f7024fc79ccc5461e8a273e2bcfacaab6d2c4e03560fa5353e"
  end

  keg_only "this installs several executables which shadow macOS system commands"

  depends_on "pkg-config" => :build
  depends_on "gettext"

  # Remove `-flat_namespace` flag and fix M1 shared library build.
  # Sent via email to theodore.tso@gmail.com
  patch :DATA

  def install
    # Enforce MKDIR_P to work around a configure bug
    # see https://github.com/Homebrew/homebrew-core/pull/35339
    # and https://sourceforge.net/p/e2fsprogs/discussion/7053/thread/edec6de279/
    args = [
      "--prefix=#{prefix}",
      "--sysconfdir=#{etc}",
      "--disable-e2initrd-helper",
      "MKDIR_P=mkdir -p",
    ]
    args << if OS.linux?
      "--enable-elf-shlibs"
    else
      "--enable-bsd-shlibs"
    end

    system "./configure", *args

    system "make"

    # Fix: lib/libcom_err.1.1.dylib: No such file or directory
    ENV.deparallelize

    system "make", "install"
    system "make", "install-libs"
  end

  test do
    assert_equal 36, shell_output("#{bin}/uuidgen").strip.length
    system bin/"lsattr", "-al"
  end
end

__END__
diff --git a/lib/Makefile.darwin-lib b/lib/Makefile.darwin-lib
index 95cdd4b..95e8ee0 100644
--- a/lib/Makefile.darwin-lib
+++ b/lib/Makefile.darwin-lib
@@ -24,7 +24,8 @@ image:		$(BSD_LIB)
 $(BSD_LIB): $(OBJS)
 	$(E) "	GEN_BSD_SOLIB $(BSD_LIB)"
 	$(Q) (cd pic; $(CC) -dynamiclib -compatibility_version 1.0 -current_version $(BSDLIB_VERSION) \
-		-flat_namespace -undefined warning -o $(BSD_LIB) $(OBJS))
+		-install_name $(BSDLIB_INSTALL_DIR)/$(BSD_LIB) \
+		-undefined dynamic_lookup -o $(BSD_LIB) $(OBJS))
 	$(Q) $(MV) pic/$(BSD_LIB) .
 	$(Q) $(RM) -f ../$(BSD_LIB)
 	$(Q) (cd ..; $(LN) $(LINK_BUILD_FLAGS) \
