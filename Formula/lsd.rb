class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.22.0.tar.gz"
  sha256 "30ad1b1d014c7b6a2fca44c6de3b17198c84168d34fc946245d67094ebc0f7ed"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lsd"
    sha256 cellar: :any_skip_relocation, mojave: "524a82223362079f15a8144aa1ae0821ebcac4b6c0cb224961361246537ae3ff"
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
