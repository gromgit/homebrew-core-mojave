class IamPolicyJsonToTerraform < Formula
  desc "Convert a JSON IAM Policy into terraform"
  homepage "https://github.com/flosell/iam-policy-json-to-terraform"
  url "https://github.com/flosell/iam-policy-json-to-terraform/archive/1.8.1.tar.gz"
  sha256 "601148725d0e0a114f59bd818982bd27c6868a2550114d429ef4411b98838615"
  license "Apache-2.0"
  head "https://github.com/flosell/iam-policy-json-to-terraform.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/iam-policy-json-to-terraform"
    sha256 cellar: :any_skip_relocation, mojave: "898a475ea6f2628b7972e43f1a5849c3fec9eec86ceb5117e56a68849dab87cc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # test version
    assert_match version.to_s, shell_output("#{bin}/iam-policy-json-to-terraform -version")

    # test functionality
    test_input = '{"Statement":[{"Effect":"Allow","Action":["ec2:Describe*"],"Resource":"*"}]}'
    output = pipe_output("#{bin}/iam-policy-json-to-terraform", test_input)
    assert_match "ec2:Describe*", output
  end
end
