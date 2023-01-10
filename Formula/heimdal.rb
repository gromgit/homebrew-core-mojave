class Heimdal < Formula
  desc "Free Kerberos 5 implementation"
  homepage "https://www.h5l.org"
  url "https://github.com/heimdal/heimdal/releases/download/heimdal-7.8.0/heimdal-7.8.0.tar.gz"
  sha256 "fd87a207846fa650fd377219adc4b8a8193e55904d8a752c2c3715b4155d8d38"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/heimdal[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/heimdal"
    sha256 mojave: "c0f27cab0d820787ace24c74a70b7f36aebb8b440b8897cf91545d8822d754b7"
  end

  keg_only "conflicts with Kerberos"

  depends_on "bison" => :build
  depends_on "berkeley-db"
  depends_on "flex"
  depends_on "lmdb"
  depends_on "openldap"
  depends_on "openssl@1.1"

  uses_from_macos "libxcrypt"
  uses_from_macos "perl"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "python@3.11" => :build
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
    sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("JSON").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    ENV.append "LDFLAGS", "-L#{Formula["berkeley-db"].opt_lib}"
    ENV.append "LDFLAGS", "-L#{Formula["lmdb"].opt_lib}"
    ENV.append "CFLAGS", "-I#{Formula["lmdb"].opt_include}"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-x
      --enable-static=no
      --enable-pthread-support
      --disable-afs-support
      --disable-ndbm-db
      --disable-heimdal-documentation
      --with-openldap=#{Formula["openldap"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --with-hcrypto-default-backend=ossl
      --with-berkeley-db
      --with-berkeley-db-include=#{Formula["berkeley-db"].opt_include}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "-L#{lib}", shell_output("#{bin}/krb5-config --libs")
  end
end
