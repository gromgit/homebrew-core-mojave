class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://github.com/tenable/terrascan/archive/v1.15.1.tar.gz"
  sha256 "3d0588ea411f3cd2a47803ab1fe3e0f92b75a48e29109f843cb99700c083fc66"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/terrascan"
    sha256 cellar: :any_skip_relocation, mojave: "d7f66aeb534e45c26e46f90ecab52a36e86556f31fbda5c350a2fc05253ab014"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terrascan"
  end

  test do
    (testpath/"ami.tf").write <<~EOS
      resource "aws_ami" "example" {
        name                = "terraform-example"
        virtualization_type = "hvm"
        root_device_name    = "/dev/xvda"

        ebs_block_device {
          device_name = "/dev/xvda"
          snapshot_id = "snap-xxxxxxxx"
          volume_size = 8
        }
      }
    EOS

    expected = <<~EOS
      \tViolated Policies   :\t0
      \tLow                 :\t0
      \tMedium              :\t0
      \tHigh                :\t0
    EOS

    output = shell_output("#{bin}/terrascan scan -f #{testpath}/ami.tf -t aws")
    assert_match expected, output
    assert_match(/Policies Validated\s+:\s+\d+/, output)
  end
end
