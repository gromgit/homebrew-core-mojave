class Ssed < Formula
  desc "Super sed stream editor"
  homepage "https://sed.sourceforge.io/grabbag/ssed/"
  url "https://sed.sourceforge.io/grabbag/ssed/sed-3.62.tar.gz"
  sha256 "af7ff67e052efabf3fd07d967161c39db0480adc7c01f5100a1996fec60b8ec4"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?sed[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ssed"
    rebuild 3
    sha256 cellar: :any, mojave: "f8b65deea1150b305fd89ae322c00e599851290867c1440011329c698966e352"
  end

  conflicts_with "gnu-sed", because: "both install share/info/sed.info"

  def install
    # CFLAGS adjustment is needed to build on Xcode 12
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--program-prefix=s"
    system "make", "install"
  end

  test do
    assert_equal "homebrew",
      pipe_output("#{bin}/ssed s/neyd/mebr/", "honeydew", 0).chomp
  end
end
