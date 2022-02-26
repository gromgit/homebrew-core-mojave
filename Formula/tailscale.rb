class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.22.0",
      revision: "4e0b00ad830e656b1d76f1c5194520469ab0ff92"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tailscale"
    sha256 cellar: :any_skip_relocation, mojave: "4b887f147df2835bcf86d800497eb220375839bd4fbfc0d1da064fe2db7e1295"
  end

  depends_on "go" => :build

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.Long=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.Short=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.GitCommit=#{vars.match(/VERSION_GIT_HASH="(.*)-dirty"/)[1]}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "tailscale.com/cmd/tailscale"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tailscaled", "tailscale.com/cmd/tailscaled"
  end

  test do
    version_text = shell_output("#{bin}/tailscale version")
    assert_match version.to_s, version_text
    assert_match(/commit: [a-f0-9]{40}/, version_text)

    fork do
      system bin/"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}/tailscaled.socket"
    end

    sleep 2
    assert_match "Logged out.", shell_output("#{bin}/tailscale --socket=#{testpath}/tailscaled.socket status", 1)
  end
end
