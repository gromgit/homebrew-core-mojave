class Tmpreaper < Formula
  desc "Clean up files in directories based on their age"
  homepage "https://packages.debian.org/sid/tmpreaper"
  url "https://deb.debian.org/debian/pool/main/t/tmpreaper/tmpreaper_1.6.16.tar.gz"
  mirror "https://fossies.org/linux/misc/tmpreaper_1.6.16.tar.gz"
  sha256 "e543acdd55bb50102c42015e6d399e8abb36ad818cbd3ca6cb1c905b5781e202"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tmpreaper"
    sha256 cellar: :any_skip_relocation, mojave: "f386bd2ba06b1d52baf77ce1b6c359c8ea70f39876ec3aa2b20af00f08390b1e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "e2fsprogs"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    touch "removed"
    sleep 3
    touch "not-removed"
    system "#{sbin}/tmpreaper", "2s", "."
    refute_predicate testpath/"removed", :exist?
    assert_predicate testpath/"not-removed", :exist?
  end
end
