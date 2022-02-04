class Tfproviderlint < Formula
  desc "Terraform Provider Lint Tool"
  homepage "https://github.com/bflad/tfproviderlint"
  url "https://github.com/bflad/tfproviderlint/archive/v0.28.0.tar.gz"
  sha256 "ee30f1a621cfaeceea00a83a45dd6704ad186aa10954324cbd88200abd27d9aa"
  license "MPL-2.0"
  head "https://github.com/bflad/tfproviderlint.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tfproviderlint"
    sha256 cellar: :any_skip_relocation, mojave: "bd2b8f1df1e855f45d14516c9bdd1076ca85dc2c668472f50c16a9ef982ac59f"
  end

  depends_on "go" => [:build, :test]

  resource "test_resource" do
    url "https://github.com/russellcardullo/terraform-provider-pingdom/archive/v1.1.3.tar.gz"
    sha256 "3834575fd06123846245eeeeac1e815f5e949f04fa08b65c67985b27d6174106"
  end

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/bflad/tfproviderlint/version.Version=#{version}
    ]

    ldflags << if build.head?
      "-X github.com/bflad/tfproviderlint/version.VersionPrerelease=dev"
    else
      "-X github.com/bflad/tfproviderlint/version.VersionPrerelease="
    end

    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "./cmd/tfproviderlint"
  end

  test do
    assert_match "tfproviderlint: ./... matched no packages",
      shell_output(bin/"tfproviderlint -fix ./... 2>&1", 1)

    testpath.install resource("test_resource")
    assert_match "S006: schema of TypeMap should include Elem",
      shell_output(bin/"tfproviderlint -fix #{testpath}/... 2>&1", 3)

    assert_match version.to_s, shell_output(bin/"tfproviderlint --version")
  end
end
