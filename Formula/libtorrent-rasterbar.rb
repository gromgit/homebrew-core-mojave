class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  # Remove `stable do` block when patch is no longer needed.
  stable do
    url "https://github.com/arvidn/libtorrent/releases/download/v2.0.5/libtorrent-rasterbar-2.0.5.tar.gz"
    sha256 "e965c2e53170c61c0db3a2d898a61769cb7acd541bbf157cbbef97a185930ea5"

    # Fix build with Boost 1.78. Remove in next release.
    patch do
      url "https://github.com/arvidn/libtorrent/commit/71d608fceca7e61c9d124f9ea83f71b06eda3b17.patch?full_index=1"
      sha256 "20b8e93b67f81af22e50bd668fbeee30147dd85d3ffdff9d624531c32f54e567"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libtorrent-rasterbar"
    rebuild 1
    sha256 cellar: :any, mojave: "8c1e6247fce58dad9d5372b66f23b39a1c4216778f8ecb29de217a48f76cd2f2"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  conflicts_with "libtorrent-rakshasa", because: "they both use the same libname"

  def install
    args = %w[
      -DCMAKE_CXX_STANDARD=14
      -Dencryption=ON
      -Dpython-bindings=ON
      -Dpython-egg-info=ON
    ]
    args += std_cmake_args

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

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
