class Wallpaper < Formula
  desc "Manage the desktop wallpaper"
  homepage "https://github.com/sindresorhus/macos-wallpaper"
  url "https://github.com/sindresorhus/macos-wallpaper/archive/v2.0.0.tar.gz"
  sha256 "49ab6121dcc78d17aae3219ceeeb1846792855179f11021192e5c42e500b166c"
  head "https://github.com/sindresorhus/macos-wallpaper.git"

  disable! date: "2021-12-24", because: "fails testing under Mojave"

  depends_on xcode: ["10.0", :build]

  def install
    system "swift", "build", "-c", "release", "-Xswiftc", "-static-stdlib", "--disable-sandbox"
    bin.install ".build/release/wallpaper"
  end

  test do
    system "#{bin}/wallpaper", "get"
  end
end
