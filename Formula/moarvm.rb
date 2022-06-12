class Moarvm < Formula
  desc "Virtual machine for NQP and Rakudo Perl 6"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2022.04/MoarVM-2022.04.tar.gz"
  sha256 "ae06f50ba5562721a4e5eb6457e2fea2d07eda63e2abaa8c939c9daf70774804"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/moarvm"
    sha256 mojave: "e08e330bd88b5ff4a4adc0c6607e4f878f745c4b8a4e5b800ef71c117dace023"
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "libtommath"
  depends_on "libuv"

  uses_from_macos "perl" => :build

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2022.04/nqp-2022.04.tar.gz"
    sha256 "556d458e25d3c0464af9f04ea3e92bbde10046066b329188a88663943bd4e79c"
  end

  def install
    configure_args = %W[
      --c11-atomics
      --has-libffi
      --has-libtommath
      --has-libuv
      --optimize
      --pkgconfig=#{Formula["pkg-config"].opt_bin}/pkg-config
      --prefix=#{prefix}
    ]
    system "perl", "Configure.pl", *configure_args
    system "make", "realclean"
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("nqp")
    out = Dir.chdir("src/vm/moar/stage0") do
      shell_output("#{bin}/moar nqp.moarvm -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    end
    assert_equal "0123456789", out
  end
end
