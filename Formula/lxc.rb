class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-5.2.tar.gz"
  sha256 "e22d2b34a1848d33b2080b2b1c82355afb6d36fdfe49e67f44b3749edbc02e4c"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lxc"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "ee6be1b24d770d3aefee8bd54d427443ec03dd19c7e4ba168ee5938af6b3d99a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./lxc"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]
  end
end
