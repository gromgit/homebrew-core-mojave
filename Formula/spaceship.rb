class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.6.0.tar.gz"
  sha256 "30e67f867262606db5d7f9a108b62a75a360e202074337f122ca6459368e5668"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/spaceship"
    sha256 cellar: :any_skip_relocation, mojave: "88e804c48c8277db7d6fae777afb205468864fdbf5a5813d5bcefbd05c083301"
  end

  depends_on "zsh-async"
  uses_from_macos "zsh" => :test

  def install
    system "make", "compile"
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate Spaceship, add the following line to ~/.zshrc:
        source "#{opt_prefix}/spaceship.zsh"
      If your .zshrc sets ZSH_THEME, remove that line.
    EOS
  end

  test do
    assert_match "SUCCESS",
      shell_output("zsh -fic '. #{opt_prefix}/spaceship.zsh && (( ${+SPACESHIP_VERSION} )) && echo SUCCESS'")
  end
end
