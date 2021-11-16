class Xrick < Formula
  desc "Clone of Rick Dangerous"
  homepage "https://www.bigorno.net/xrick/"
  url "https://www.bigorno.net/xrick/xrick-021212.tgz"
  # There is a repo at https://github.com/zpqrtbnk/xrick but it is organized
  # differently than the tarball
  sha256 "aa8542120bec97a730258027a294bd16196eb8b3d66134483d085f698588fc2b"

  bottle do
    rebuild 2
    sha256 arm64_big_sur: "06c5d5c23d3a83ae82c8efa8303c186cb8b07f2f274b911062c0a56df4207e96"
    sha256 big_sur:       "07143daa9065782675e5288a66dc2ea8ce418754d4842175b016dbc097b982cd"
    sha256 catalina:      "67d2a811a5ecd67de860f226fc88feec5ed479ae05fc22e917d6fbe0686be783"
    sha256 mojave:        "1a2f4d0cc564fd627d83f2b54606c59845b50fb3db04e7a118ca281377b4805a"
  end

  depends_on "sdl"

  def install
    inreplace "src/xrick.c", "data.zip", "#{pkgshare}/data.zip"
    system "make"
    bin.install "xrick"
    man6.install "xrick.6.gz"
    pkgshare.install "data.zip"
  end

  test do
    assert_match "xrick [version ##{version}]", shell_output("#{bin}/xrick --help", 1)
  end
end
