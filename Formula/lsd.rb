class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.21.0.tar.gz"
  sha256 "f500c18221f9c3fd45f88f6f764001e99cf9d6d74af9172cbb9a9ff32f3e5c7d"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lsd"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a8326f59eb31f51e4d953dc5aa9c2ebbb8202af2bd35dee1d196b12216d20601"
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
