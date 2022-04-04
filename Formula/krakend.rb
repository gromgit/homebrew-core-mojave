class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "https://www.krakend.io/"
  url "https://github.com/devopsfaith/krakend-ce/archive/v2.0.0.tar.gz"
  sha256 "07ce9669881f13d9c3d1ae2c14de353461a44e7ef2d95a4cf1eb66d915fb59ed"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/krakend"
    sha256 cellar: :any_skip_relocation, mojave: "de6cfd6b169426406d68ea2c52af0b4b317da52ed9709e805dcb7eaae2b6eedc"
  end

  depends_on "go" => :build

  def install
    (buildpath/"src/github.com/devopsfaith/krakend-ce").install buildpath.children
    cd "src/github.com/devopsfaith/krakend-ce" do
      system "make", "build"
      bin.install "krakend"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"krakend_unsupported_version.json").write <<~EOS
      {
        "version": 2,
        "extra_config": {
          "github_com/devopsfaith/krakend-gologging": {
            "level": "WARNING",
            "prefix": "[KRAKEND]",
            "syslog": false,
            "stdout": true
          }
        }
      }
    EOS
    assert_match "unsupported version",
      shell_output("#{bin}/krakend check -c krakend_unsupported_version.json 2>&1", 1)

    (testpath/"krakend_bad_file.json").write <<~EOS
      {
        "version": 3,
        "bad": file
      }
    EOS
    assert_match "ERROR",
      shell_output("#{bin}/krakend check -c krakend_bad_file.json 2>&1", 1)

    (testpath/"krakend.json").write <<~EOS
      {
        "version": 3,
        "extra_config": {
          "telemetry/logging": {
            "level": "WARNING",
            "prefix": "[KRAKEND]",
            "syslog": false,
            "stdout": true
          }
        },
        "endpoints": [
          {
            "endpoint": "/test",
            "backend": [
              {
                "url_pattern": "/backend",
                "host": [
                  "http://some-host"
                ]
              }
            ]
          }
        ]
      }
    EOS
    assert_match "Syntax OK",
      shell_output("#{bin}/krakend check -c krakend.json 2>&1")
  end
end
