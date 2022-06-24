class Libtermkey < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "https://www.leonerd.org.uk/code/libtermkey/"
  url "https://www.leonerd.org.uk/code/libtermkey/libtermkey-0.22.tar.gz"
  sha256 "6945bd3c4aaa83da83d80a045c5563da4edd7d0374c62c0d35aec09eb3014600"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?libtermkey[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libtermkey"
    rebuild 1
    sha256 cellar: :any, mojave: "7b3a144140cef8c914c29016b6782d97a72879c101f8a34dd3e20a3fe77e90bf"
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "unibilium"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "glib" => :build
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
