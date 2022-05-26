class Plow < Formula
  desc "High-performance and real-time metrics displaying HTTP benchmarking tool"
  homepage "https://github.com/six-ddc/plow"
  url "https://github.com/six-ddc/plow/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "bd57418d6842ae79a675ede027cd986d1e719edb163febfaec812d1a7cde4304"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/plow"
    sha256 cellar: :any_skip_relocation, mojave: "af07b6bd0d20f7cce797f6b30df72591d081432ea17d3c85ed3cc8e5f8bc6f48"
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
