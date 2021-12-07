class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.3.0.tar.gz"
  sha256 "3c5a8a03c4f6ade73b92432ed0ba51591db19b0d136073fa3ccfa99d63403d52"
  license "Apache-2.0"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fd"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "784babca4b12d8c610326a9af36337ea3e91094202011ec9a96fbc7bd9a52dc5"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    man1.install "doc/fd.1"
    bash_completion.install "fd.bash"
    fish_completion.install "fd.fish"
    zsh_completion.install "contrib/completion/_fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "./test_file", shell_output("#{bin}/fd test").chomp
  end
end
