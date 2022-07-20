class Yazpp < Formula
  desc "C++ API for the Yaz toolkit"
  homepage "https://www.indexdata.com/resources/software/yazpp/"
  url "https://ftp.indexdata.com/pub/yazpp/yazpp-1.8.0.tar.gz"
  sha256 "e6c32c90fa83241e44e506a720aff70460dfbd0a73252324b90b9489eaeb050d"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://ftp.indexdata.com/pub/yazpp/"
    regex(/href=.*?yazpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/yazpp"
    sha256 cellar: :any, mojave: "1899060c7ad16bf3385d3628fd9beba0bd35da2def4541eed0186451678bd6c7"
  end

  depends_on "yaz"

  def install
    ENV.cxx11 if OS.linux? # due to `icu4c` dependency in `libxml2`
    system "./configure", *std_configure_args
    system "make", "install"

    # Replace `yaz` cellar paths, which break on `yaz` version or revision bumps
    inreplace bin/"yazpp-config", Formula["yaz"].prefix.realpath, Formula["yaz"].opt_prefix
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <yazpp/zoom.h>

      using namespace ZOOM;

      int main(int argc, char **argv){
        try
        {
          connection conn("wrong-example.xyz", 210);
        }
        catch (exception &e)
        {
          std::cout << "Exception caught";
        }
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}/src",
                    "-L#{lib}", "-lzoompp", "-o", "test"
    output = shell_output("./test")
    assert_match "Exception caught", output
  end
end
