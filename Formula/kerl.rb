class Kerl < Formula
  desc "Easy building and installing of Erlang/OTP instances"
  homepage "https://github.com/kerl/kerl"
  url "https://github.com/kerl/kerl/archive/2.5.0.tar.gz"
  sha256 "c2aec85632e779e12865fb147d4105204d1aa46519b6f1bfe0ee8f9041f27358"
  license "MIT"
  head "https://github.com/kerl/kerl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c71510065b9fdf6189134235cf24ae5e77213bd0f068318828c8516f6c49c2b7"
  end

  def install
    bin.install "kerl"
    bash_completion.install "bash_completion/kerl"
    zsh_completion.install "zsh_completion/_kerl"
  end

  test do
    system "#{bin}/kerl", "list", "releases"
  end
end
