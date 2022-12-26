class Cpuid < Formula
  desc "CPU feature identification for Go"
  homepage "https://github.com/klauspost/cpuid"
  url "https://github.com/klauspost/cpuid/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "bd65882ac77c56cc4a8af5c7c72aa10818ae0b53b9a6928c6d02294e23798344"
  license "MIT"
  head "https://github.com/klauspost/cpuid.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cpuid"
    sha256 cellar: :any_skip_relocation, mojave: "677a3cf0da89f7cbf5ca2432b879880f702a4b2588d85a48d0b0a7be36a10b8f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cpuid"
  end

  test do
    json = shell_output("#{bin}/cpuid -json")
    assert_match "BrandName", json
    assert_match "VendorID", json
    assert_match "VendorString", json
  end
end
