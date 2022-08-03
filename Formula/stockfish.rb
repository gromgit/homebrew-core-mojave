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

  # Linux bottle removed for GCC 12 migration
  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stockfish"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "df56e7c1d12474f56ee321f0a29fbf0549bc684ac86818ecfc3d427052db06d4"
  end

  fails_with gcc: "5"

  def install
    arch = Hardware::CPU.arm? ? "apple-silicon" : "x86-64-modern"

    system "make", "-C", "src", "build", "ARCH=#{arch}"
    bin.install "src/stockfish"
  end

  test do
    system "#{bin}/stockfish", "go", "depth", "20"
  end
end
