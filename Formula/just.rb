class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/0.10.3.tar.gz"
  sha256 "10ee1caaedb2e92257338942fce146e5d3aadd6f9f5e98fbc21e422e2d863169"
  license "CC0-1.0"
  head "https://github.com/casey/just.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/just"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "82a3bfc8a8b3709abe52c6566362ea3346158f12a61869f80035aba2e9236614"
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
