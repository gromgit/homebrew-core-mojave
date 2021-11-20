class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/5.0.0.tar.gz"
  sha256 "7ba05bba8b7ea3b1f7ff6b3d1b1a3413a81540c57342ef331d51a07ad4a7b7a8"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/datafusion"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "8dfd23abf8b119f115988528a3aadce18a0f91603793c9decb5456e9f81f47c2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
