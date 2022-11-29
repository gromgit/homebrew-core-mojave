class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.12.0.tar.gz"
  sha256 "f1acc15d0fd0cb431f4bf6eac32d5e932e40ea1186fe78e074254d6d003957bb"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libvpx.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libvpx"
    rebuild 3
    sha256 cellar: :any, mojave: "a2c2ffd63b4326b0cd64f77cce2233a19f520b1a89c1af5a7282519cac8c0351"
  end

  on_intel do
    depends_on "yasm" => :build
  end

  # Patch for macOS Ventura
  # Reported upstream: https://groups.google.com/a/webmproject.org/g/codec-devel/c/ofpypqweL5U
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-examples
      --disable-unit-tests
      --enable-pic
      --enable-shared
      --enable-vp9-highbitdepth
    ]

    if Hardware::CPU.intel?
      ENV.runtime_cpu_detection
      args << "--enable-runtime-cpu-detect"
    end

    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end

  test do
    system "ar", "-x", "#{lib}/libvpx.a"
  end
end

__END__
diff --git a/build/make/configure.sh b/build/make/configure.sh
index 581042e38..fac9ea57b 100644
--- a/build/make/configure.sh
+++ b/build/make/configure.sh
@@ -791,7 +791,7 @@ process_common_toolchain() {
         tgt_isa=x86_64
         tgt_os=`echo $gcctarget | sed 's/.*\(darwin1[0-9]\).*/\1/'`
         ;;
-      *darwin2[0-1]*)
+      *darwin2[0-9]*)
         tgt_isa=`uname -m`
         tgt_os=`echo $gcctarget | sed 's/.*\(darwin2[0-9]\).*/\1/'`
         ;;
@@ -940,7 +940,7 @@ process_common_toolchain() {
       add_cflags  "-mmacosx-version-min=10.15"
       add_ldflags "-mmacosx-version-min=10.15"
       ;;
-    *-darwin2[0-1]-*)
+    *-darwin2[0-9]-*)
       add_cflags  "-arch ${toolchain%%-*}"
       add_ldflags "-arch ${toolchain%%-*}"
       ;;
diff --git a/configure b/configure
index 1b850b5e0..bf92e1ad1 100755
--- a/configure
+++ b/configure
@@ -101,6 +101,7 @@ all_platforms="${all_platforms} arm64-android-gcc"
 all_platforms="${all_platforms} arm64-darwin-gcc"
 all_platforms="${all_platforms} arm64-darwin20-gcc"
 all_platforms="${all_platforms} arm64-darwin21-gcc"
+all_platforms="${all_platforms} arm64-darwin22-gcc"
 all_platforms="${all_platforms} arm64-linux-gcc"
 all_platforms="${all_platforms} arm64-win64-gcc"
 all_platforms="${all_platforms} arm64-win64-vs15"
@@ -157,6 +158,7 @@ all_platforms="${all_platforms} x86_64-darwin18-gcc"
 all_platforms="${all_platforms} x86_64-darwin19-gcc"
 all_platforms="${all_platforms} x86_64-darwin20-gcc"
 all_platforms="${all_platforms} x86_64-darwin21-gcc"
+all_platforms="${all_platforms} x86_64-darwin22-gcc"
 all_platforms="${all_platforms} x86_64-iphonesimulator-gcc"
 all_platforms="${all_platforms} x86_64-linux-gcc"
 all_platforms="${all_platforms} x86_64-linux-icc"
