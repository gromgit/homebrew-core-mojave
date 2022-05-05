class Codec2 < Formula
  desc "Open source speech codec"
  homepage "https://www.rowetel.com/?page_id=452"
  # Linked from https://freedv.org/
  url "https://github.com/drowe67/codec2/archive/v1.03.tar.gz"
  version "1.0.3"
  sha256 "d1b156035b806fd89a29371a5ab0eefca3ccecfeff303dac0672c59d5c0c1235"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      malformed_tags = ["v1.03"].freeze
      tags.map do |tag|
        next if malformed_tags.include?(tag)

        tag[regex, 1]
      end
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/codec2"
    rebuild 1
    sha256 cellar: :any, mojave: "258692fb4d1ba14ae1638f62d92eba7601d0a0613e8a6349e496ad163fd6b5c3"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build_osx" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}"
      system "make", "install"

      bin.install "demo/c2demo"
      bin.install Dir["src/c2*"]
    end
  end

  test do
    # 8 bytes of raw audio data (silence).
    (testpath/"test.raw").write([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack("C*"))
    system "#{bin}/c2enc", "2400", "test.raw", "test.c2"
  end
end
