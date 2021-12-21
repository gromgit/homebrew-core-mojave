class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.0.tar.gz"
  sha256 "9baa141c2ba36e1190bbf92a70f7a58db2f9b009db5c645a50f9e23a89d5903c"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tfmigrate"
    sha256 cellar: :any_skip_relocation, mojave: "5a3621a799f2d448401ae74858323707827e9f36dd27e9666feee7cb9c82400b"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"tfmigrate.hcl").write <<~EOS
      migration "state" "brew" {
        actions = [
          "mv aws_security_group.foo aws_security_group.baz",
        ]
      }
    EOS
    output = shell_output(bin/"tfmigrate plan tfmigrate.hcl 2>&1", 1)
    assert_match "[migrator@.] compute a new state", output
    assert_match "No state file was found!", output

    assert_match version.to_s, shell_output(bin/"tfmigrate --version")
  end
end
