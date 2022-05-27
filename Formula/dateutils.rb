class Dateutils < Formula
  desc "Tools to manipulate dates with a focus on financial data"
  homepage "https://www.fresse.org/dateutils/"
  url "https://github.com/hroptatyr/dateutils/releases/download/v0.4.10/dateutils-0.4.10.tar.xz"
  sha256 "3c508e2889b9d5aecab7d59d7325a70089593111a1230a496dab0f5ad677cdec"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dateutils"
    sha256 mojave: "b7e5c749d52bd3a7b12abe5c5b9dea7495281accfaf86f8f29407253e1b59eca"
  end

  head do
    url "https://github.com/hroptatyr/dateutils.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/dconv 2012-03-04 -f \"%Y-%m-%c-%w\"").strip
    assert_equal "2012-03-01-07", output
  end
end
