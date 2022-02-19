class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/v4.0.0.tar.gz"
  sha256 "99435529eec82e65b58dcbccaece6f7e015d110486189c0f4ceaf2bc5f117771"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fblog"
    sha256 cellar: :any_skip_relocation, mojave: "40e5f8418dc56175ba2f9661e4688c7eacd7d6dd1f0449462e4fadabac0c076b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install a sample log for testing purposes
    pkgshare.install "sample.json.log"
  end

  test do
    output = shell_output("#{bin}/fblog #{pkgshare/"sample.json.log"}")

    assert_match "Trust key rsa-43fe6c3d-6242-11e7-8b0c-02420a000007 found in cache", output
    assert_match "Content-Type set both in header", output
    assert_match "Request: Success", output
  end
end
