class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "https://shibboleth.net/downloads/c++-opensaml/3.2.1/opensaml-3.2.1.tar.bz2"
  sha256 "b402a89a130adcb76869054b256429c1845339fe5c5226ee888686b6a026a337"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?opensaml[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/opensaml"
    rebuild 2
    sha256 cellar: :any, mojave: "375b8691346d40e320b3398f3820b49e8f03a4f152fc783e83dcfc224daf5621"
  end

  depends_on "pkg-config" => :build
  depends_on "log4shib"
  depends_on "openssl@1.1"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.cxx11

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "see documentation for usage", shell_output("#{bin}/samlsign 2>&1", 255)
  end
end
