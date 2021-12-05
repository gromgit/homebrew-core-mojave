class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/6.0.0.tar.gz"
  sha256 "a40f74060a8b9fdb4b630a57c2b36f02961fa9759f1fa0d6568e34e12348dc5f"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/datafusion"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "0d1bba5d2f28e3febde32a7795a6fa56ef456e1cf1fd018b8eafe7acc913d397"
  end

  depends_on "rust" => :build
  # building ballista requires installing rustfmt
  depends_on "rustfmt" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
