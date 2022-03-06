class GitSecrets < Formula
  desc "Prevents you from committing sensitive information to a git repo"
  homepage "https://github.com/awslabs/git-secrets"
  url "https://github.com/awslabs/git-secrets/archive/1.3.0.tar.gz"
  sha256 "f1d50c6c5c7564f460ff8d279081879914abe920415c2923934c1f1d1fac3606"
  license "Apache-2.0"
  head "https://github.com/awslabs/git-secrets.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-secrets"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "789926d6382721b816a9066694aeba6895bb30e4ac8c06ad103b944474999cf9"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "git", "init"
    system "git", "secrets", "--install"
  end
end
