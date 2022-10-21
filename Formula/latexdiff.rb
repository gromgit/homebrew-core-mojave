class Latexdiff < Formula
  desc "Compare and mark up LaTeX file differences"
  homepage "https://www.ctan.org/pkg/latexdiff"
  url "https://github.com/ftilmann/latexdiff/releases/download/1.3.3/latexdiff-1.3.3.tar.gz"
  sha256 "79619ad9ac53b81e9f37e0dd310bb7e4c2497506f1ffe483582f6c564572cb36"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/latexdiff"
    sha256 cellar: :any_skip_relocation, mojave: "1d9555dcabb14322349dd93128d81078dfc4326878532173f184c8f9dbb61757"
  end

  # osx default perl cause compilation error
  depends_on "perl"

  def install
    bin.install %w[latexdiff-fast latexdiff-so latexdiff-vc latexrevise]
    man1.install %w[latexdiff-vc.1 latexdiff.1 latexrevise.1]
    doc.install Dir["doc/*"]
    pkgshare.install %w[contrib example]

    # Install latexdiff-so (with inlined Algorithm::Diff) as the
    # preferred version, more portable
    bin.install_symlink "latexdiff-so" => "latexdiff"
  end

  test do
    (testpath/"test1.tex").write <<~EOS
      \\documentclass{article}
      \\begin{document}
      Hello, world.
      \\end{document}
    EOS

    (testpath/"test2.tex").write <<~EOS
      \\documentclass{article}
      \\begin{document}
      Goodnight, moon.
      \\end{document}
    EOS

    expect = /^\\DIFdelbegin \s+
             \\DIFdel      \{ Hello,[ ]world \}
             \\DIFdelend   \s+
             \\DIFaddbegin \s+
             \\DIFadd      \{ Goodnight,[ ]moon \}
             \\DIFaddend   \s+
             \.$/x
    assert_match expect, shell_output("#{bin}/latexdiff test[12].tex")
  end
end
