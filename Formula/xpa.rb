class Xpa < Formula
  desc "Seamless communication between Unix programs"
  homepage "https://hea-www.harvard.edu/RD/xpa/"
  url "https://github.com/ericmandel/xpa/archive/2.1.20.tar.gz"
  sha256 "854af367c0f4ffe7a65cb4da854a624e20af3c529f88187b50b22b68f024786a"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xpa"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "77c5d1bab2b1d02c3634ac1136168c6f11465dd55adab7318719bb70c4fbcb7d"
  end

  depends_on "libxt" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # relocate man, since --mandir is ignored
    mv "#{prefix}/man", man
  end
end
