class Tfproviderlint < Formula
  desc "Terraform Provider Lint Tool"
  homepage "https://github.com/bflad/tfproviderlint"
  url "https://github.com/bflad/tfproviderlint/archive/v0.28.1.tar.gz"
  sha256 "df66a164256ffbacbb260e445313c0666bb14ce4b8363f123903259ecc0f4eb5"
  license "MPL-2.0"
  revision 1
  head "https://github.com/bflad/tfproviderlint.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tfproviderlint"
    sha256 cellar: :any_skip_relocation, mojave: "5d9d0e0daed9c55ab38aceabebd89421d61cf56e600185189fa126941497f149"
  end

  depends_on "go@1.17" => [:build, :test]

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

    output = libexec/"bin/tfproviderlint"
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "), output: output), "./cmd/tfproviderlint"
    (bin/"tfproviderlint").write_env_script(output, PATH: "$PATH:#{Formula["go@1.17"].opt_bin}")
  end

  test do
    testpath.install resource("test_resource")
    assert_match "S006: schema of TypeMap should include Elem",
      shell_output(bin/"tfproviderlint -fix #{testpath}/... 2>&1", 3)

    assert_match version.to_s, shell_output(bin/"tfproviderlint --version")
  end
end
