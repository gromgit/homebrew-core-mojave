class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.19.tar.gz"
  sha256 "1f24ef62fcdf3bbe36880aef4f8b5f4cc623884f399200987aa1b1be9a5a5326"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mmark"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "2859f66fec7807064385baf303e920c7f4ca45fd7b9d61db5767cf7b9df9b0c6"
  end

  depends_on "go" => :build

  resource "test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/v2.2.19/rfc/2100.md"
    sha256 "0e12576b4506addc5aa9589b459bcc02ed92b936ff58f87129385d661b400c41"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "mmark.1"
  end

  test do
    resource("test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}/mmark -ast 2100.md")
    end
  end
end
