class Giflossy < Formula
  desc "Lossy LZW compression, reduces GIF file sizes by 30-50%"
  homepage "https://pornel.net/lossygif"
  url "https://github.com/kornelski/giflossy/archive/1.91.tar.gz"
  sha256 "b97f6aadf163ff5dd96ad1695738ad3d5aa7f1658baed8665c42882f11d9ab22"
  license "GPL-2.0-only"
  head "https://github.com/kornelski/giflossy.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/giflossy"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "ccecfb58e4fbded1ff7708aeccc0a2c3d2246df5ed6dc576e1027dacb2cb342c"
  end

  # "This project has now been officially merged upstream into Gifsicle, so
  # please use that": https://github.com/kohler/gifsicle
  deprecate! date: "2019-05-27", because: :repo_archived

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  conflicts_with "gifsicle",
    because: "both install an `gifsicle` binary"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-gifview
    ]

    system "autoreconf", "-fvi"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"gifsicle", "-O3", "--lossy=80", "-o",
                           "out.gif", test_fixtures("test.gif")
  end
end
