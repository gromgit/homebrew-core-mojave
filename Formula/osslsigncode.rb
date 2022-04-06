class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/2.3.tar.gz"
  sha256 "b842d6d49d423f7e234674678e9a107aa7b77e95b480677b020ee61dd160b2e3"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/osslsigncode"
    sha256 cellar: :any, mojave: "3618a1012ecbfce207aa3d0810d7e4e88c2a70613a2197bf69dae9001479aef0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    # Requires Windows PE executable as input, so we're just showing the version
    assert_match "osslsigncode", shell_output("#{bin}/osslsigncode --version")
  end
end
