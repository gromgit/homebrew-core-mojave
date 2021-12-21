class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.23.01.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.23.01.tar.gz"
  sha256 "816c5204b9a0ee9ba88515a98af398fffd3f46fc8791943a1ff38d473055ba6d"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tcsh"
    sha256 mojave: "732443c68c68b83a844afb1aecea65ac3ff7f8ec717ea85ad6bde21ede66b018"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
    bin.install_symlink "tcsh" => "csh"
  end

  test do
    (testpath/"test.csh").write <<~EOS
      #!#{bin}/tcsh -f
      set ARRAY=( "t" "e" "s" "t" )
      foreach i ( `seq $#ARRAY` )
        echo -n $ARRAY[$i]
      end
    EOS
    assert_equal "test", shell_output("#{bin}/tcsh ./test.csh")
  end
end
