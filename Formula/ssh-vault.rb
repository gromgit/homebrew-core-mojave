class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/0.12.9.tar.gz"
  sha256 "2461ec450622b3aa4497641eeea2fb2da54280413d92c2c455d89f198da6e471"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ssh-vault"
    sha256 cellar: :any_skip_relocation, mojave: "0eaad0877dd9a8974b802fa68fe659fc003a0bad29abb7c6c5ae7cda5e96de10"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/ssh-vault/main.go"
  end

  test do
    output = pipe_output("#{bin}/ssh-vault -u new create", "hi")
    fingerprint = output.split("\n").first.split(";").last
    cmd = "#{bin}/ssh-vault -k https://ssh-keys.online/key/#{fingerprint} view"
    output = pipe_output(cmd, output, 0)
    assert_equal "hi", output.chomp
  end
end
