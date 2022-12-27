class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/2.1.3.tar.gz"
  sha256 "ea3b6fd1ec306a7c9906a4d47c438a875a3a635ec7a458057d4b6d5cab71d0f8"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cloudformation-guard"
    sha256 cellar: :any_skip_relocation, mojave: "cde0d0ba00debff3601db40f17493a6198a0f05b4760c5f4b21befb926a56bf9"
  end

  depends_on "rust" => :build

  def install
    cd "guard" do
      system "cargo", "install", *std_cargo_args
    end
    doc.install "docs"
    doc.install "guard-examples"
  end

  test do
    (testpath/"test-template.yml").write <<~EOS
      ---
      AWSTemplateFormatVersion: '2010-09-09'
      Resources:
        # Helps tests map resource types
        Volume:
          Type: "AWS::EC2::Volume"
          Properties:
            Size : 99
            Encrypted: true,
            AvailabilityZone : us-east-1b
    EOS

    (testpath/"test-ruleset").write <<~EOS
      rule migrated_rules {
        let aws_ec2_volume = Resources.*[ Type == "AWS::EC2::Volume" ]
        %aws_ec2_volume.Properties.Size == 99
      }
    EOS
    system bin/"cfn-guard", "validate", "-r", "test-ruleset", "-d", "test-template.yml"
  end
end
