class Libbtbb < Formula
  include Language::Python::Shebang

  desc "Bluetooth baseband decoding library"
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2020-12-R1.tar.gz"
  version "2020-12-R1"
  sha256 "9478bb51a38222921b5b1d7accce86acd98ed37dbccb068b38d60efa64c5231f"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/greatscottgadgets/libbtbb.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libbtbb"
    sha256 cellar: :any, mojave: "574b5d65508cef6c1d2f425d5ef0f31a153a7a56a542a3b72c5e871ccacb92a4"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    rewrite_shebang detected_python_shebang, bin/"btaptap"
  end

  test do
    system bin/"btaptap", "-r", test_fixtures("test.pcap")
  end
end
