class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/accurics/terrascan"
  url "https://github.com/accurics/terrascan/archive/v1.13.1.tar.gz"
  sha256 "54201de07d9c830a73fdd915d88dcaf6ec6ee23c73e09dbdaf023f227d974b5a"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/terrascan"
    sha256 cellar: :any_skip_relocation, mojave: "32b85ad2bc3bb3c7e4c171167bc7c309d0e1a5721f20758c67d3989db519812a"
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
