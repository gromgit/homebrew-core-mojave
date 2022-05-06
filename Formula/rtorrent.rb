class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.9.8/rtorrent-0.9.8.tar.gz"
  sha256 "9edf0304bf142215d3bc85a0771446b6a72d0ad8218efbe184b41e4c9c7542af"
  license "GPL-2.0"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rtorrent"
    sha256 cellar: :any, mojave: "b39139497b57875a7731a11b6dea1f8394bb6e892c752c4e46523d71b778fee5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libtorrent-rakshasa"
  depends_on "xmlrpc-c"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    args = ["--prefix=#{prefix}", "--with-xmlrpc-c",
            "--disable-debug", "--disable-dependency-tracking"]

    system "sh", "autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    pid = fork do
      exec "#{bin}/rtorrent", "-n", "-s", testpath
    end
    sleep 3
    assert_predicate testpath/"rtorrent.lock", :exist?
  ensure
    Process.kill("HUP", pid)
  end
end
