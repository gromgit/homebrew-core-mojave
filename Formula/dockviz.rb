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
    sha256 cellar: :any_skip_relocation, mojave: "a87d2eabcce2ceaf4ada13fa41c9986ad0114f20f32d7900a08d8c8d1a35e6fd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockviz --version")
  end
end
