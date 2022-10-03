class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "https://crosstool-ng.github.io/"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.25.0.tar.xz"
  sha256 "68162f342243cd4189ed7c1f4e3bb1302caa3f2cbbf8331879bd01fe06c60cd3"
  license "GPL-2.0-only"
  head "https://github.com/crosstool-ng/crosstool-ng.git", branch: "master"

  livecheck do
    url "https://crosstool-ng.github.io/download/"
    regex(/href=.*?crosstool-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/crosstool-ng"
    rebuild 1
    sha256 cellar: :any, mojave: "09e92b8b3709c30185bddd68fda5b15ed97710e043a1249931f1ca985343621a"
  end

  depends_on "help2man" => :build
  depends_on "autoconf"
  depends_on "automake"
  depends_on "binutils"
  depends_on "bison"
  depends_on "flex"
  depends_on "gettext"
  depends_on "libtool"
  depends_on "lzip"
  depends_on "m4"
  depends_on "ncurses"
  depends_on "python@3.10"
  depends_on "xz"

  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "texinfo" => :build
  uses_from_macos "unzip" => :build

  on_macos do
    depends_on "bash"
    depends_on "coreutils"
    depends_on "gawk"
    depends_on "gnu-sed"
    depends_on "grep"
    depends_on "make"
  end

  def install
    system "./bootstrap" if build.head?

    ENV["BISON"] = Formula["bison"].opt_bin/"bison"
    ENV["M4"] = Formula["m4"].opt_bin/"m4"
    ENV["PYTHON"] = Formula["python@3.10"].opt_bin/"python3.10"

    if OS.mac?
      ENV["MAKE"] = Formula["make"].opt_bin/"gmake"
      ENV.append "LDFLAGS", "-lintl"
    else
      ENV.append "CFLAGS", "-I#{Formula["ncurses"].include}/ncursesw"
    end

    system "./configure", "--prefix=#{prefix}"

    # Must be done in two steps
    system "make"
    system "make", "install"

    inreplace [bin/"ct-ng", pkgshare/"paths.sh"], Superenv.shims_path/"make", "make" unless OS.mac?
  end

  test do
    assert_match "This is crosstool-NG", shell_output("make -rf #{bin}/ct-ng version")
  end
end
