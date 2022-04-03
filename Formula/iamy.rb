class Iamy < Formula
  desc "AWS IAM import and export tool"
  homepage "https://github.com/99designs/iamy"
  url "https://github.com/99designs/iamy/archive/v2.4.0.tar.gz"
  sha256 "13bd9e66afbeb30d386aa132a4af5d2e9a231d2aadf54fe8e5dc325583379359"
  license "MIT"
  head "https://github.com/99designs/iamy.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/iamy"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "04998f70f30c1dca21545c625af58edb2e5f9c16b780ef8efec20ae4ba9a5af1"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
  end

  test do
    ENV.delete "AWS_ACCESS_KEY"
    ENV.delete "AWS_SECRET_KEY"
    output = shell_output("#{bin}/iamy pull 2>&1", 1)
    assert_match "Can't determine the AWS account", output
  end
end
