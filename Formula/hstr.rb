class Hstr < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/archive/2.5.tar.gz"
  sha256 "7f5933fc07d55d09d5f7f9a6fbfdfc556d8a7d8575c3890ac1e672adabd2bec4"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hstr"
    sha256 cellar: :any, mojave: "80eb88fe988f6e912a35f2fede55db406fedba4f34fc41371ba4c4885753dbae"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["HISTFILE"] = testpath/".hh_test"
    (testpath/".hh_test").write("test\n")
    assert_equal "test", shell_output("#{bin}/hh -n").chomp
  end
end
