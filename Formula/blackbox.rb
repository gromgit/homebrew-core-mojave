class Blackbox < Formula
  desc "Safely store secrets in Git/Mercurial/Subversion"
  homepage "https://github.com/StackExchange/blackbox"
  url "https://github.com/StackExchange/blackbox/archive/v1.20220610.tar.gz"
  sha256 "f1efcca6680159f244eb44fdb78e92b521760b875fa5a36e4c433b93ed0f87c1"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*\.\d{6,8}(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "419360782c976255a478975376c6a504085ec82c56e16938a76f7a0fd322b2b6"
  end

  depends_on "gnupg"

  def install
    libexec.install Dir["bin/*"]
    bin.write_exec_script Dir[libexec/"*"].select { |f| File.executable? f }
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
      system bin/"blackbox_initialize", "yes"
      add_created_key = shell_output("#{bin}/blackbox_addadmin Testing 2>&1")
      assert_match "<testing@foo.bar>", add_created_key
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end
