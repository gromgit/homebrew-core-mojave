class Makefile2graph < Formula
  desc "Create a graph of dependencies from GNU-Make"
  homepage "https://github.com/lindenb/makefile2graph"
  url "https://github.com/lindenb/makefile2graph/archive/2021.11.06.tar.gz"
  sha256 "5be8e528fa2945412357a8ef233e68fa3729639307ec1c38fd63768aad642c41"
  license "MIT"
  head "https://github.com/lindenb/makefile2graph.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/makefile2graph"
    sha256 cellar: :any_skip_relocation, mojave: "aa23de1f35d4d1fa480d5a7f342bc98550bff7a4d766fdd90178daf8046aa1ba"
  end

  depends_on "graphviz"

  def install
    system "make"
    system "make", "test"
    bin.install "make2graph", "makefile2graph"
    man1.install "make2graph.1", "makefile2graph.1"
    doc.install "LICENSE", "README.md", "screenshot.png"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: foo
      all: bar
      foo: ook
      bar: ook
      ook:
    EOS
    system "make -Bnd >make-Bnd"
    system "#{bin}/make2graph <make-Bnd"
    system "#{bin}/make2graph --root <make-Bnd"
    system "#{bin}/makefile2graph"
  end
end
