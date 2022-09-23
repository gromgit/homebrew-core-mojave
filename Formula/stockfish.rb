class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://github.com/official-stockfish/Stockfish/archive/sf_15.tar.gz"
  sha256 "0553fe53ea57ce6641048049d1a17d4807db67eecd3531a3749401362a27c983"
  license "GPL-3.0-only"
  head "https://github.com/official-stockfish/Stockfish.git", branch: "master"

  livecheck do
    url :stable
    regex(/^sf[._-]v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stockfish"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "32d91351e5513e22f871d7b74c02462ff80de59d13dab270c2921aa452bac154"
  end

  fails_with gcc: "5" # For C++17

  def install
    arch = Hardware::CPU.arm? ? "apple-silicon" : "x86-64-modern"

    system "make", "-C", "src", "build", "ARCH=#{arch}"
    bin.install "src/stockfish"
  end

  test do
    system "#{bin}/stockfish", "go", "depth", "20"
  end
end
