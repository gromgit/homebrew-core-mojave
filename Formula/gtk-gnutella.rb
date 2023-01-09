class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.2.2/gtk-gnutella-1.2.2.tar.xz"
  sha256 "95a5d86878f6599df649b95db126bd72b9e0cecadb96f41acf8fdcc619771eb6"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gtk-gnutella"
    rebuild 1
    sha256 mojave: "74aa8d842bef0e52f345c067e5823fdb7587b5a2a4daf10b3819ee8bc65bb494"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    ENV.deparallelize

    system "./build.sh", "--prefix=#{prefix}", "--disable-nls"
    system "make", "install"
    rm_rf share/"pixmaps"
    rm_rf share/"applications"
  end

  test do
    system "#{bin}/gtk-gnutella", "--version"
  end
end
