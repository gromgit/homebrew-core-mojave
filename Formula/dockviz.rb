class Dockviz < Formula
  desc "Visualizing docker data"
  homepage "https://github.com/justone/dockviz"
  url "https://github.com/justone/dockviz.git",
      tag:      "v0.6.3",
      revision: "15f77275c4f7e459eb7d9f824b5908c165cd0ba4"
  license "Apache-2.0"
  head "https://github.com/justone/dockviz.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dockviz"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "dd8db4c9e5771d3b741b5937411c0a5057739900d323a5c2ef35be9364dbad20"
  end


  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    (buildpath/"src/github.com/justone/dockviz").install buildpath.children
    cd "src/github.com/justone/dockviz" do
      system "govendor", "sync"
      system "go", "build", "-o", bin/"dockviz"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockviz --version")
  end
end
