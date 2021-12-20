class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/v3.1.2.tar.gz"
  sha256 "a5cf45d9dbe3b5803edc8d6d100d1e995df35dda7b0a8b14dbc4e2b0f881da76"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fblog"
    sha256 cellar: :any_skip_relocation, mojave: "a649655c1796673acea7fcad2cf81593bc75fbd51db32212e3d62809a7fd0d61"
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
