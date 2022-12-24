class AwsRotateKey < Formula
  desc "Easily rotate your AWS access key"
  homepage "https://github.com/stefansundin/aws-rotate-key"
  url "https://github.com/stefansundin/aws-rotate-key/archive/v1.0.8.tar.gz"
  sha256 "84a0df21f8ec4e1816094136c7ed4c8a559b3f74e32b5ac58a9a3f25582e7f2a"
  license "MIT"
  head "https://github.com/stefansundin/aws-rotate-key.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/aws-rotate-key"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "ec3d8d672adb1b64223571154efee94b14c81cd6e5a6f9f35ce0aac1202a6c1f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"credentials").write <<~EOF
      [default]
      aws_access_key_id=AKIA123
      aws_secret_access_key=abc
    EOF
    output = shell_output("AWS_SHARED_CREDENTIALS_FILE=#{testpath}/credentials #{bin}/aws-rotate-key -y 2>&1", 1)
    assert_match "InvalidClientTokenId: The security token included in the request is invalid", output
  end
end
