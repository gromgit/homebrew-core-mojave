class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2021.10/rakudo-2021.10.tar.gz"
  sha256 "b174c7537328efb5e3f74245e79fa7159b70131b84c597916cf5a65c2aca24a1"
  license "Artistic-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rakudo"
    rebuild 2
    sha256 mojave: "45b6266de43dba2d385d943fe0703baca69f775c3574fc8598c336ee1618e2f7"
  end

  depends_on "nqp"

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-nqp=#{Formula["nqp"].bin}/nqp"
    system "make"
    system "make", "install"
    bin.install "tools/install-dist.p6" => "perl6-install-dist"
  end

  test do
    out = shell_output("#{bin}/perl6 -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end
