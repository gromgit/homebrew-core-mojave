class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.21.0.tar.gz"
  sha256 "0ccf1375ee3c20508c37de288a46faa6b0e4dffb3a3749f4b699a30f95e861be"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stern"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "13000352a2d0c2f2398c475d3cad15266773d9b57b5f4c979095bc98dbb814ff"
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
