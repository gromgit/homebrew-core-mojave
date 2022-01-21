class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/v9.2.tar.gz"
  sha256 "1a28f064763f9144f8ec574416a56ef51c0ab1ae2276e35a89ceed4f594ec5d2"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/vanhauser-thc/thc-hydra.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hydra"
    sha256 cellar: :any, mojave: "35b7d0dcb9c908e42a793c1a9434bfc3a920b1432a49f951cc50d8c2c01bb6af"
  end

  depends_on "pkg-config" => :build
  depends_on "libssh"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "pcre"
  uses_from_macos "ncurses"

  conflicts_with "ory-hydra", because: "both install `hydra` binaries"

  def install
    inreplace "configure" do |s|
      # Link against our OpenSSL
      # https://github.com/vanhauser-thc/thc-hydra/issues/80
      s.gsub!(/^SSL_PATH=""$/, "SSL_PATH=#{Formula["openssl@1.1"].opt_lib}")
      s.gsub!(/^SSL_IPATH=""$/, "SSL_IPATH=#{Formula["openssl@1.1"].opt_include}")
      s.gsub!(/^SSLNEW=""$/, "SSLNEW=YES")
      s.gsub!(/^CRYPTO_PATH=""$/, "CRYPTO_PATH=#{Formula["openssl@1.1"].opt_lib}")
      s.gsub!(/^SSH_PATH=""$/, "SSH_PATH=#{Formula["libssh"].opt_lib}")
      s.gsub!(/^SSH_IPATH=""$/, "SSH_IPATH=#{Formula["libssh"].opt_include}")
      s.gsub!(/^MYSQL_PATH=""$/, "MYSQL_PATH=#{Formula["mysql-client"].opt_lib}")
      s.gsub!(/^MYSQL_IPATH=""$/, "MYSQL_IPATH=#{Formula["mysql-client"].opt_include}/mysql")
      s.gsub!(/^PCRE_PATH=""$/, "PCRE_PATH=#{Formula["pcre"].opt_lib}")
      s.gsub!(/^PCRE_IPATH=""$/, "PCRE_IPATH=#{Formula["pcre"].opt_include}")
      if OS.mac?
        s.gsub!(/^CURSES_PATH=""$/, "CURSES_PATH=#{MacOS.sdk_path_if_needed}/usr/lib")
        s.gsub!(/^CURSES_IPATH=""$/, "CURSES_IPATH=#{MacOS.sdk_path_if_needed}/usr/include")
      else
        s.gsub!(/^CURSES_PATH=""$/, "CURSES_PATH=#{Formula["ncurses"].opt_lib}")
        s.gsub!(/^CURSES_IPATH=""$/, "CURSES_IPATH=#{Formula["ncurses"].opt_include}")
      end
      # Avoid opportunistic linking of everything
      %w[
        gtk+-2.0
        libfreerdp2
        libgcrypt
        libidn
        libmemcached
        libmongoc
        libpq
        libsvn
      ].each do |lib|
        s.gsub! lib, "oh_no_you_dont"
      end
    end

    # Having our gcc in the PATH first can cause issues. Monitor this.
    # https://github.com/vanhauser-thc/thc-hydra/issues/22
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    # remove unsupported ld flags on mac
    # related to https://github.com/vanhauser-thc/thc-hydra/issues/622
    inreplace "Makefile", "-Wl,--allow-multiple-definition", "" if OS.mac?
    system "make", "all", "install"
    share.install prefix/"man" # Put man pages in correct place
  end

  test do
    assert_match(/ mysql .* ssh /, shell_output("#{bin}/hydra", 255))
  end
end
