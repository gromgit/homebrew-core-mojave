class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v1.0.0.tar.gz"
  sha256 "634238a2793867a5b8c209617a025fe19002a88b53cb54eef45fc2b9c0fcc55a"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/berglas"
    sha256 cellar: :any_skip_relocation, mojave: "ff63ca51e700ebeb990494659a7c5ce258c3d84ad34dc2b42ac010babc21c4c0"
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
