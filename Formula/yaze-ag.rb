class YazeAg < Formula
  desc "Yet Another Z80 Emulator (by AG)"
  homepage "https://www.mathematik.uni-ulm.de/users/ag/yaze-ag/"
  url "https://www.mathematik.uni-ulm.de/users/ag/yaze-ag/devel/yaze-ag-2.51.3.tar.gz"
  sha256 "2b0a90c3bf3a27574b0427cf4579dc2347b371bec3fea5739e1527edf74b2809"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?yaze-ag[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/yaze-ag"
    sha256 mojave: "7524822fc7e4ad2d2e184c77380b0a040bac9b12b5b50fbf7e560a67de54dde8"
  end

  def install
    if OS.mac?
      inreplace "Makefile_solaris_gcc-x86_64", "md5sum -b", "md5"
      inreplace "Makefile_solaris_gcc-x86_64", /(LIBS\s+=\s+-lrt)/, '#\1'
    end

    bin.mkpath
    system "make", "-f", "Makefile_solaris_gcc-x86_64",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "LIBDIR=#{lib}/yaze",
                   "install"
  end

  test do
    (testpath/"cpm").mkpath
    assert_match "yazerc", shell_output("#{bin}/yaze -v", 1)
  end
end
