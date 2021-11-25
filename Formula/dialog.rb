class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20211107.tgz"
  sha256 "af97fd6787af2bd6df15de4d1fa4b5d57e22bc7b4c82d35661c21adb9520fdec"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dialog"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "8ce0ea1a0a8909d2a9b93d70d1b2150a733680fc888f771e0ed0e3b88ece002b"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
