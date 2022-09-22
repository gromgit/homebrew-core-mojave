class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://github.com/google/ko"
  url "https://github.com/google/ko/archive/v0.12.0.tar.gz"
  sha256 "cc42e9cde0b4d3380b680cf100c9be9acac67948f3dcfe65d71b87e2da797600"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ko"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "fda6299eab3477d54a303ec2678ecff8939c439222687c684b7d68de4619269a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}")

    generate_completions_from_executable(bin/"ko", "completion")
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end
