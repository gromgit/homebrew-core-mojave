class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.16.tar.xz"
  sha256 "870eb571eae6d23fb92ad0c84d79de9c38c5f624e3614937d574bfe49ba687f9"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/mpop/download/"
    regex(/href=.*?mpop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mpop"
    rebuild 2
    sha256 mojave: "15669c8f77117177f30c05bc7d50d0a8a0878c87d5b4a7751bdecf3ae492bc4b"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libidn2"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
