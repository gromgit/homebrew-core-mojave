class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  stable do
    url "https://github.com/arvidn/libtorrent/releases/download/v2.0.6/libtorrent-rasterbar-2.0.6.tar.gz"
    sha256 "438e29272ff41ccc68ec7530f1b98d639f6d01ec8bf680766336ae202a065722"

    patch do
      url "https://github.com/arvidn/libtorrent/commit/a5925cfc862923544d4d2b4dc5264836e2cd1030.patch?full_index=1"
      sha256 "cbcbb988d5c534f0ee97da7cbbc72bcd7a10592c5619970b5330ab646ffc7c52"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libtorrent-rasterbar"
    sha256 cellar: :any, mojave: "467319cfaf55d697ff75f7ba1f08c061422d26800b05442e2a505e5a9668447c"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  conflicts_with "libtorrent-rakshasa", because: "they both use the same libname"

  def install
    args = %W[
      -DCMAKE_CXX_STANDARD=14
      -Dencryption=ON
      -Dpython-bindings=ON
      -Dpython-egg-info=ON
      -DCMAKE_INSTALL_RPATH=#{lib}
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    libexec.install "examples"
  end

  test do
    args = [
      "-I#{Formula["boost"].include}/boost",
      "-L#{Formula["boost"].lib}",
      "-I#{include}",
      "-L#{lib}",
      "-lpthread",
      "-lboost_system",
      "-ltorrent-rasterbar",
    ]

    if OS.mac?
      args += [
        "-framework",
        "SystemConfiguration",
        "-framework",
        "CoreFoundation",
      ]
    end

    system ENV.cxx, libexec/"examples/make_torrent.cpp",
                    "-std=c++14", *args, "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath/"test.torrent", :exist?
  end
end
