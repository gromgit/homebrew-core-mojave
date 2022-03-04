class Dungeon < Formula
  desc "Classic text adventure game"
  homepage "https://github.com/GOFAI/dungeon"
  url "https://github.com/GOFAI/dungeon/archive/4.1.tar.gz"
  sha256 "b88c49ef60e908e8611257fbb5a6a41860e1058760df2dfcb7eb141eb34e198b"
  license "HPND"
  revision 2

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dungeon"
    rebuild 1
    sha256 cellar: :any, mojave: "26923944f2d95d65ea41b2afdc18251d1d9cd72788d4669922deada9b8259e8b"
  end

  depends_on "gcc" # for gfortran

  def install
    chdir "src" do
      # look for game files where homebrew installed them, not pwd
      inreplace "game.f" do |s|
        s.gsub! "FILE='dindx',STATUS='OLD',", "FILE='#{opt_pkgshare}/dindx',"
        s.gsub! "1\tFORM='FORMATTED',ACCESS='SEQUENTIAL',ERR=1900)", "1\tSTATUS='OLD',FORM='FORMATTED'," \
                                                                     "\n\t2\tACCESS='SEQUENTIAL',ERR=1900)"
        s.gsub! "FILE='dtext',STATUS='OLD',", "FILE='#{opt_pkgshare}/dtext',"
        s.gsub! "1\tFORM='UNFORMATTED',ACCESS='DIRECT',", "1\tSTATUS='OLD',FORM='UNFORMATTED',ACCESS='DIRECT',"
      end
      inreplace "Makefile" do |s|
        s.gsub! "gfortran -g", "gfortran -ffixed-line-length-none -g"
      end
      system "make"
      bin.install "dungeon"
    end
    pkgshare.install "dindx"
    pkgshare.install "dtext"
    man.install "dungeon.txt"
    man.install "hints.txt"
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/dungeon") do |stdin, stdout, _|
      stdin.close
      assert_match " Welcome to Dungeon.\t\t\t", stdout.read
    end
  end
end
