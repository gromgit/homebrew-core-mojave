class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.13.0.tar.gz"
  sha256 "ff3b199a044bb16abc70b1d221f4b92e693b90e204c6ca7ff27d1c857b02d444"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/azcopy"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "2e12c0fd6cecb877ff14341aa66be5182229fd88f57f54e457c6f25eaabae472"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "failed to obtain credential info",
                 shell_output("#{bin}/azcopy list https://storageaccountname.blob.core.windows.net/containername/", 1)
  end
end
