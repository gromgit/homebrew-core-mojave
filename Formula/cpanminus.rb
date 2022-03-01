class Cpanminus < Formula
  desc "Get, unpack, build, and install modules from CPAN"
  homepage "https://github.com/miyagawa/cpanminus"
  url "https://github.com/miyagawa/cpanminus/archive/1.9019.tar.gz"
  sha256 "d0a37547a3c4b6dbd3806e194cd6cf4632158ebed44d740ac023e0739538fb46"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/miyagawa/cpanminus.git", branch: "devel"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cpanminus"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "3441a262c18df83c13a619b171e16b227fee2d7b6c8d4fb5928e6724218211ac"
  end


  def install
    cd "App-cpanminus" do
      bin.install "cpanm"
    end
  end

  test do
    system "#{bin}/cpanm", "Test::More"
  end
end
