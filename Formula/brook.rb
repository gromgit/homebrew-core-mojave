class Brook < Formula
  desc "Cross-platform strong encryption and not detectable proxy. Zero-Configuration"
  homepage "https://txthinking.github.io/brook/"
  url "https://github.com/txthinking/brook/archive/refs/tags/v20220406.tar.gz"
  sha256 "cf4433263cc755edfe56be66d206b7ee5083faaaa8b30bb4102174ad73e22764"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/brook"
    sha256 cellar: :any_skip_relocation, mojave: "634588dba2da76b9b17f4c4e84b87070c90742653af55ba6bebba8bc598299dc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli/brook"
  end

  test do
    output = shell_output "#{bin}/brook link --server 1.2.3.4:56789 --password hello"
    assert_match "brook://server?address=&insecure=&name=&password=hello", output
  end
end
