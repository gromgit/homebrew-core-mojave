class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v2.2.1",
      revision: "fd6b3c923158fb1fe399449ae3c84cc9872cdf73"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/regula"
    sha256 cellar: :any_skip_relocation, mojave: "da3626d6a36fbe0f734ec48b6aa43f96adfa9665ccf15ae114df49e927d88b6b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/fugue/regula/pkg/version.Version=#{version}
      -X github.com/fugue/regula/pkg/version.GitCommit=#{Utils.git_short_head}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_output = Utils.safe_popen_read(bin/"regula", "completion", "bash")
    (bash_completion/"regula").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"regula", "completion", "zsh")
    (zsh_completion/"_regula").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"regula", "completion", "fish")
    (fish_completion/"regula.fish").write fish_output
  end

  test do
    (testpath/"infra/test.tf").write <<~EOS
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        versioning {
          enabled = true
        }
      }
    EOS

    assert_match "Found 8 problems", shell_output(bin/"regula run infra", 1)

    assert_match version.to_s, shell_output(bin/"regula version")
  end
end
