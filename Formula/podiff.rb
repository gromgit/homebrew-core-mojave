class Podiff < Formula
  desc "Compare textual information in two PO files"
  homepage "https://puszcza.gnu.org.ua/software/podiff/"
  url "https://download.gnu.org.ua/pub/release/podiff/podiff-1.4.tar.gz"
  sha256 "231531f3b0b17615a1f0ca9d712a3c196686df9f1a641688c74a2574af78b22a"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.gnu.org.ua/pub/release/podiff/"
    regex(/href=.*?podiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/podiff"
    sha256 cellar: :any_skip_relocation, mojave: "88e1a0ccd4e0ebcd4c3320fbda3085e5fef4d0675555625abbaca3387d71c754"
  end

  def install
    system "make"
    bin.install "podiff"
    man1.install "podiff.1"
  end

  def caveats
    <<~EOS
      To use with git, add this to your .git/config or global git config file:

        [diff "podiff"]
        command = #{HOMEBREW_PREFIX}/bin/podiff -D-u

      Then add the following line to the .gitattributes file in
      the directory with your PO files:

        *.po diff=podiff

      See `man podiff` for more information.
    EOS
  end

  test do
    system "#{bin}/podiff", "-v"
  end
end
