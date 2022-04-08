class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.19.tar.gz"
  sha256 "f25804c1e09897e42a6506fd09deb18ee7e64e5a24e9f4148a7c29f98db519eb"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/terraformer"
    sha256 cellar: :any_skip_relocation, mojave: "56d2133b66f11cdeb64603401555d5579c78ce44c0ac52c1ffe8608bc10b3918"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/terraformer version")

    assert_match "Available Commands",
      shell_output("#{bin}/terraformer -h")

    assert_match "aaa",
      shell_output("#{bin}/terraformer import google --resources=gcs --projects=aaa 2>&1", 1)
  end
end
