class Dockviz < Formula
  desc "Visualizing docker data"
  homepage "https://github.com/justone/dockviz"
  url "https://github.com/justone/dockviz.git",
      tag:      "v0.6.4",
      revision: "3ebdb75ed393d6f2eb0b38d83ee22d75c68f6524"
  license "Apache-2.0"
  head "https://github.com/justone/dockviz.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dockviz"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "4f31da6a82ae9bda42e843f7c5525a3ae6ae813fc31c17c7b98f87a70f9135cc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockviz --version")
  end
end
