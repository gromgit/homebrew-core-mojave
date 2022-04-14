class Rakudo < Formula
  desc "Perl 6 compiler targeting MoarVM"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2022.02/rakudo-2022.02.tar.gz"
  sha256 "6a6e9dbcc6d9a1610a34c6ec67e2d3f694d7b33e9e0a0f224543089fa7f71332"
  license "Artistic-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rakudo"
    sha256 mojave: "b3716c92d8e50a456736bca2d0a26088e7365ab124e52b2aca1d7181cdb51719"
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
