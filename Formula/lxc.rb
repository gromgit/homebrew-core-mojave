class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.20.tar.gz"
  sha256 "35504ef2e2dc7024b7088010987657969b1e2dea5581b24b4294f8f449248ed5"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lxc"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "a8549a40750364633f9d941b486758591ff4d704586f2d98c6b1eaf3063a6c62"
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin

    system "go", "build", *std_go_args, "./lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
