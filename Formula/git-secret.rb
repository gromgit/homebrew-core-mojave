class GitSecret < Formula
  desc "Bash-tool to store the private data inside a git repo"
  homepage "https://git-secret.io"
  license "MIT"
  head "https://github.com/sobolevn/git-secret.git", branch: "master"

  stable do
    url "https://github.com/sobolevn/git-secret/archive/v0.4.0.tar.gz"
    sha256 "ae17bfda88eb77e8f07c5f16d833792a3a14adc9c5d2bbc840f28538c62f08ba"
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-secret"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "f0f3bbadf46c9fbb213f9e92efec64471be7b02a3587ed73c89d80cc44b59362"
  end

  depends_on "gawk"
  depends_on "gnupg"

  def install
    system "make", "build"
    system "bash", "utils/install.sh", prefix
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      system "git", "init"
      system "git", "config", "user.email", "testing@foo.bar"
      system "git", "secret", "init"
      assert_match "testing@foo.bar added", shell_output("git secret tell -m")
      (testpath/"shh.txt").write "Top Secret"
      (testpath/".gitignore").append_lines "shh.txt"
      system "git", "secret", "add", "shh.txt"
      system "git", "secret", "hide"
      assert_predicate testpath/"shh.txt.secret", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
