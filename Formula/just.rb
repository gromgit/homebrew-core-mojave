class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/0.10.4.tar.gz"
  sha256 "81d7e7d5496861a37f8668dbeb845381c41ea0ef5fa087c7b8bd41b70134218d"
  license "CC0-1.0"
  head "https://github.com/casey/just.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/just"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "4272abc5c174e4c127030df72a73eccbff2258f541a8c35a8cd6cad1591b43fe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
