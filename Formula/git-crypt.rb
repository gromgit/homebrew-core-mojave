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
    rebuild 2
    sha256 cellar: :any, mojave: "10b53791c80ed0a9bc05ad9b93f1d4d49225f0683d498baaf355820a3e3928b8"
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "openssl@3"

  uses_from_macos "libxslt" => :build

  def install
    # fix docbook load issue
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    ENV.append_to_cflags "-DOPENSSL_API_COMPAT=0x30000000L"

    system "make", "ENABLE_MAN=yes", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/git-crypt", "keygen", "keyfile"
  end
end
