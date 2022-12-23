class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/archive/3.2.1.tar.gz"
  sha256 "b5ffac1949a8daaabcffa659c0964360b5008782aae4dfa7702d2323cfb4f438"
  license "GPL-2.0-or-later"
  head "https://github.com/htop-dev/htop.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/htop-3.2.1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "49ec8ba30dbca7b9f6435b54bd4d9f5a9449833cd11e3d330394b022d5681ab1"
  end

  option "with-native", "Build non-Homebrew htop binary"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  on_macos do
    unless build.with? "native"
      depends_on "pkg-config" => :build
      depends_on "ncurses" # enables mouse scroll
    end
  end

  on_linux do
    depends_on "lm-sensors"
  end

  def install
    system "./autogen.sh"
    args = ["--prefix=#{prefix}"]
    args << "--enable-sensors" if OS.linux?
    ENV["PKG_CONFIG"] = "/usr/bin/ncurses5.4-config" if OS.mac? && (build.with? "native")
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      htop requires root privileges to correctly display all running processes,
      so you will need to run `sudo htop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    pipe_output("#{bin}/htop", "q", 0)
  end
end
