class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20211214.tgz"
  sha256 "cc2965e05c6a8c37070b36b56414eaa560df8d87f2cea21759e28950e9b27a4b"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dialog"
    sha256 cellar: :any_skip_relocation, mojave: "ef50290ba1cfb98fd4fa28253088d5a3050a879fa18e3874577dd266999b8dd4"
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
