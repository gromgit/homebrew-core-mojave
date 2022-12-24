class Bedtools < Formula
  desc "Tools for genome arithmetic (set theory on the genome)"
  homepage "https://github.com/arq5x/bedtools2"
  url "https://github.com/arq5x/bedtools2/archive/v2.30.0.tar.gz"
  sha256 "c575861ec746322961cd15d8c0b532bb2a19333f1cf167bbff73230a7d67302f"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bedtools"
    rebuild 3
    sha256 cellar: :any, mojave: "d2e159d32596af9bd6d4caffe962f65dc1a79336756e8b4eb758c8114d03354d"
  end

  depends_on "xz"

  uses_from_macos "python" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # Remove on the next release which has commit try both python and python3
    # Ref: https://github.com/arq5x/bedtools2/commit/ffbc4e18d100ccb488e4a9e7e64146ec5d3af849
    inreplace "Makefile", "python", "python3" if !OS.mac? || MacOS.version >= :catalina

    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"t.bed").write "c\t1\t5\nc\t4\t9"
    assert_equal "c\t1\t9", shell_output("#{bin}/bedtools merge -i t.bed").chomp
  end
end
