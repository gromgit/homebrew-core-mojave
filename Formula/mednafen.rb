class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.29.0.tar.xz"
  sha256 "da3fbcf02877f9be0f028bfa5d1cb59e953a4049b90fe7e39388a3386d9f362e"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "https://mednafen.github.io/releases/"
    regex(/href=.*?mednafen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mednafen"
    sha256 mojave: "d365afa5a062d38918d1d0fb1b8b56b8e4dee17494f364da53dccea6c4406b28"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libsndfile"
  depends_on "lzo"
  depends_on macos: :sierra # needs clock_gettime
  depends_on "sdl2"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_macos do
    # musepack is not bottled on Linux
    # https://github.com/Homebrew/homebrew-core/pull/92041
    depends_on "musepack"
  end

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    args = std_configure_args
    args << "--with-external-mpcdec" if OS.mac? # musepack

    system "./configure", "--with-external-lzo",
                          "--with-external-libzstd",
                          "--enable-ss",
                          *args
    system "make", "install"
  end

  test do
    # Test fails on headless CI: Could not initialize SDL: No available video device
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    cmd = "#{bin}/mednafen | head -n1 | grep -o '[0-9].*'"
    assert_equal version.to_s, shell_output(cmd).chomp
  end
end
