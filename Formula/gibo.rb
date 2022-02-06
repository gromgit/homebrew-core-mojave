class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/2.2.6.tar.gz"
  sha256 "0a4b3a9063ac8724a2deda5b47ac8324e01905b794330a0c40ea9e972022f01e"
  license "Unlicense"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gibo"
    sha256 cellar: :any_skip_relocation, mojave: "473b0891bf471637cb3d0bd53e44cefd3e32abe1d596579a9cf243ed3f589288"
  end

  def install
    bin.install "gibo"
    bash_completion.install "shell-completions/gibo-completion.bash"
    zsh_completion.install "shell-completions/gibo-completion.zsh" => "_gibo"
    fish_completion.install "shell-completions/gibo.fish"
  end

  test do
    system "#{bin}/gibo", "update"
    assert_includes shell_output("#{bin}/gibo dump Python"), "Python.gitignore"
  end
end
