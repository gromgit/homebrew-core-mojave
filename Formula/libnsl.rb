class Libnsl < Formula
  desc "Public client interface for NIS(YP) and NIS+"
  homepage "https://github.com/thkukuk/libnsl"
  url "https://github.com/thkukuk/libnsl/releases/download/v2.0.0/libnsl-2.0.0.tar.xz"
  sha256 "2da075ef1893ebdfc5f074f83ac811873dc06fd5c62bc9a4729fd2e27a40341a"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ed70b285939e2ab21ba53d122ce2d4beab4cd0f9c86925c3d3a2cfb1b0eeecb3"
  end

  depends_on "pkg-config" => :build
  depends_on "libtirpc"
  depends_on :linux

  link_overwrite "include/rpcsvc"
  link_overwrite "lib/libnsl.a"
  link_overwrite "lib/libnsl.so"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <rpcsvc/ypclnt.h>

      int main(int argc, char *argv[]) {
         char *domain;
         switch (yp_get_default_domain(&domain)) {
         case YPERR_SUCCESS:
           printf("Domain: %s\n", domain);
           return 0;
         case YPERR_NODOM:
           printf("No domain\n");
           return 0;
         default:
           return 1;
         }
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnsl", "-o", "test"

    domain = Utils.popen_read("ypdomainname").chomp
    domain_exists = $CHILD_STATUS.success?

    output = shell_output("./test").chomp
    if domain_exists
      assert_equal "Domain: #{domain}", output
    else
      assert_equal "No domain", output
    end
  end
end
