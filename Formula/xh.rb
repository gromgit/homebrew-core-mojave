class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "d6ec84977da567dd36a4c59d624dc1e2b1c77a21e2b0a10e463216120be8112d"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xh"
    sha256 cellar: :any_skip_relocation, mojave: "b9ae1cce6a2cd56e4e65ec93d763bed802d1960294a11d74438b2bd25a1881f8"
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
