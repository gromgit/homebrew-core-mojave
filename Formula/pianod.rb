class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/pianod2-392.tar.gz"
  sha256 "d3e24ec34677bb17307e61e79f42ae2b22441228db7a31cf056d452a92447cec"
  license "MIT"

  livecheck do
    url "https://deviousfish.com/Downloads/pianod2/"
    regex(/href=.*?pianod2[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pianod"
    sha256 mojave: "6c1bac30eee017dbc3644b90995922fbd1756307765718c7c753ce77ada54ce6"
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "ncurses"
  end

  on_linux do
    # pianod uses avfoundation on macOS, ffmpeg on Linux
    depends_on "ffmpeg@4"
    depends_on "gcc"
    depends_on "gnutls"
    depends_on "libbsd"
  end

  fails_with gcc: "5"

  def install
    ENV["OBJCXXFLAGS"] = "-std=c++14"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/pianod", "-v"
  end
end
