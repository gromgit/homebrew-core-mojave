class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.18.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/libtasn1/libtasn1-4.18.0.tar.gz"
  sha256 "4365c154953563d64c67a024b607d1ee75c6db76e0d0f65709ea80a334cd1898"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libtasn1"
    rebuild 3
    sha256 cellar: :any, mojave: "b98949e1c9ed4b1cf7c57869b5188d600a59f78a2573245eed1d6bc79b7c4f90"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"pkix.asn").write <<~EOS
      PKIX1 { }
      DEFINITIONS IMPLICIT TAGS ::=
      BEGIN
      Dss-Sig-Value ::= SEQUENCE {
           r       INTEGER,
           s       INTEGER
      }
      END
    EOS
    (testpath/"assign.asn1").write <<~EOS
      dp PKIX1.Dss-Sig-Value
      r 42
      s 47
    EOS
    system "#{bin}/asn1Coding", "pkix.asn", "assign.asn1"
    assert_match "Decoding: SUCCESS", shell_output("#{bin}/asn1Decoding pkix.asn assign.out PKIX1.Dss-Sig-Value 2>&1")
  end
end
