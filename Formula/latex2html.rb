class Latex2html < Formula
  desc "LaTeX-to-HTML translator"
  homepage "https://www.latex2html.org"
  url "https://github.com/latex2html/latex2html/archive/v2022.2.tar.gz"
  sha256 "b1d5bba7bab7d0369d1241f2d8294137a52b7cb7df11239bfa15ec0a2546c093"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/latex2html"
    sha256 cellar: :any_skip_relocation, mojave: "2a19ab2808dc02fcc1dcae4181a62f2e93af9ec2354d3ce1de95881a7a4008cd"
  end

  depends_on "ghostscript"
  depends_on "netpbm"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--without-mktexlsr",
                          "--with-texpath=#{share}/texmf/tex/latex/html"
    system "make", "install"
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\usepackage[utf8]{inputenc}
      \\title{Experimental Setup}
      \\date{\\today}
      \\begin{document}
      \\maketitle
      \\end{document}
    EOS
    system "#{bin}/latex2html", "test.tex"
    assert_match "Experimental Setup", File.read("test/test.html")
  end
end
