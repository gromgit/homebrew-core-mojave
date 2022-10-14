class Tmpreaper < Formula
  desc "Clean up files in directories based on their age"
  homepage "https://packages.debian.org/sid/tmpreaper"
  url "https://deb.debian.org/debian/pool/main/t/tmpreaper/tmpreaper_1.6.17.tar.gz"
  mirror "https://fossies.org/linux/misc/tmpreaper_1.6.17.tar.gz"
  sha256 "1ca94d156eb68160ec9b6ed8b97d70fbee996de21437f0cf7d0c3b46709fecbc"
  license "GPL-2.0-only"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/t/tmpreaper/"
    regex(/href=.*?tmpreaper[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tmpreaper"
    sha256 cellar: :any_skip_relocation, mojave: "f401ba4b2f518bf971c396566252cec7f29ccfd3e14b134501750b0864764856"
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
