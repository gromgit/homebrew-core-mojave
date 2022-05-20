class Remctl < Formula
  desc "Client/server application for remote execution of tasks"
  homepage "https://www.eyrie.org/~eagle/software/remctl/"
  url "https://archives.eyrie.org/software/kerberos/remctl-3.18.tar.xz"
  sha256 "69980a0058c848f4d1117121cc9153f2daace5561d37bfdb061473f035fc35ef"
  license "MIT"

  livecheck do
    url "https://archives.eyrie.org/software/kerberos/"
    regex(/href=.*?remctl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/remctl"
    sha256 cellar: :any, mojave: "030122840ed584c4975793bbdad60b8d6a38780070b2c879ee810cee5b00ef4a"
  end

  depends_on "libevent"
  depends_on "pcre"

  uses_from_macos "krb5"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-pcre=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  test do
    system "#{bin}/remctl", "-v"
  end
end
