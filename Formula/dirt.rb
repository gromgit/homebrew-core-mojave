class Dirt < Formula
  desc "Experimental sample playback"
  homepage "https://github.com/tidalcycles/Dirt"
  url "https://github.com/tidalcycles/Dirt/archive/1.1.tar.gz"
  sha256 "bb1ae52311813d0ea3089bf3837592b885562518b4b44967ce88a24bc10802b6"
  license "GPL-3.0"
  revision 1
  head "https://github.com/tidalcycles/Dirt.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dirt"
    rebuild 1
    sha256 cellar: :any, mojave: "22367063616d78e88dd4ea8601594919629910bb584c83d53ebb251755535140"
  end


  depends_on "jack"
  depends_on "liblo"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/dirt --help; :")
  end
end
