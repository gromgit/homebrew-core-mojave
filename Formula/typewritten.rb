class Typewritten < Formula
  desc "Minimal zsh prompt"
  homepage "https://typewritten.dev"
  url "https://github.com/reobin/typewritten/archive/v1.5.0.tar.gz"
  sha256 "0e05ced82a53776da05e49c898ae211e3b2939df1707afa2c1ac1b0358561113"
  license "MIT"
  head "https://github.com/reobin/typewritten.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0561ef935eb07b69c7d71ec06e2b9a043b92d7f974107e548785d2f27f9e429"
  end

  depends_on "zsh" => :test

  def install
    libexec.install "typewritten.zsh", "async.zsh", "lib"
    zsh_function.install_symlink libexec/"typewritten.zsh" => "prompt_typewritten_setup"
  end

  test do
    prompt = "setopt prompt_subst; autoload -U promptinit; promptinit && prompt -p typewritten"
    assert_match "❯", shell_output("zsh -c '#{prompt}'")
  end
end
