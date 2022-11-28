class Dune < Formula
  desc "Composable build system for OCaml"
  homepage "https://dune.build/"
  url "https://github.com/ocaml/dune/releases/download/3.6.1/dune-3.6.1.tbz"
  sha256 "f1d5ac04b7a027f3d549e25cf885ebf7acc135e0291c18e6b43123a799c143ce"
  license "MIT"
  head "https://github.com/ocaml/dune.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dune"
    sha256 cellar: :any_skip_relocation, mojave: "181523e30f2cbb07f6700d850fda60012119e1fc16105cdf8a3fabd8a5bd3dfa"
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
