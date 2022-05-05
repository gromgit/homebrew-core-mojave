class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  url "https://github.com/uriparser/uriparser/releases/download/uriparser-0.9.6/uriparser-0.9.6.tar.bz2"
  sha256 "9ce4c3f151e78579f23937b44abecb428126863ad02e594e115e882353de905b"
  license "BSD-3-Clause"
  head "https://github.com/uriparser/uriparser.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/uriparser"
    rebuild 1
    sha256 cellar: :any, mojave: "3e95ef3cb76b4328651d3b2a5e234a7aeb90f180f2b585834362138a866e6e94"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DURIPARSER_BUILD_TESTS=OFF",
                         "-DURIPARSER_BUILD_DOCS=OFF",
                         "-DCMAKE_INSTALL_RPATH=#{rpath}",
                         *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    expected = <<~EOS
      uri:          https://brew.sh
      scheme:       https
      hostText:     brew.sh
      absolutePath: false
                    (always false for URIs with host)
    EOS
    assert_equal expected, shell_output("#{bin}/uriparse https://brew.sh").chomp
  end
end
