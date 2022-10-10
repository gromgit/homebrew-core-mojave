class Opencc < Formula
  desc "Simplified-traditional Chinese conversion tool"
  homepage "https://github.com/BYVoid/OpenCC"
  url "https://github.com/BYVoid/OpenCC/archive/ver.1.1.4.tar.gz"
  sha256 "ca33cf2a2bf691ee44f53397c319bb50c6d6c4eff1931a259fd11533ba26c1e9"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/opencc"
    sha256 mojave: "8be74285f8f33e72e4dfefa3554d3135d73db2c3bcd43f73a2df3a49920536e5"
  end

  depends_on "cmake" => :build
  if MacOS.version < :catalina
    depends_on "python@3.10" => :build
  else
    uses_from_macos "python" => :build
  end

  def install
    ENV.cxx11
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPYTHON_EXECUTABLE=#{which("python3")}
    ]
    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    input = "中国鼠标软件打印机"
    output = pipe_output("#{bin}/opencc", input)
    output = output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_match "中國鼠標軟件打印機", output
  end
end
