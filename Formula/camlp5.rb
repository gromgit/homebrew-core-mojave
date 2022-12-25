class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "https://camlp5.github.io/"
  url "https://github.com/camlp5/camlp5/archive/refs/tags/rel8.00.04.tar.gz"
  sha256 "bddbcb5c3c2d410c9a61c4dfb6e46e3bbe984d25ac68221a7a65c82a29956b1d"
  license "BSD-3-Clause"
  head "https://github.com/camlp5/camlp5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^rel[._-]?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/camlp5"
    sha256 mojave: "a2874084738d56aa92b7a8b27403dad7bae7e892f97519433b66ffcbd4cd7c46"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "camlp-streams"
  depends_on "ocaml"

  def install
    system "./configure", "--prefix", prefix, "--mandir", man
    system "make", "world.opt"
    system "make", "install"
    (lib/"ocaml/camlp5").install "etc/META"
  end

  test do
    ocaml = Formula["ocaml"]
    (testpath/"hi.ml").write "print_endline \"Hi!\";;"
    assert_equal "let _ = print_endline \"Hi!\"",
      # The purpose of linking with the file "bigarray.cma" is to ensure that the
      # ocaml files are in sync with the camlp5 files.  If camlp5 has been
      # compiled with an older version of the ocaml compiler, then an error
      # "interface mismatch" will occur.
      shell_output("#{bin}/camlp5 #{lib}/ocaml/camlp5/pa_o.cmo #{lib}/ocaml/camlp5/pr_o.cmo " \
                   "#{ocaml.opt_lib}/ocaml/bigarray.cma hi.ml")
  end
end
