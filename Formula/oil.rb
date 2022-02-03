class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.9.7.tar.gz"
  sha256 "5c0574bd8926914edf5d8b0c29e7a39f83ce8be81c11c35c8ff5213d79a03426"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/oil"
    sha256 mojave: "365f459e9ece21826184dbd05366ee7f322cd3221ad8b996719f9853e33bc705"
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

    system "#{bin}/oil", "-c", "shopt -q parse_equals"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end
