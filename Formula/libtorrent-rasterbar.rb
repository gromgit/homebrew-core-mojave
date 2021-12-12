class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.5/libtorrent-rasterbar-2.0.5.tar.gz"
  sha256 "e965c2e53170c61c0db3a2d898a61769cb7acd541bbf157cbbef97a185930ea5"
  license "BSD-3-Clause"
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libtorrent-rasterbar"
    sha256 cellar: :any, mojave: "ad07726ca9e06b8f3a5ddd11ee0045648ad9c67a8f1dddba50240cc3e77f7bdd"
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

    on_macos do
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
