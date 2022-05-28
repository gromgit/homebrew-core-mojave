class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "c1fd4f33be96ba1c19580fc66dd9d059a716f00f532a516e159ce9342e50cd43"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xh"
    sha256 cellar: :any_skip_relocation, mojave: "d58b052e613110b8bbac7be97fcdd46b45574ad8bb00933b36cdccf7d4aeb22b"
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
