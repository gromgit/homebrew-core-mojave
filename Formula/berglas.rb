class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v0.6.2.tar.gz"
  sha256 "03ee83b49598f864537aec48ef081d3a79a0cf0f32027d815c37755bf5d31376"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/berglas"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "60e5ebc3e7653dae83ff53713d2e9083c1dd26b133b85c06c26d53fd242200b3"
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
