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
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "905931fe55d9f4a6ad21579ca076dc1135bdfe01b163ee73dec862ef2e2c2b98"
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
