class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "6abc32e2fa49a3c7a08379dbe7375735ec7bc8f25c3f29774e275e9dcac42711"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xh"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "4a8ed0753ec212a30a8d80db1a226fa5d338a150c82bf6f9094868047d7c561c"
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
