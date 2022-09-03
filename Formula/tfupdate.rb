class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/v0.6.7.tar.gz"
  sha256 "f62a8748ffef97c1a7697d76bb2e76b79a9254d957f799b1e15413b946b4ee33"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tfupdate"
    sha256 cellar: :any_skip_relocation, mojave: "c617dce28f796c19208e9e98d87f91adeb3f589f1bc97e7dc68aec5c112cf042"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write <<~EOS
      provider "aws" {
        version = "2.39.0"
      }
    EOS

    system bin/"tfupdate", "provider", "aws", "-v", "2.40.0", testpath/"provider.tf"
    assert_match "2.40.0", File.read(testpath/"provider.tf")

    # list the most recent 5 releases
    assert_match Formula["terraform"].version.to_s, shell_output(bin/"tfupdate release list -n 5 hashicorp/terraform")

    assert_match version.to_s, shell_output(bin/"tfupdate --version")
  end
end
