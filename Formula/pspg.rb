class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.5.1.tar.gz"
  sha256 "a4a4003982017261360bae24d5b38b3653d694d3d66140cf8fe7864d50958a8e"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pspg"
    rebuild 2
    sha256 cellar: :any, mojave: "643af862918dcd943535fe3bfa6e99bb568f6f0b0cfdc3a35d9b012e943006c4"
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end
