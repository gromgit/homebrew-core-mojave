class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.2.2/gtk-gnutella-1.2.2.tar.xz"
  sha256 "95a5d86878f6599df649b95db126bd72b9e0cecadb96f41acf8fdcc619771eb6"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gtk-gnutella"
    sha256 mojave: "e7c3ae51e65bc367696d55cbfd67c050a83cded84acf5cda24113748f6d967a1"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    ENV.deparallelize

    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
      inreplace "Configure", "ret = clock_gettime(CLOCK_REALTIME, &tp);",
                             "ret = undefinedgibberish(CLOCK_REALTIME, &tp);"
    end

    system "./build.sh", "--prefix=#{prefix}", "--disable-nls"
    system "make", "install"
    rm_rf share/"pixmaps"
    rm_rf share/"applications"
  end

  test do
    system "#{bin}/gtk-gnutella", "--version"
  end
end
