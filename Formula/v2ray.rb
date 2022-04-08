class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v4.44.0.tar.gz"
  sha256 "d9973bafd3020f60a51fa3495b24ab417b08b3c8f9539a3748d00da6c68d0103"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/v2ray"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "9d6e243700e0816965bc0487a37c7f0ecc57bc9f1faff7321b2c6f8ef97f458d"
  end

  # Bump to Go 1.18 with when v5 releases.
  depends_on "go@1.17" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202112060252/geoip.dat"
    sha256 "7cc3d27ae1c59062148d4968f8d98eff9038212111e0bb129f46831198a0750b"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202112060252/geoip-only-cn-private.dat"
    sha256 "d5d9fbfbe489a6acd2cc215eb699b95ff16801e12b4ba6af3e0a64e3f530d9e7"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20211203092402/dlc.dat"
    sha256 "d39a595800d57b8fcfa5924db69b9ab3f1f798cbdaf449afcac78d377ca1c501"
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args, "-o", execpath,
                 "-ldflags", ldflags,
                 "./main"
    system "go", "build", *std_go_args,
                 "-ldflags", ldflags,
                 "-tags", "confonly",
                 "-o", bin/"v2ctl",
                 "./infra/control/main"
    (bin/"v2ray").write_env_script execpath,
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "release/config/config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geoip-only-cn-private").stage do
      pkgshare.install "geoip-only-cn-private.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  service do
    run [bin/"v2ray", "-config", etc/"v2ray/config.json"]
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~EOS
      {
        "log": {
          "access": "#{testpath}/log"
        },
        "outbounds": [
          {
            "protocol": "freedom",
            "tag": "direct"
          }
        ],
        "routing": {
          "rules": [
            {
              "ip": [
                "geoip:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            },
            {
              "domains": [
                "geosite:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            }
          ]
        }
      }
    EOS
    output = shell_output "#{bin}/v2ray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
