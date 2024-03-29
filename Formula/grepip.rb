class Grepip < Formula
  desc "Filters IPv4 & IPv6 addresses with a grep-compatible interface"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/grepip-1.2.1.tar.gz"
  sha256 "e1c838ecac436e744b7808bf3a123be8ce6b72cc436dead64a0a13f409804ea8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^grepip[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/grepip"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "449bdd98a6260dc93a60b25f86531ea0106978931ac92ef7c0d1c57dcd48affa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./grepip"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/grepip --version").chomp
    assert_equal "1.1.1.1", pipe_output("#{bin}/grepip -o", "asdf 1.1.1.1 asdf").chomp

    (testpath/"access.log").write <<~EOS
      127.0.0.1 valid ip but reserved
      111.119.187.44 valid ip
      8.8.8. invalid ip
      no ip
    EOS
    output = shell_output("#{bin}/grepip --exclude-reserved -h access.log")
    assert_equal "111.119.187.44 valid ip", output.strip
  end
end
