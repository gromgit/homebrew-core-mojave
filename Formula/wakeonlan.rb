class Wakeonlan < Formula
  desc "Sends magic packets to wake up network-devices"
  homepage "https://github.com/jpoliv/wakeonlan"
  url "https://github.com/jpoliv/wakeonlan/archive/v0.42.tar.gz"
  sha256 "4f533f109f7f4294f6452b73227e2ce4d2aa81091cf6ae1f4fa2f87bad04a031"
  license "Artistic-1.0-Perl"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wakeonlan"
    sha256 cellar: :any_skip_relocation, mojave: "a54812034696435a392dd80980cd74b56c8dc2bc30a5d001b679637a00ce6b8e"
  end

  uses_from_macos "perl"

  def install
    system "perl", "Makefile.PL"
    system "make"
    bin.install "blib/script/wakeonlan"
    man1.install "blib/man1/wakeonlan.1"
  end

  test do
    system "#{bin}/wakeonlan", "--version"
  end
end
