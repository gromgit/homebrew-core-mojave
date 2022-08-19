class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.5.3.tar.gz"
  sha256 "2573d0946df2418b83a7ec58c75b6d962dab33a49c77b3f6b7d2661f1dce250b"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/subfinder"
    sha256 cellar: :any_skip_relocation, mojave: "2d8d6aeeb1b0499f0054bb9b0306107e843cae5cc9a7b2776c5db26c676ccd9c"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/subfinder"
    end
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")
    assert_predicate testpath/".config/subfinder/config.yaml", :exist?
  end
end
