class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/1.2.0.tar.gz"
  sha256 "6bfeab2b28e5c7ad1d5bee9aa6923882a01f56a7f2d0f260f01acde2111f65af"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/github-markdown-toc"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "d54f89dffdcde8406a82d5febb20450fa17d67acc5dbe94cb85b7c7f7c3c7a02"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"gh-md-toc")
  end

  test do
    (testpath/"README.md").write("# Header")
    assert_match version.to_s, shell_output("#{bin}/gh-md-toc --version 2>&1")
    assert_match "* [Header](#header)", shell_output("#{bin}/gh-md-toc ./README.md")
  end
end
