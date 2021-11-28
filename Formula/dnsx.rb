class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/v1.0.7.tar.gz"
  sha256 "3ddf978dd97df76675f48a45b3e5eb7f6da33a5941f88115972e4329f7efbfd0"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dnsx"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "4dea9ed7ed3622300c3f005bddc48b5236e935ddc4ea9a89a7f079fa2c6ba971"
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
