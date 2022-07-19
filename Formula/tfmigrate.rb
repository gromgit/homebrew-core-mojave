class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.4.tar.gz"
  sha256 "1bdec9ee97ec8feb272391b7b9e6381b0030f04f308d33c441bee6c4450f05ab"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tfmigrate"
    sha256 cellar: :any_skip_relocation, mojave: "962b887911342b67965693d4d64f419857bd61c2445cd808e4a39bd34ff27d8b"
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
