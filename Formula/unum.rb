class Unum < Formula
  desc "Interconvert numbers, Unicode, and HTML/XHTML entities"
  homepage "https://www.fourmilab.ch/webtools/unum/"
  url "https://www.fourmilab.ch/webtools/unum/prior-releases/3.5-15.0.0/unum.tar.gz"
  version "3.5-15.0.0"
  sha256 "7723433fc5eeda0e9ea01befde15d76523792177f2325980083c270fb62043ae"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://www.fourmilab.ch/webtools/unum/prior-releases/"
    regex(%r{href=["']?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/unum"
    sha256 cellar: :any_skip_relocation, mojave: "81439219eeb57ab4ea2ece284592bff4bba3a55be535a6302ccd8106f56caafd"
  end

  depends_on "pod2man" => :build

  uses_from_macos "perl"

  def install
    system "#{Formula["pod2man"].opt_bin}/pod2man", "unum.pl", "unum.1"
    bin.install "unum.pl" => "unum"
    man1.install "unum.1"
  end

  test do
    assert_match "LATIN SMALL LETTER X", shell_output("unum x").strip
  end
end
