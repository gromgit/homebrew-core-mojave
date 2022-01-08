class Libid3tag < Formula
  desc "ID3 tag manipulation library"
  homepage "https://www.underbit.com/products/mad/"
  url "https://github.com/tenacityteam/libid3tag/archive/refs/tags/0.16.1.tar.gz"
  sha256 "185a6cec84644cf1aade8397dcf76753bcb3bd85ec2111a9e1079214ed85bef0"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libid3tag"
    sha256 cellar: :any, mojave: "729ea9b47dc8efeae7ef797a862614a2dd75359d86c496523795d5708f8a13e5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test

  uses_from_macos "gperf"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <id3tag.h>

      int main(int n, char** c) {
        struct id3_file *fp = id3_file_open("#{test_fixtures("test.mp3")}", ID3_FILE_MODE_READONLY);
        struct id3_tag *tag = id3_file_tag(fp);
        struct id3_frame *frame = id3_tag_findframe(tag, ID3_FRAME_TITLE, 0);
        id3_file_close(fp);

        return 0;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs id3tag").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
