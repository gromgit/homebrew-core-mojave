class Mp3unicode < Formula
  desc "Command-line utility to convert mp3 tags between different encodings"
  homepage "https://mp3unicode.sourceforge.io/"
  url "https://github.com/alonbl/mp3unicode/releases/download/mp3unicode-1.2.1/mp3unicode-1.2.1.tar.bz2"
  sha256 "375b432ce784407e74fceb055d115bf83b1bd04a83b95256171e1a36e00cfe07"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:mp3unicode[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e2f6b5eef63cc1163c65a34fe790a49d41293a35c5f693fd853f982b423141fb"
    sha256 cellar: :any,                 arm64_big_sur:  "a8e60d07b3170593185a88afd02c48bbef315ddcbae9cbfa0ef52541eea5348e"
    sha256 cellar: :any,                 monterey:       "01066562450ecbd024f9b326cdb22041a4e52205cef900bb6c8107f67253d422"
    sha256 cellar: :any,                 big_sur:        "ae87c394bcab69fca57f9bb99e03716fc5073319934fb32cf0e45cf948be9a68"
    sha256 cellar: :any,                 catalina:       "61f39a1605947240874a49624d9aff5aa848c3edcf24017c70f70fc1c7c04e2b"
    sha256 cellar: :any,                 mojave:         "b0b4f5e1d3bcee44c469cd1948f173175b0826569503bad26d027f10a1ebb92e"
    sha256 cellar: :any,                 high_sierra:    "5d288104d6bf3c0bdce26b509f29b49adba281ebcf1eb713a578298cec4b1305"
    sha256 cellar: :any,                 sierra:         "4d8a82928bc851fc314a6c8f57a3897d6f75df65aad84e79b451783d217ebd1d"
    sha256 cellar: :any,                 el_capitan:     "e9db3c9529d5358f83bb67d5966c6b508851f27a3bc61d5212b674d620a03a7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35961520ec6d4a22ed9a64bfa6b8878f8d6a991870fd5fa2a2e4a79ffd1fc13d"
  end

  head do
    url "https://github.com/alonbl/mp3unicode.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "taglib"

  def install
    ENV.append "ICONV_LIBS", "-liconv" if OS.mac?

    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mp3unicode", "-s", "ASCII", "-w", test_fixtures("test.mp3")
  end
end
