class Muparser < Formula
  desc "C++ math expression parser library"
  homepage "https://github.com/beltoforion/muparser"
  url "https://github.com/beltoforion/muparser/archive/v2.3.3-1.tar.gz"
  sha256 "91d26d8274ae9cd9c776ee58250aeddc6b574f369eafd03b25045b858a2b8177"
  license "BSD-2-Clause"
  head "https://github.com/beltoforion/muparser.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/muparser"
    sha256 cellar: :any, mojave: "6c8dbe4d57f744db842394591ac5b1749f4982dc4de2ac3a60743049361561aa"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11 if OS.linux?
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_OPENMP=OFF"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include "muParser.h"

      double MySqr(double a_fVal)
      {
        return a_fVal*a_fVal;
      }

      int main(int argc, char* argv[])
      {
        using namespace mu;
        try
        {
          double fVal = 1;
          Parser p;
          p.DefineVar("a", &fVal);
          p.DefineFun("MySqr", MySqr);
          p.SetExpr("MySqr(a)*_pi+min(10,a)");

          for (std::size_t a=0; a<100; ++a)
          {
            fVal = a;  // Change value of variable a
            std::cout << p.Eval() << std::endl;
          }
        }
        catch (Parser::exception_type &e)
        {
          std::cout << e.GetMsg() << std::endl;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}",
           testpath/"test.cpp", "-L#{lib}", "-lmuparser",
           "-o", testpath/"test"
    system "./test"
  end
end
