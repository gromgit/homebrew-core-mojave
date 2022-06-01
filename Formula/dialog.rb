class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20220526.tgz"
  sha256 "858c9a625b20fde19fb7b19949ee9e9efcade23c56d917b1adb30e98ff6d6b33"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dialog"
    sha256 cellar: :any_skip_relocation, mojave: "c02fd81c0ff37e9d077b580fa75d0e7c73a6c5426ce51bd4d37219180a83eb0f"
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
