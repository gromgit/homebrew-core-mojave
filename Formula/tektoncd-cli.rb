class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.26.0.tar.gz"
  sha256 "6be12ab8e741bdaebfb1f8095ece38f117f884566be8ac9397eeb105d0c4906a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tektoncd-cli"
    sha256 cellar: :any_skip_relocation, mojave: "95976fdbaa18843f4ff5de403b3ca267512827e7543f9a05f478d3b895461a49"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", "completion", base_name: "tkn")
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
