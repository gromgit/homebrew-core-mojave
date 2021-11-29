class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v4.3.0.tar.gz"
  sha256 "e8be95e7061cad52caaa98a4d2a25d6bff8fa29c2fa609c3c447124d46b1712b"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/odpi"
    rebuild 1
    sha256 cellar: :any, mojave: "598d3b0cf32316d3e5e84cc0f6de20119e598162c1c52524e26ad0a648871f39"
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
