class Multitail < Formula
  desc "Tail multiple files in one terminal simultaneously"
  homepage "https://vanheusden.com/multitail/"
  url "https://github.com/folkertvanheusden/multitail/archive/refs/tags/7.0.0.tar.gz"
  sha256 "23f85f417a003544be38d0367c1eab09ef90c13d007b36482cf3f8a71f9c8fc5"
  license "Apache-2.0"
  head "https://github.com/folkertvanheusden/multitail.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/multitail"
    sha256 cellar: :any, mojave: "ce0c2b47c675915500bbeb42ad55a6607ed842c35e6ab0e2b619adcc1686b827"
  end

  depends_on "pkg-config" => :build
  depends_on "ncurses"

  def install
    system "make", "-f", "makefile.macosx", "multitail", "DESTDIR=#{HOMEBREW_PREFIX}"

    bin.install "multitail"
    man1.install gzip("multitail.1")
    etc.install "multitail.conf"
  end

  test do
    if build.head?
      assert_match "multitail", shell_output("#{bin}/multitail -h 2>&1", 1)
    else
      assert_match version.to_s, shell_output("#{bin}/multitail -h 2>&1", 1)
    end
  end
end
