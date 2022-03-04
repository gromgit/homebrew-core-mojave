class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.5.0.tar.gz"
  sha256 "bc28ecb1cc78c9446d67d9ec3e4333691802adcf3bbfd430ba3c548c5415af40"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dsq"
    sha256 cellar: :any_skip_relocation, mojave: "c779ed2ee878cb4ee7add148aadaa1bce8ebbe58cbc786fe792a92a88fdd11bb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    pkgshare.install "testdata/userdata.json"
  end

  test do
    query = "\"SELECT count(*) as c FROM {} WHERE State = 'Maryland'\""
    output = shell_output("#{bin}/dsq #{pkgshare}/userdata.json #{query}")
    assert_match "[{\"c\":19}]", output
  end
end
