class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.0.3/fiber-3.0.3.tbz"
  sha256 "d504499a1658f0d99caefbffd7386f2e31d46ceca73167157fe4686c41e5732f"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dune"
    sha256 cellar: :any_skip_relocation, mojave: "636d2928d814fbd7d4dbdf3b317e0343e96f71d86518c1511c474f21738b1b3b"
  end

  depends_on "ocaml" => [:build, :test]

  def install
    system "make", "release"
    system "make", "PREFIX=#{prefix}", "install"
    share.install prefix/"man"
    elisp.install Dir[share/"emacs/site-lisp/*"]
  end

  test do
    contents = "bar"
    target_fname = "foo.txt"
    (testpath/"dune").write("(rule (with-stdout-to #{target_fname} (echo #{contents})))")
    system bin/"dune", "build", "foo.txt", "--root", "."
    output = File.read(testpath/"_build/default/#{target_fname}")
    assert_match contents, output
  end
end
