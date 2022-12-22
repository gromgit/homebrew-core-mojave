class Ccfits < Formula
  desc "Object oriented interface to the cfitsio library"
  homepage "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/"
  url "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/CCfits-2.6.tar.gz"
  sha256 "2bb439db67e537d0671166ad4d522290859e8e56c2f495c76faa97bc91b28612"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?CCfits[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ccfits"
    sha256 cellar: :any, mojave: "b117f22f0494c09f29bc88c9c0bbdf523115bf9ad2a536344872df8ef68dc2fe"
  end

  depends_on "cfitsio"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    # Remove references to brew's shims
    args << "pfk_cxx_lib_path=/usr/bin/g++" if OS.linux?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <CCfits/CCfits>
      #include <iostream>
      int main() {
        CCfits::FITS::setVerboseMode(true);
        std::cout << "the answer is " << CCfits::VTbyte << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-lCCfits"
    assert_match "the answer is -11", shell_output("./test")
  end
end
