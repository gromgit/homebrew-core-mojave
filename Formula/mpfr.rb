class Mpfr < Formula
  desc "C library for multiple-precision floating-point computations"
  homepage "https://www.mpfr.org/"
  license "LGPL-3.0-or-later"

  stable do
    url "https://ftp.gnu.org/gnu/mpfr/mpfr-4.1.0.tar.xz"
    mirror "https://ftpmirror.gnu.org/mpfr/mpfr-4.1.0.tar.xz"
    sha256 "0c98a3f1732ff6ca4ea690552079da9c597872d30e96ec28414ee23c95558a7f"
    version "4.1.0-p13"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end

    # Upstream patches, list at https://www.mpfr.org/mpfr-current/#fixed
    %w[
      01 a2d9bc87c5642be805eaec5f03f30235f3dd5985bb4edb6917f110b849fa0c40
      02 20e0ec276d2a091a1154ed000ea19855f26c7190ed01bde745cc84284ae929db
      03 f07903f25dd92ee086f214177870517487f00cb3f2e130db66d252552335b655
      04 86d0a884a34d94f1ce3537b548f6ca1e027d466914f65165a359b84fe6630926
      05 bc4860ad2a822c2fc08913255882b117a2e9668df9fd21c3ca07633d4ab3a50b
      06 6dfa09a25a0f7cc553cbfd9cb18de95936ee1234c90f5db7437b8dc4dd5aae24
      07 e65d93a434048f80fa30e2230b47896764abff5757fc4575262270b05bbc457a
      08 b9991564eb2cbdcb419254c2a03729ee5c44dae45ee08f09a6ae5193df6b1f78
      09 e5642c27d91166371da83b05ae4c9d5e8b7f48fff064d16b150d94810b32bc0b
      10 31a12fe331c779120da5bb3036d57fd86c2a16b6fc66b8a7cae3c5db007d8cae
      11 37efcec4cfcff50eec27b30a22be7921b6ebc0c3dedc41137d69aba3c1630ea6
      12 839e7240f30c731a63122c98c1a1a359642fb3fa3dbb07e50f8bb2e1d36c3d29
      13 4d04d39954df48b2dd6ecbf875c8c143cae3b3362303b5bdb40b643fead2e79b
    ].each_slice(2) do |p, checksum|
      patch do
        url "https://www.mpfr.org/mpfr-4.1.0/patch#{p}"
        sha256 checksum
      end
    end
  end

  livecheck do
    url "https://www.mpfr.org/mpfr-current/"
    regex(/href=.*?mpfr[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      version = page.scan(regex).map { |match| Version.new(match[0]) }.max&.to_s
      next if version.blank?

      patch = page.scan(%r{href=["']?/?patch(\d+)["' >]}i)
                  .map { |match| Version.new(match[0]) }
                  .max
                  &.to_s
      next version if patch.blank?

      "#{version}-p#{patch}"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mpfr"
    sha256 cellar: :any_skip_relocation, mojave: "0b3179aea5bace142ba8d2b63e9572570a423b6b58e95ba3db176f3a57d7efef"
  end

  head do
    url "https://gitlab.inria.fr/mpfr/mpfr.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "texinfo" => :build # needed because of the patches
  depends_on "gmp"

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mpfr.h>
      #include <math.h>
      #include <stdlib.h>
      #include <string.h>

      int main() {
        mpfr_t x, y;
        mpfr_inits2 (256, x, y, NULL);
        mpfr_set_ui (x, 2, MPFR_RNDN);
        mpfr_rootn_ui (y, x, 2, MPFR_RNDN);
        mpfr_pow_si (x, y, 4, MPFR_RNDN);
        mpfr_add_si (y, x, -4, MPFR_RNDN);
        mpfr_abs (y, y, MPFR_RNDN);
        if (fabs(mpfr_get_d (y, MPFR_RNDN)) > 1.e-30) abort();
        if (strcmp("#{version}", mpfr_get_version())) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-L#{Formula["gmp"].opt_lib}",
                   "-lgmp", "-lmpfr", "-o", "test"
    system "./test"
  end
end
