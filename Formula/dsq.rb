class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.10.0.tar.gz"
  sha256 "a5cd99c32d5ffa63736aa272455a0a5172e1820f9275f053e2de80fcae7a67e1"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dsq"
    sha256 cellar: :any_skip_relocation, mojave: "199e38945c151d4675e3b3dacf685c8b306e2bfba74ee8d1fdeef098e8698c28"
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
