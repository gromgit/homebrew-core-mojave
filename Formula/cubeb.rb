class Cubeb < Formula
  desc "Cross-platform audio library"
  homepage "https://github.com/kinetiknz/cubeb"
  url "https://github.com/kinetiknz/cubeb/archive/cubeb-0.2.tar.gz"
  sha256 "cac10876da4fa3b3d2879e0c658d09e8a258734562198301d99c1e8228e66907"
  license "ISC"
  head "https://github.com/kinetiknz/cubeb.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "506fb6090f05b4275bde1aff78c0eb1bf72959fbeac5c53018c728863ef1195f"
    sha256 cellar: :any, arm64_big_sur:  "e56366a9d51f95c573e9bcc0a7f8985e4607cf88a9e6a87c0f2193a363c18a93"
    sha256 cellar: :any, monterey:       "0734f84782c17da435dc805f42c1af96506669ed1337aa8a0a20f486975d771a"
    sha256 cellar: :any, big_sur:        "06c2e45c008f9b2c6068c5ccb4adf3d4d7ca75e4b0b25429af1577391a6b2d8b"
    sha256 cellar: :any, catalina:       "98061577ff4699c6d87158764616203f1bc758a858c88683fd7f7f10f90e74b5"
    sha256 cellar: :any, mojave:         "d34baf923b56edec2ae8201857c55426584f35b47ef8e2e6577a38f684fbab75"
    sha256 cellar: :any, high_sierra:    "618debffabe494dcde3e0d7e2231078df124ead8ee342886ab38ad7373f73e37"
    sha256 cellar: :any, sierra:         "f89e89027370ea9da99f72f0af0529f9b63fbe31c434d3ccafdc7230664a41c2"
    sha256 cellar: :any, el_capitan:     "f7e738b374bb07e1c420e56dfeb72caa814495b446c71d8158ef98c9b33d3a60"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <cubeb/cubeb.h>

      #define TEST(test, msg) \
        if ((test)) { \
          printf("PASS: %s\\n", msg); \
        } else { \
          printf("FAIL: %s\\n", msg); \
          goto end; \
        }

      /* Dummy callbacks to use for audio stream test */
      static long data_callback(cubeb_stream *stream, void *user, void *buffer,
          long nframes) {
        return nframes;
      }
      static void state_callback(cubeb_stream *stream, void *user_ptr,
          cubeb_state state) {}

      int main() {
        int ret;
        cubeb *ctx;
        char const *backend_id;
        cubeb_stream *stream;
        cubeb_stream_params params;

        /* Verify that the library initialises itself successfully */
        ret = cubeb_init(&ctx, "test_context");
        TEST(ret == CUBEB_OK, "initialse cubeb context");

        /* Verify backend id can be retrieved */
        backend_id = cubeb_get_backend_id(ctx);
        TEST(backend_id != NULL, "retrieve backend id");

        /* Verify that an audio stream gets opened successfully */
        params.format = CUBEB_SAMPLE_S16LE; /* use commonly supported      */
        params.rate = 48000;                /* parametrs, so that the test */
        params.channels = 1;                /* doesn't give a false fail   */
        ret = cubeb_stream_init(ctx, &stream, "test_stream", params, 100,
          data_callback, state_callback, NULL);
        TEST(ret == CUBEB_OK, "initialise stream");

      end:
        /* Cleanup and return */
        cubeb_stream_destroy(stream);
        cubeb_destroy(ctx);
        return 0;
      }
    EOS
    system "cc", "-o", "test", "#{testpath}/test.c", "-L#{lib}", "-lcubeb"
    refute_match(/FAIL:.*/, shell_output("#{testpath}/test"),
                    "Basic sanity test failed.")
  end
end
