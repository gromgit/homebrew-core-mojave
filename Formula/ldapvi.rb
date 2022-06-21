class Ldapvi < Formula
  desc "Update LDAP entries with a text editor"
  homepage "http://www.lichteblau.com/ldapvi/"
  url "http://www.lichteblau.com/download/ldapvi-1.7.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/l/ldapvi/ldapvi_1.7.orig.tar.gz"
  sha256 "6f62e92d20ff2ac0d06125024a914b8622e5b8a0a0c2d390bf3e7990cbd2e153"
  license "GPL-2.0-or-later"
  revision 8

  livecheck do
    url :homepage
    regex(/href=.*?ldapvi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ldapvi"
    sha256 cellar: :any, mojave: "d487fd61e055a04561d4e774015e728b86dc2614f5a10c0be04818a6bd5aa3c5"
  end

  depends_on "pkg-config" => :build
  depends_on "xz" => :build # Homebrew bug. Shouldn't need declaring explicitly.
  depends_on "gettext"
  depends_on "glib"
  depends_on "openssl@1.1"
  depends_on "popt"
  depends_on "readline"

  uses_from_macos "libxcrypt"
  uses_from_macos "openldap"

  # These patches are applied upstream but release process seems to be dead.
  # http://www.lichteblau.com/git/?p=ldapvi.git;a=commit;h=256ced029c235687bfafdffd07be7d47bf7af39b
  # http://www.lichteblau.com/git/?p=ldapvi.git;a=commit;h=a2717927f297ff9bc6752f281d4eecab8bd34aad
  patch do
    url "https://deb.debian.org/debian/pool/main/l/ldapvi/ldapvi_1.7-10.debian.tar.xz"
    sha256 "93be20cf717228d01272eab5940337399b344bb262dc8bc9a59428ca604eb6cb"
    apply "patches/05_getline-conflict",
          "patches/06_fix-vim-modeline"
  end

  def install
    # Fix compilation with clang by changing `return` to `return 0`.
    inreplace "ldapvi.c", "if (lstat(sasl, &st) == -1) return;",
                          "if (lstat(sasl, &st) == -1) return 0;"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ldapvi", "--version"
  end
end
