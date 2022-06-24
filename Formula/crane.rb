class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.10.0.tar.gz"
  sha256 "15d3368c12678cfb56ff2e9121d8f590b6ecfb6759ef29d33a8fb042b3979b4a"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/crane"
    sha256 cellar: :any_skip_relocation, mojave: "88a4e912830619d183f65e13b69a6a1f3506b4a186b301eac0d368c3cf4dba9e"
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
