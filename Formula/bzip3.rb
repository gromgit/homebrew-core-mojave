class Bzip3 < Formula
  desc "Better and stronger spiritual successor to BZip2"
  homepage "https://github.com/kspalaiologos/bzip3"
  url "https://github.com/kspalaiologos/bzip3/releases/download/1.2.2/bzip3-1.2.2.tar.gz"
  sha256 "19e8d379f48610f945a04a988fd0c330ff6613b3df96405d56bed35a7d216dee"
  license "LGPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bzip3"
    sha256 cellar: :any, mojave: "2936a6a0fbba03e80e60765500e9426625009f21594bdf6d356d95b1573a9925"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--disable-arch-native"
    system "make", "install"
  end

  test do
    testfilepath = testpath + "sample_in.txt"
    zipfilepath = testpath + "sample_in.txt.bz3"

    testfilepath.write "TEST CONTENT"

    system bin/"bzip3", testfilepath
    system bin/"bunzip3", "-f", zipfilepath

    assert_equal "TEST CONTENT", testfilepath.read
  end
end
