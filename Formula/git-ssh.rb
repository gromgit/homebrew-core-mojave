class GitSsh < Formula
  desc "Proxy for serving git repositories over SSH"
  homepage "https://github.com/lemarsu/git-ssh"
  url "https://github.com/lemarsu/git-ssh/archive/v0.2.0.tar.gz"
  sha256 "f7cf45f71e1f3aa23ef47cbbc411855f60d15ee69992c9f57843024e241a842f"
  license "GPL-2.0"
  head "https://github.com/lemarsu/git-ssh.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-ssh"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "dde104fec14597a9a812f749b24865a2afc617fb282e5e5ee628c9e1b7d81712"
  end

  def install
    # Change loading of required code from libexec location (Cellar only)
    inreplace "bin/git-ssh" do |s|
      s.sub!(/path = .*$/, "path = '#{libexec}'")
    end
    bin.install "bin/git-ssh"
    libexec.install Dir["lib/*"]
  end

  test do
    assert_equal "#{bin}/git-ssh v0.2.0",
      shell_output("#{bin}/git-ssh -V").chomp
  end
end
