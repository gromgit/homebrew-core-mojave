class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  # The upstream download url currently returns a 404 error.
  # Until fixed, we can use a copy from OpenBSD.
  url "https://ftp.openbsd.org/pub/OpenBSD/distfiles/algol68g-2.8.5.tar.gz"
  mirror "https://jmvdveer.home.xs4all.nl/algol68g-2.8.5.tar.gz"
  sha256 "0f757c64a8342fe38ec501bde68b61d26d051dffd45742ca58b7288a99c7e2d8"
  license "GPL-3.0-or-later"
  revision 1

  # The homepage hasn't been updated for the latest release (2.8.5), even though
  # the related archive is available on the site. Until the website is updated
  # (and seems like it will continue to be updated for new releases), we're
  # checking a third-party source for new releases as an interim solution.
  livecheck do
    url "https://openports.se/lang/algol68g"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/algol68g"
    sha256 mojave: "1d1b8e1f55a4da274916d81d8cfd12bbaf8dbd7d738a74c8dbf3035e7db05af8"
  end

  on_linux do
    depends_on "libpq"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
