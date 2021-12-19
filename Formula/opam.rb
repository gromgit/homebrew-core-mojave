class Opam < Formula
  desc "OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.1.2/opam-full-2.1.2.tar.gz"
  sha256 "de1e3efffd5942e0101ef83dcdead548cc65a93e13986aecb4a264a059457ede"
  license "LGPL-2.1-only"
  head "https://github.com/ocaml/opam.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/opam"
    sha256 cellar: :any_skip_relocation, mojave: "a17d05c3c4ae20a9b7ac41acf070ab6104479e03cd4e5754b7701ce177c7d75e"
  end

  depends_on "ocaml" => [:build, :test]
  depends_on "gpatch"

  uses_from_macos "unzip"

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "lib-ext"
    system "make"
    system "make", "install"

    bash_completion.install "src/state/shellscripts/complete.sh" => "opam"
    zsh_completion.install "src/state/shellscripts/complete.zsh" => "_opam"
  end

  def caveats
    <<~EOS
      OPAM uses ~/.opam by default for its package database, so you need to
      initialize it first by running:

      $ opam init
    EOS
  end

  test do
    system bin/"opam", "init", "--auto-setup", "--disable-sandboxing"
    system bin/"opam", "list"
  end
end
