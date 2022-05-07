class Zlib < Formula
  desc "General-purpose lossless data-compression library"
  homepage "https://zlib.net/"
  url "https://zlib.net/zlib-1.2.12.tar.gz"
  mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.2.12/zlib-1.2.12.tar.gz"
  sha256 "91844808532e5ce316b3c010929493c0244f3d37593afd6de04f71821d5136d9"
  license "Zlib"
  head "https://github.com/madler/zlib.git", branch: "develop"

  livecheck do
    url :homepage
    regex(/href=.*?zlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/zlib"
    sha256 cellar: :any, mojave: "6974883b5e4c59d54d9a66d2eb5f099241e3b061f6c540db49bbc968ef2c44a6"
  end

  keg_only :provided_by_macos

  # https://zlib.net/zlib_how.html
  resource "test_artifact" do
    url "https://zlib.net/zpipe.c"
    version "20051211"
    sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
  end

  # Patch for configure issue
  # Remove with the next release
  patch do
    url "https://github.com/madler/zlib/commit/05796d3d8d5546cf1b4dfe2cd72ab746afae505d.patch?full_index=1"
    sha256 "68573842f1619bb8de1fa92071e38e6e51b8df71371e139e4e96be19dd7e9694"
  end

  # Patch for CRC compatibility issue
  # Remove with the next release
  patch do
    url "https://github.com/madler/zlib/commit/ec3df00224d4b396e2ac6586ab5d25f673caa4c2.patch?full_index=1"
    sha256 "c7d1cbb58b144c48b7fa8b52c57531e9fd80ab7d87c5d58ba76a9d33c12cb047"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testpath.install resource("test_artifact")
    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz", "-o", "zpipe"

    touch "foo.txt"
    output = "./zpipe < foo.txt > foo.txt.z"
    system output
    assert_predicate testpath/"foo.txt.z", :exist?
  end
end
