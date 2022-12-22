class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/old/hevea-2.36.tar.gz"
  sha256 "5d6759d7702a295c76a12c1b2a1a16754ab0ec1ffed73fc9d0b138b41e720648"
  license all_of: [
    "QPL-1.0", # source files
    "GPL-2.0-only", # binaries
  ]

  livecheck do
    url "http://hevea.inria.fr/old/"
    regex(/href=.*?hevea[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hevea"
    rebuild 1
    sha256 mojave: "ecee1377c816c370a9a0b5db287c427bea43e42513660dde4e3e30630851826a"
  end

  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  def install
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\begin{document}
      \\end{document}
    EOS
    system "#{bin}/hevea", "test.tex"
  end
end
