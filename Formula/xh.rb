class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "ca89e8a9a230ff16cc0bba5bd7ebdceb986eac84638e15b4928d737b9ec12776"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xh"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "29c8c5ea32a78ca04e01919d4bc5043579ecf8d0828445564e4be04b8eb5e87c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"xh" => "xhs"

    man1.install "doc/xh.1"
    bash_completion.install "completions/xh.bash"
    fish_completion.install "completions/xh.fish"
    zsh_completion.install "completions/_xh"
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/xh -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end
