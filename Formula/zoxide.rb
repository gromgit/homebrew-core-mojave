class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.8.3.tar.gz"
  sha256 "eb1839a4ab0ce7680c5a97dc753d006d5604b71c41a77047e981a439ac3b9de6"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/zoxide"
    sha256 cellar: :any_skip_relocation, mojave: "e0fe35e9cca5f600950de6fd02542d64d78a27423b776cd14b3c50c176f881ee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "contrib/completions/zoxide.bash" => "zoxide"
    zsh_completion.install "contrib/completions/_zoxide"
    fish_completion.install "contrib/completions/zoxide.fish"
    share.install "man"
  end

  test do
    assert_equal "", shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
