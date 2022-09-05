class Abook < Formula
  desc "Address book with mutt support"
  homepage "https://abook.sourceforge.io/"
  url "https://abook.sourceforge.io/devel/abook-0.6.1.tar.gz"
  sha256 "f0a90df8694fb34685ecdd45d97db28b88046c15c95e7b0700596028bd8bc0f9"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "GPL-3.0-or-later", :public_domain, "X11"]
  head "https://git.code.sf.net/p/abook/git.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?abook[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/abook"
    rebuild 1
    sha256 mojave: "48158476db5ab0a48fd82c6f07a9ad14fd97e59d9b6329b915cae0111ccd9244"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "readline"

  def install
    # fix "undefined symbols" error caused by C89 inline behaviour
    inreplace "database.c", "inline int", "int"

    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/abook", "--formats"
  end
end
