class SoundTouch < Formula
  desc "Audio processing library"
  homepage "https://www.surina.net/soundtouch/"
  url "https://codeberg.org/soundtouch/soundtouch/archive/2.3.1.tar.gz"
  sha256 "42633774f372d8cb0a33333a0ea3b30f357c548626526ac9f6ce018c94042692"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sound-touch"
    rebuild 2
    sha256 cellar: :any, mojave: "0d05bc55deb51aa8ccf22613d77158814f09f582ca005b1ed808951a69a90c4b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "/bin/sh", "bootstrap"
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "SoundStretch v#{version} -", shell_output("#{bin}/soundstretch 2>&1", 255)
  end
end
