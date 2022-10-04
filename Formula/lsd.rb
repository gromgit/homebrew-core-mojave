class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.23.1.tar.gz"
  sha256 "9698919689178cc095f39dcb6a8a41ce32d5a1283e6fe62755e9a861232c307d"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lsd"
    sha256 cellar: :any_skip_relocation, mojave: "87232334fc8e150df30ba672643d34a358411e03c385d66bce08722bf76cbe60"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    bash_completion.install "lsd.bash"
    fish_completion.install "lsd.fish"
    zsh_completion.install "_lsd"
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
