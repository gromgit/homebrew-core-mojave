class Cmockery < Formula
  desc "Unit testing and mocking library for C"
  homepage "https://github.com/google/cmockery"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/cmockery/cmockery-0.1.2.tar.gz"
  sha256 "b9e04bfbeb45ceee9b6107aa5db671c53683a992082ed2828295e83dc84a8486"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "aa62f9303682b243044246c155e301361e9ea68a52b9ff66a83a6432aa7b1ddd"
    sha256 cellar: :any,                 big_sur:       "cfecce020c743de6d0e72dbcc3d5a104024e69979c3b8fa085997b3a5ae17619"
    sha256 cellar: :any,                 catalina:      "1df72472ccf182fc7de6a14b047affceba8e7c986110f883ef55701b93b19d0f"
    sha256 cellar: :any,                 mojave:        "d239e243454b5bac5d0bab915ff506199c97bd27bf188c0938911c5c091af020"
    sha256 cellar: :any,                 high_sierra:   "8ee7bb6453fae2cdfc129f6aad3ac9a8766a396ec7df9d38444f6b688697c3ea"
    sha256 cellar: :any,                 sierra:        "f3b1c3d5c96ea9e30dc008e557239e972a18e65b3dd1ee8a593a0eb6e11d7858"
    sha256 cellar: :any,                 el_capitan:    "6cc440503b2fce7def7d584aacf8e9142ad430de799b466f609f57fd9beb4ede"
    sha256 cellar: :any,                 yosemite:      "a6ac86af8d5b7f5964a480cc91bfbdaf260c59eae2c4b79663ebab2dfdb7d062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "533f1415fd60a5f31757ede621f69316eb6a944b1702a0c9a846cadd9390d2d6"
  end

  # This patch will be integrated upstream in 0.1.3, this is due to malloc.h being already in stdlib on OSX
  # It is safe to remove it on the next version
  # More info on https://code.google.com/p/cmockery/issues/detail?id=3
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/cmockery/0.1.2.patch"
    sha256 "4e1ba6ac1ee11350b7608b1ecd777c6b491d952538bc1b92d4ed407669ec712d"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
