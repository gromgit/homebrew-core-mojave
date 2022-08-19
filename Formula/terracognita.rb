class Terracognita < Formula
  desc "Reads from existing Cloud Providers and generates Terraform code"
  homepage "https://github.com/cycloidio/terracognita"
  url "https://github.com/cycloidio/terracognita/archive/v0.8.1.tar.gz"
  sha256 "dff35a6913d64dbd4e0595bd15d2f2029a8605a8bf0ba32a1de95f3236d85f1c"
  license "MIT"
  head "https://github.com/cycloidio/terracognita.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/terracognita"
    sha256 cellar: :any_skip_relocation, mojave: "18c7b0837599ebb0705c2ba7bf6acb4c0bb5255c2b7081c180c7f19d8403e20b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/cycloidio/terracognita/cmd.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/terracognita version")
    assert_match "Error: one of --module, --hcl  or --tfstate are required",
      shell_output("#{bin}/terracognita aws 2>&1", 1)
    assert_match "aws_instance", shell_output("#{bin}/terracognita aws resources")
  end
end
