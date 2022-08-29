class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://github.com/cloudflare/cfssl/archive/v1.6.2.tar.gz"
  sha256 "8285ebc135a04ed4e927f8ec9253b683976cf73f683f3be7d11af677f3435341"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/cfssl.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cfssl"
    sha256 cellar: :any_skip_relocation, mojave: "09a76e642702079f3f9b2c37ccafba3cdc3f61b4b37f98d8b45f999cc91477dc"
  end

  depends_on "go" => :build
  depends_on "libtool"

  def install
    ldflags = "-s -w -X github.com/cloudflare/cfssl/cli/version.version=#{version}"

    system "go", "build", *std_go_args(output: bin/"cfssl", ldflags: ldflags), "cmd/cfssl/cfssl.go"
    system "go", "build", *std_go_args(output: bin/"cfssljson", ldflags: ldflags), "cmd/cfssljson/cfssljson.go"
    system "go", "build", "-o", "#{bin}/cfsslmkbundle", "cmd/mkbundle/mkbundle.go"
  end

  def caveats
    <<~EOS
      `mkbundle` has been installed as `cfsslmkbundle` to avoid conflict
      with Mono and other tools that ship the same executable.
    EOS
  end

  test do
    (testpath/"request.json").write <<~EOS
      {
        "CN" : "Your Certificate Authority",
        "hosts" : [],
        "key" : {
          "algo" : "rsa",
          "size" : 4096
        },
        "names" : [
          {
            "C" : "US",
            "ST" : "Your State",
            "L" : "Your City",
            "O" : "Your Organization",
            "OU" : "Your Certificate Authority"
          }
        ]
      }
    EOS
    shell_output("#{bin}/cfssl genkey -initca request.json > response.json")
    response = JSON.parse(File.read(testpath/"response.json"))
    assert_match(/^-----BEGIN CERTIFICATE-----.*/, response["cert"])
    assert_match(/.*-----END CERTIFICATE-----$/, response["cert"])
    assert_match(/^-----BEGIN RSA PRIVATE KEY-----.*/, response["key"])
    assert_match(/.*-----END RSA PRIVATE KEY-----$/, response["key"])

    assert_match(/^Version:\s+#{version}/, shell_output("#{bin}/cfssl version"))
  end
end
