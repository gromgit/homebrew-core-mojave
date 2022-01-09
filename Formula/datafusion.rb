class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/6.0.0.tar.gz"
  sha256 "a40f74060a8b9fdb4b630a57c2b36f02961fa9759f1fa0d6568e34e12348dc5f"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/datafusion"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "38d1d78a85e4abcf469ae0077218335d6b011658c30f4ad84b20cf09125393c1"
  end

  depends_on "rust" => :build
  # building ballista requires installing rustfmt
  depends_on "rustfmt" => :build

  # Fix https://github.com/apache/arrow-datafusion/issues/1498, remove after next release
  # Patch is equivalent to https://github.com/apache/arrow-datafusion/pull/1499,
  # but does not apply cleanly
  patch :DATA

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end

__END__
diff --git a/ballista/rust/core/Cargo.toml b/ballista/rust/core/Cargo.toml
index 3d15e21e..9e9ad658 100644
--- a/ballista/rust/core/Cargo.toml
+++ b/ballista/rust/core/Cargo.toml
@@ -43,6 +43,7 @@ tonic = "0.5"
 uuid = { version = "0.8", features = ["v4"] }
 chrono = "0.4"

+quote = "=1.0.10"
 arrow-flight = { version = "6.1.0"  }

 datafusion = { path = "../../../datafusion", version = "6.0.0" }
