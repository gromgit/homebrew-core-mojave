class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v4.4.1.tar.gz"
  sha256 "c5fc27ef90d12417cb3c2bab32ed539bb4c389fde24ceb6d1df06a0985543c1a"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/odpi"
    sha256 cellar: :any, mojave: "6c2f41a163cdc8d7f2a6107ce9318946c8eae3e5dc813b1da1d78cae4e4838a0"
  end

  def install
    system "make"

    lib.install Dir["lib/*"]
    include.install Dir["include/*"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <dpi.h>

      int main()
      {
        dpiContext* context = NULL;
        dpiErrorInfo errorInfo;

        dpiContext_create(DPI_MAJOR_VERSION, DPI_MINOR_VERSION, &context, &errorInfo);

        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lodpic", "-o", "test"
    system "./test"
  end
end
