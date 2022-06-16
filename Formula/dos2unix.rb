class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlan.home.xs4all.nl/dos2unix.html"
  url "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.4.3.tar.gz"
  mirror "https://fossies.org/linux/misc/dos2unix-7.4.3.tar.gz"
  sha256 "b68db41956daf933828423aa30510e00c12d29ef5916e715e8d4e694fe66ca72"
  license "BSD-2-Clause"

  livecheck do
    url "https://waterlan.home.xs4all.nl/dos2unix/"
    regex(/href=.*?dos2unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dos2unix"
    sha256 cellar: :any_skip_relocation, mojave: "9d6c1cb1753728a6736698289d2b8e2644918b9dd8d1d14d05a4b207a18b2aae"
  end

  def install
    args = %W[
      prefix=#{prefix}
      CC=#{ENV.cc}
      CPP=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      ENABLE_NLS=
      install
    ]

    system "make", *args
  end

  test do
    # write a file with lf
    path = testpath/"test.txt"
    path.write "foo\nbar\n"

    # unix2mac: convert lf to cr
    system "#{bin}/unix2mac", path
    assert_equal "foo\rbar\r", path.read

    # mac2unix: convert cr to lf
    system "#{bin}/mac2unix", path
    assert_equal "foo\nbar\n", path.read

    # unix2dos: convert lf to cr+lf
    system "#{bin}/unix2dos", path
    assert_equal "foo\r\nbar\r\n", path.read

    # dos2unix: convert cr+lf to lf
    system "#{bin}/dos2unix", path
    assert_equal "foo\nbar\n", path.read
  end
end
