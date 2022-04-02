class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/v1.1.0.tar.gz"
  sha256 "5cb53066b689982be0d08322c40a82320888184cf5ee2a7fce118d566261de20"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dnsx"
    sha256 cellar: :any_skip_relocation, mojave: "b29653836620fe7f78e5cd77baadbac2d261b7304a88c32e461e4986c028ba80"
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
