class Chrony < Formula
  desc "Versatile implementation of the Network Time Protocol (NTP)"
  homepage "https://chrony.tuxfamily.org"
  url "https://download.tuxfamily.org/chrony/chrony-4.3.tar.gz"
  sha256 "9d0da889a865f089a5a21610ffb6713e3c9438ce303a63b49c2fb6eaff5b8804"
  license "GPL-2.0-only"

  livecheck do
    url "https://chrony.tuxfamily.org/download.html"
    regex(/href=.*?chrony[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/chrony"
    rebuild 2
    sha256 cellar: :any, mojave: "76590c77727bac0fc5804a7e9de1660f2ffdf79f8e2c2ae9569635cf83ff499f"
  end

  depends_on "nettle"

  uses_from_macos "libedit"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  test do
    (testpath/"test.conf").write "pool pool.ntp.org iburst\n"
    output = shell_output(sbin/"chronyd -Q -f #{testpath}/test.conf 2>&1")
    assert_match(/System clock wrong by -?\d+\.\d+ seconds \(ignored\)/, output)
  end
end
