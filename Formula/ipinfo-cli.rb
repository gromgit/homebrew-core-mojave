class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-2.6.1.tar.gz"
  sha256 "58f856b63fdf1c03c83514e7479c8b5fb301c3706435f541aaf031ed9be47a53"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ipinfo-cli"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "d9d8a995c476ae7a257074bde46524535d94b7b5c4c8d339bf86a95ac5c881f6"
  end

  depends_on "go" => :build

  conflicts_with "ipinfo", because: "ipinfo and ipinfo-cli install the same binaries"

  def install
    system "./ipinfo/build.sh"
    bin.install "build/ipinfo"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ipinfo version").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3\n", `#{bin}/ipinfo prips 1.1.1.1/30`
  end
end
