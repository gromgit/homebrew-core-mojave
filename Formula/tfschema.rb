class Tfschema < Formula
  desc "Schema inspector for Terraform providers"
  homepage "https://github.com/minamijoyo/tfschema"
  url "https://github.com/minamijoyo/tfschema/archive/v0.7.2.tar.gz"
  sha256 "6954fbb10dbc0d730d2ee1fba4ff59f74d0961bc6ff9f1de2e04e81eb24dc493"
  license "MIT"
  head "https://github.com/minamijoyo/tfschema.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tfschema"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "1d3c17e4a36f604154ea7f93607c3621b746aceb9b5af46a3db2bb4243ac4a44"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build
  depends_on "terraform" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write "provider \"aws\" {}"
    system Formula["terraform"].bin/"terraform", "init"
    assert_match "permissions_boundary", shell_output("#{bin}/tfschema resource show aws_iam_user")

    assert_match version.to_s, shell_output("#{bin}/tfschema --version")
  end
end
