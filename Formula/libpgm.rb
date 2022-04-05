class Libpgm < Formula
  desc "Implements the PGM reliable multicast protocol"
  homepage "https://github.com/steve-o/openpgm"
  license "LGPL-2.1-or-later"
  head "https://github.com/steve-o/openpgm.git", branch: "master"

  stable do
    url "https://github.com/steve-o/openpgm/archive/release-5-3-128.tar.gz"
    version "5.3.128"
    sha256 "8d707ef8dda45f4a7bc91016d7f2fed6a418637185d76c7ab30b306499c6d393"

    # Fix build on ARM. Remove in the next release along with stable block
    patch do
      url "https://github.com/steve-o/openpgm/commit/8d507fc0af472762f95da44036fb77662ff4cd2a.patch?full_index=1"
      sha256 "070c3b52fd29f6c594bb6728a960bc19e4ea7d00b2c7eac51e33433e07d775b3"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libpgm"
    sha256 cellar: :any, mojave: "7e9058babd6108e0106ae1abf50daf05a2119d5f353b1fe99e635260dd392846"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    workdir = build.stable? ? "openpgm/pgm" : "pgm"
    cd workdir do
      # Fix version number
      cp "openpgm-5.2.pc.in", "openpgm-5.3.pc.in" if build.stable?
      system "./bootstrap.sh"
      system "./configure", *std_configure_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <pgm/pgm.h>

      int main(void) {
        pgm_error_t* pgm_err = NULL;
        if (!pgm_init (&pgm_err)) {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/pgm-5.3", "-L#{lib}", "-lpgm", "-o", "test"
    system "./test"
  end
end
