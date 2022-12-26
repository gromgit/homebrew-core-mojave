class CoreosCt < Formula
  desc "Convert a Container Linux Config into Ignition"
  homepage "https://flatcar-linux.org/docs/latest/provisioning/config-transpiler/"
  url "https://github.com/flatcar/container-linux-config-transpiler/archive/v0.9.4.tar.gz"
  sha256 "c173ced842a6d178000f9bf01b26e9a8c296b1256ab713834f18d3f0883c4263"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/coreos-ct"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "251698c6034f5ba28afc1c319e2b08ef656c8279c2dee5bc68a7fc3a775bcf3d"
  end

  depends_on "go" => :build

  def install
    system "make", "all", "VERSION=v#{version}"
    bin.install "./bin/ct"
  end

  test do
    (testpath/"input").write <<~EOS
      passwd:
        users:
          - name: core
            ssh_authorized_keys:
              - ssh-rsa mykey
    EOS
    output = shell_output("#{bin}/ct -pretty -in-file #{testpath}/input").lines.map(&:strip).join
    assert_match(/.*"sshAuthorizedKeys":\s*\["ssh-rsa mykey"\s*\].*/m, output.strip)
  end
end
