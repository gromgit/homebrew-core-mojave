class GitCrypt < Formula
  desc "Enable transparent encryption/decryption of files in a git repo"
  homepage "https://www.agwa.name/projects/git-crypt/"
  url "https://www.agwa.name/projects/git-crypt/downloads/git-crypt-0.7.0.tar.gz"
  sha256 "50f100816a636a682404703b6c23a459e4d30248b2886a5cf571b0d52527c7d8"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?git-crypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-crypt"
    rebuild 1
    sha256 cellar: :any, mojave: "bf50a75df4c568372f317a884157bdb9ba2d0d51f0d28a607119ad907c163894"
  end

  depends_on "openssl@1.1"
  uses_from_macos "libxslt" => :build

  def install
    system "make", "ENABLE_MAN=yes", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/git-crypt", "keygen", "keyfile"
  end
end
