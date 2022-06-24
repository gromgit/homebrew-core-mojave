class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.11.0.tar.gz"
  sha256 "209ad011736585f85723672ab8f8ecac73f325015eef04eb66ec3b9989dd4ef4"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/oil"
    sha256 mojave: "b3968c5db72b59fc9cc73423f2a3e35b1da181e29ead64a808a86f0e4e4e7bf4"
  end

  depends_on "readline"

  conflicts_with "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make"
    system "./install"
  end

  test do
    system "#{bin}/osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system "#{bin}/oil", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end
