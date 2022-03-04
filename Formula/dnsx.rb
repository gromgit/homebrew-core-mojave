class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/v1.0.8.tar.gz"
  sha256 "d5a98396ddc78c94799fcd54b89f6c2600579be8e17349efeb0e691093889a11"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dnsx"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "458c956f618a8d69a8d2e887b346b038dacd362384cb2f20f56efebfcc7865ff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dnsx"
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}/dnsx -silent -l #{testpath}/domains.txt -cname -resp").strip
  end
end
