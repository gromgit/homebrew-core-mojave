class Ficy < Formula
  desc "Icecast/Shoutcast stream grabber suite"
  homepage "https://www.thregr.org/~wavexx/software/fIcy/"
  url "https://www.thregr.org/~wavexx/software/fIcy/releases/fIcy-1.0.21.tar.gz"
  sha256 "8564b16d3a52fa6dc286b02bfcc19e4acdc148c30f1750ca144e2ea47c84fd81"
  license "LGPL-2.1-only"
  head "https://gitlab.com/wavexx/fIcy.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?releases/fIcy[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ficy"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "2628b38a6f41ef4bbb9684b772d9fd9cd2c6f73111bc2b1bb44cb3b0297b0397"
  end


  def install
    system "make"
    bin.install "fIcy", "fPls", "fResync"
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    system "#{bin}/fResync", "-n", "1", "test.mp3"
  end
end
