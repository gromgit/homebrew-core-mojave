class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v1.0.1.tar.gz"
  sha256 "be619fe870249e74f52076d16020808b6020fedf2b98685f7c14145a291a2fe7"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/berglas"
    sha256 cellar: :any_skip_relocation, mojave: "15baee033fd6e55f60e49db28ded626c32264e2a7b248db13fd595e534a52f25"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
