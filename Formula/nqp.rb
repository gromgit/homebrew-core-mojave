class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2022.04/nqp-2022.04.tar.gz"
  sha256 "556d458e25d3c0464af9f04ea3e92bbde10046066b329188a88663943bd4e79c"
  license "Artistic-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nqp"
    sha256 mojave: "d89f78ed03773862ef399ed48dca96eddfd890d2f5a26368624d8178ce310a70"
  end

  depends_on "libtommath"
  depends_on "moarvm"

  uses_from_macos "perl" => :build

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
    # Work around Homebrew's directory structure and help find moarvm libraries
    inreplace "tools/build/gen-version.pl", "$libdir, 'MAST'", "'#{Formula["moarvm"].opt_share}/nqp/lib/MAST'"

    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}/moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end
