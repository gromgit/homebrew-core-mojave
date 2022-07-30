class Plow < Formula
  desc "High-performance and real-time metrics displaying HTTP benchmarking tool"
  homepage "https://github.com/six-ddc/plow"
  url "https://github.com/six-ddc/plow/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "0ae69218fc61d4bc036a62f3cc8a4e5f29fad0edefe9e991f0446f71d9e6d9ba"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/plow"
    sha256 cellar: :any_skip_relocation, mojave: "1f8ae848ebca2e399e5069e35a71883e74ecc769fb05802a9a4cdc39cde075bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = "2xx"
    assert_match output.to_s, shell_output("#{bin}/plow -n 1 https://httpbin.org/get")
  end
end
