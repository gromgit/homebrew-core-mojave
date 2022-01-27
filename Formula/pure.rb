class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/v1.19.0.tar.gz"
  sha256 "fc5f21e3b2662ef26e7854ca0a88968b1f2911fae19b8efec75e9ea7877ea96b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "212aeb486a9f06ac07692e9cfd9a914354a443eef2b67fda44ce6594c78c15e2"
  end

  depends_on "zsh" => :test
  depends_on "zsh-async"

  def install
    zsh_function.install "pure.zsh" => "prompt_pure_setup"
  end

  test do
    zsh_command = "setopt prompt_subst; autoload -U promptinit; promptinit && prompt -p pure"
    assert_match "❯", shell_output("zsh -c '#{zsh_command}'")
  end
end
