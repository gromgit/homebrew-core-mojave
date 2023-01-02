class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for Amazon ECR"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper.git",
      tag:      "v0.6.0",
      revision: "69c85dc22db6511932bbf119e1a0cc5c90c69a7f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docker-credential-helper-ecr"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "63bd72e0836563e5c1bcb47cb669a1de3f227c86307fb1db1e031f1698fcfe20"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/local/docker-credential-ecr-login"
  end

  test do
    output = shell_output("#{bin}/docker-credential-ecr-login", 1)
    assert_match %r{^Usage: .*/docker-credential-ecr-login.*}, output
  end
end
