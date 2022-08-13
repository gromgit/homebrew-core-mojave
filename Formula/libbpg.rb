class Libbpg < Formula
  desc "Image format meant to improve on JPEG quality and file size"
  homepage "https://bellard.org/bpg/"
  url "https://bellard.org/bpg/libbpg-0.9.8.tar.gz"
  sha256 "c0788e23bdf1a7d36cb4424ccb2fae4c7789ac94949563c4ad0e2569d3bf0095"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?libbpg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libbpg"
    sha256 cellar: :any, mojave: "8ea9a3078c0ed8c0b0e8430baa31ca388f634e2aec645d516f231ccad1ef12ac"
  end

  depends_on "cmake" => :build
  depends_on "yasm" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    bin.mkpath
    extra_args = []
    extra_args << "CONFIG_APPLE=y" if OS.mac?
    system "make", "install", "prefix=#{prefix}", *extra_args
    pkgshare.install Dir["html/bpgdec*.js"]
  end

  test do
    system bin/"bpgenc", test_fixtures("test.png")
    assert_predicate testpath/"out.bpg", :exist?
  end
end
