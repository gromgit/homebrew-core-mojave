class Chezscheme < Formula
  desc "Implementation of the Chez Scheme language"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/archive/v9.5.8.tar.gz"
  sha256 "a00b1fb1c175dd51ab2efee298c3323f44fe901ab3ec6fbb6d7a3d9ef66bf989"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/chezscheme"
    rebuild 1
    sha256 mojave: "cdfb4373afcfa3ece76f1ce323ab9fdfc270a810b0fbd6e3f70a5effcd1fe160"
  end

  depends_on "libx11" => :build
  depends_on arch: :x86_64 # https://github.com/cisco/ChezScheme/issues/544
  depends_on "xterm"
  uses_from_macos "ncurses"

  def install
    inreplace "configure", "/opt/X11", Formula["libx11"].opt_prefix
    inreplace Dir["c/Mf-*osx"], "/opt/X11", Formula["libx11"].opt_prefix
    inreplace "c/version.h", "/usr/X11R6", Formula["libx11"].opt_prefix
    inreplace "c/expeditor.c", "/usr/X11/bin/resize", Formula["xterm"].opt_bin/"resize"

    system "./configure",
              "--installprefix=#{prefix}",
              "--threads",
              "--installschemename=chez"
    system "make", "install"
  end

  test do
    (testpath/"hello.ss").write <<~EOS
      (display "Hello, World!") (newline)
    EOS

    expected = <<~EOS
      Hello, World!
    EOS

    assert_equal expected, shell_output("#{bin}/chez --script hello.ss")
  end
end
