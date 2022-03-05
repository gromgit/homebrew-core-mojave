class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/v4.0.0.tar.gz"
  sha256 "99435529eec82e65b58dcbccaece6f7e015d110486189c0f4ceaf2bc5f117771"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fblog"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "6b7c150caeda2f647618b1dc7f1ec6a02c1b11c9429300e0a04a5add9968bb6e"
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
