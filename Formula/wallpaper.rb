class Wallpaper < Formula
  desc "Manage the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/v2.3.1.tar.gz"
  sha256 "d6aebaca1083ee3e5d6494f5574931691bad239a98e8fe99655790a40f2cb80a"
  license "MIT"
  head "https://github.com/sindresorhus/macos-wallpaper.git", branch: "main"

  bottle do
    sha256 mojave: "f27baf8ae2f171b8f7236ee399bb9df7da423c4ef81b68d7e0ece78df850d204" # fake mojave
  end

  depends_on xcode: ["13.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/wallpaper"
  end

  test do
    system "#{bin}/wallpaper", "get"
  end
end
