class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/v4.2.0.tar.gz"
  sha256 "de7e7e012301eec9df891a4bbc27088e43a7fdbf8066532fc35e85a38edde5f1"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fblog"
    sha256 cellar: :any_skip_relocation, mojave: "00fc136830345c0ae885edb51527489080583c7ea93b26ef064643e56a01bd30"
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
