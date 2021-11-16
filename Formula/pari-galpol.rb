class PariGalpol < Formula
  desc "Galois polynomial database for PARI/GP"
  homepage "https://pari.math.u-bordeaux.fr/packages.html"
  url "https://pari.math.u-bordeaux.fr/pub/pari/packages/galpol.tgz"
  # Refer to http://pari.math.u-bordeaux.fr/packages.html#packages for most recent package date
  version "20180625"
  sha256 "562af28316ee335ee38c1172c2d5ecccb79f55c368fb9f2c6f40fc0f416bb01b"
  license "GPL-2.0-or-later"

  # The only difference in the `livecheck` blocks for pari-* formulae is the
  # package name in the regex and they should otherwise be kept in parity.
  livecheck do
    url :homepage
    regex(%r{>\s*galpol\.t[^<]+?</a>(?:[&(.;\s\w]+?(?:\),?|,))?\s*([a-z]+\s+\d{1,2},?\s+\d{4})\D}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| Date.parse(match.first)&.strftime("%Y%m%d") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5574927ca436092cb927939102bb2fc3402f2c3d9aa137295959061002c362ad"
  end

  depends_on "pari"

  def install
    Dir.glob("galpol/*/**/*").each do |path|
      gzip(path) unless File.directory?(path)
    end

    (share/"pari/galpol").install Dir["galpol/*/"]
    doc.install "galpol/README"
  end

  test do
    assert_equal "5", pipe_output(Formula["pari"].opt_bin/"gp -q", "galoisgetpol(8)").chomp
    assert_equal "\"C3 : C4\"", pipe_output(Formula["pari"].opt_bin/"gp -q", "galoisgetname(12,1)").chomp
  end
end
