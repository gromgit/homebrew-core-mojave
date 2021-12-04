class Chezscheme < Formula
  desc "Implementation of the Chez Scheme language"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/archive/v9.5.6.tar.gz"
  sha256 "e23c556493f9a661852ea046f3317500feac5f223ea6ef3aa3b9234567e14c0e"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/chezscheme"
    rebuild 2
    sha256 mojave: "b544479c43272ac36d2e6f6437aa6d5d07030738a63e141637ac75c30c26b08a"
  end

  depends_on "libx11" => :build
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
