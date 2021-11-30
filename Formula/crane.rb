class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.7.0.tar.gz"
  sha256 "f2e4d7f2e57811a706e669e75c5d43377d5967ab1846a83304e91b9f35ffce06"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/crane"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "81c34772d4ee29f3d863e6083c2b0264f1b4adaa80ee709083f5871ea0144454"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/crane"
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
