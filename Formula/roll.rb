class Roll < Formula
  desc "CLI program for rolling a dice sequence"
  homepage "https://matteocorti.github.io/roll/"
  url "https://github.com/matteocorti/roll/releases/download/v2.6.1/roll-2.6.1.tar.gz"
  sha256 "399bd4958d92f82fb75ff308decb2d482c9a8db80234014f6d42f6513b144179"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/roll"
    sha256 cellar: :any_skip_relocation, mojave: "529dd0b7277a3ff57155727d3d68d2ecd3549be4627fe4bc20f6f06cadde6d5f"
  end

  head do
    url "https://github.com/matteocorti/roll.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./regen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/roll", "1d6"
  end
end
