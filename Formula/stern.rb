class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.22.0.tar.gz"
  sha256 "3726e3c6a0e8c2828bce7b67f9ee94ddbedcfbeeecf9e6ab42e23873e3f54161"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stern"
    sha256 cellar: :any_skip_relocation, mojave: "c57641bdd35a0b17b26ce5827042403df68c20226358eb20785a466d90f59edf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    generate_completions_from_executable(bin/"stern", "--completion")
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
