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
    sha256 cellar: :any_skip_relocation, mojave: "6298191a28396f3e67a6bef3b7f2202003318cd27c238edb97565fa629d895fd"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/awslabs/amazon-ecr-credential-helper"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "build"
      bin.install "bin/local/docker-credential-ecr-login"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/docker-credential-ecr-login", 1)
    assert_match %r{^Usage: .*/docker-credential-ecr-login.*}, output
  end
end
