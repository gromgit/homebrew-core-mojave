class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.21.3.tar.gz"
  sha256 "7172868464014bc09b687a70254c658b664d53abf17f07394c8d3692bb891722"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cadence"
    sha256 cellar: :any_skip_relocation, mojave: "681c0eb722373e5509f1f4a4b55fea30a84a0bb88fc33e5455814241185bdb2c"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args, "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
