class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "af229ca68c8f62f4534286d6e58b3d4b165a68ad04ec2bf48b55f9fd011964bf"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/terramate"
    sha256 cellar: :any_skip_relocation, mojave: "e5b23ee9d2773b7b67bf5c2309c4756df0fdb00f4d1e5942fa5b3dd665305a0b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
