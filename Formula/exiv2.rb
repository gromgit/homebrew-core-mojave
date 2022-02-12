class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://exiv2.org/"
  url "https://github.com/Exiv2/exiv2/releases/download/v0.27.5/exiv2-0.27.5-Source.tar.gz"
  sha256 "35a58618ab236a901ca4928b0ad8b31007ebdc0386d904409d825024e45ea6e2"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/Exiv2/exiv2.git", branch: "main"

  livecheck do
    url "https://exiv2.org/download.html"
    regex(/href=.*?exiv2[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/exiv2"
    rebuild 1
    sha256 cellar: :any, mojave: "ee344f512e9582cb49af0756f87d54a786e58d9ef5158948e9329ff535b24a13"
  end

  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "libssh"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    args = std_cmake_args
    args += %W[
      -DEXIV2_ENABLE_XMP=ON
      -DEXIV2_ENABLE_VIDEO=ON
      -DEXIV2_ENABLE_PNG=ON
      -DEXIV2_ENABLE_NLS=ON
      -DEXIV2_ENABLE_PRINTUCS2=ON
      -DEXIV2_ENABLE_LENSDATA=ON
      -DEXIV2_ENABLE_VIDEO=ON
      -DEXIV2_ENABLE_WEBREADY=ON
      -DEXIV2_ENABLE_CURL=ON
      -DEXIV2_ENABLE_SSH=ON
      -DEXIV2_ENABLE_BMFF=ON
      -DEXIV2_BUILD_SAMPLES=OFF
      -DSSH_LIBRARY=#{Formula["libssh"].opt_lib}/#{shared_library("libssh")}
      -DSSH_INCLUDE_DIR=#{Formula["libssh"].opt_include}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      ..
    ]
    mkdir "build.cmake" do
      system "cmake", "-G", "Unix Makefiles", ".", *args
      system "make", "install"
    end
  end

  test do
    assert_match "288 Bytes", shell_output("#{bin}/exiv2 #{test_fixtures("test.jpg")}", 253)
  end
end
