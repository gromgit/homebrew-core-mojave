class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.29.0.tar.xz"
  sha256 "da3fbcf02877f9be0f028bfa5d1cb59e953a4049b90fe7e39388a3386d9f362e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mednafen.github.io/releases/"
    regex(/href=.*?mednafen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mednafen"
    sha256 mojave: "dc8f6d2e1757794668d9844e1f2f9e79b050433f8bedccead30ec31fec032ba4"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libsndfile"
  depends_on macos: :sierra # needs clock_gettime
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    # Test fails on headless CI: Could not initialize SDL: No available video device
    on_linux do
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    cmd = "#{bin}/mednafen | head -n1 | grep -o '[0-9].*'"
    assert_equal version.to_s, shell_output(cmd).chomp
  end
end
