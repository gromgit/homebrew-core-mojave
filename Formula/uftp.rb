class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-5.0.1.tar.gz"
  sha256 "f0435fbc8e9ffa125e05600cb6c7fc933d7d587f5bae41b257267be4f2ce0e61"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/uftp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/uftp"
    sha256 cellar: :any, mojave: "6c034e2eaff9bc128e350ea83abda7416f1fee8feba19229f55bf5ebfd313f38"
  end

  depends_on "openssl@1.1"

  def install
    system "make", "OPENSSL=#{Formula["openssl@1.1"].opt_prefix}", "DESTDIR=#{prefix}", "install"
    # the makefile installs into DESTDIR/usr/..., move everything up one and remove usr
    # the project maintainer was contacted via sourceforge on 12-Feb, he responded WONTFIX on 13-Feb
    prefix.install Dir["#{prefix}/usr/*"]
    (prefix/"usr").unlink
  end

  service do
    run [opt_bin/"uftpd", "-d"]
    keep_alive true
    working_dir var
  end

  test do
    system "#{bin}/uftp_keymgt"
  end
end
