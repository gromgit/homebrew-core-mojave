class Wallpaper < Formula
  desc "Manage the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/v2.1.0.tar.gz"
  sha256 "4925247524535c0cc128dcc4d87f5538a5ce3b5d3a3c211127fd646ee00252b6"
  license "MIT"
  revision 1
  head "https://github.com/sindresorhus/macos-wallpaper.git", branch: "main"

  depends_on xcode: ["11.4", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/wallpaper"
  end

  test do
    system "#{bin}/wallpaper", "get"
  end
end
