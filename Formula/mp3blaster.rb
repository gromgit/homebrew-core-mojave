class Mp3blaster < Formula
  desc "Text-based mp3 player"
  homepage "https://mp3blaster.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mp3blaster/mp3blaster/mp3blaster-3.2.6/mp3blaster-3.2.6.tar.gz"
  sha256 "43d9f656367d16aaac163f93dc323e9843c3dd565401567edef3e1e72b9e1ee0"
  license "GPL-2.0"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mp3blaster"
    sha256 mojave: "88c023fea156d0aec8c0733d6f4766d36389194bd9d78b8065ca5ff0b039b6c1"
  end

  depends_on "sdl12-compat"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mp3blaster", "--version"
  end
end
