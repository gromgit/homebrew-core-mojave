class Hspell < Formula
  desc "Free Hebrew linguistic project"
  homepage "http://hspell.ivrix.org.il/"
  url "http://hspell.ivrix.org.il/hspell-1.4.tar.gz"
  sha256 "7310f5d58740d21d6d215c1179658602ef7da97a816bc1497c8764be97aabea3"
  license "AGPL-3.0-only"

  livecheck do
    url "http://hspell.ivrix.org.il/download.html"
    regex(/href=.*?hspell[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "743ad6762f4452a62702961c030950a6d70d36877140dd8728ce45f8d06411c3"
    sha256 arm64_big_sur:  "421fdc3ab5d0ebde258ce7bdb235d2b50144966a27a74cbbe5c607dff0984c7f"
    sha256 monterey:       "21abb651324e2e46eae76ae915efe203f198a7a74f7c9144b3d21060fc5a2dfd"
    sha256 big_sur:        "426c87d91350f33392c862296b5d1b0081bc953adae5c04a9769ebb2a626213f"
    sha256 catalina:       "a0406d5a4d5adefa40b5e820510a9b7f461fcea6a61112103c112775fff49ae8"
    sha256 mojave:         "32e8037e9d494241b975c7558635456991285d53c9bbc89005cd6c86744f30e3"
    sha256 x86_64_linux:   "fd7cae8024a97aadce0f713008dba1f27e7254969f689a21c9501d42be84fcdb"
  end

  depends_on "autoconf" => :build

  uses_from_macos "zlib"

  # hspell was built for linux and compiles a .so shared library, to comply with macOS
  # standards this patch creates a .dylib instead
  patch :p0 do
    on_macos do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/hspell/1.3.patch"
      sha256 "63cc1bc753b1062d1144dcdd959a0a8f712b8872dce89e54ddff2d24f2ca2065"
    end
  end

  def install
    ENV.deparallelize

    # The build scripts rely on "." being in @INC which was disabled by default in perl 5.26
    ENV["PERL_USE_UNSAFE_INC"] = "1"

    # autoconf needs to pick up on the patched configure.in and create a new ./configure
    # script
    system "autoconf"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "--enable-linginfo"
    system "make", "dolinginfo"
    system "make", "install"
  end

  test do
    File.open("test.txt", "w:ISO8859-8") do |f|
      f.write "שלום"
    end
    system "#{bin}/hspell", "-l", "test.txt"
  end
end
