class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.1.tgz"
  mirror "http://fresh-center.net/linux/misc/openldap-2.6.1.tgz"
  mirror "http://fresh-center.net/linux/misc/legacy/openldap-2.6.1.tgz"
  sha256 "9d576ea6962d7db8a2e2808574e8c257c15aef55f403a1fb5a0faf35de70e6f3"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/openldap"
    sha256 mojave: "808d9df712518491b9079b12612a70797c1434c6d9ad91dc0111edf18ea21896"
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  on_linux do
    depends_on "util-linux"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --enable-accesslog
      --enable-auditlog
      --enable-bdb=no
      --enable-constraint
      --enable-dds
      --enable-deref
      --enable-dyngroup
      --enable-dynlist
      --enable-hdb=no
      --enable-memberof
      --enable-ppolicy
      --enable-proxycache
      --enable-refint
      --enable-retcode
      --enable-seqmod
      --enable-translucent
      --enable-unique
      --enable-valsort
    ]

    if OS.linux?
      args << "--without-systemd"

      # Disable manpage generation, because it requires groff which has a huge
      # dependency tree on Linux
      inreplace "Makefile.in" do |s|
        s.change_make_var! "SUBDIRS", "include libraries clients servers"
      end
    end

    system "./configure", *args
    system "make", "install"
    (var/"run").mkpath

    # https://github.com/Homebrew/homebrew-dupes/pull/452
    chmod 0755, Dir[etc/"openldap/*"]
    chmod 0755, Dir[etc/"openldap/schema/*"]
  end

  test do
    system sbin/"slappasswd", "-s", "test"
  end
end
