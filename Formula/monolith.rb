class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.6.2.tar.gz"
  sha256 "15287b101b021f17cba13ca0b64c58a8be54bb061ba4b7c291eb57faf799977b"
  license "CC0-1.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/monolith"
    sha256 cellar: :any_skip_relocation, mojave: "cb64b62d54c6d66068889378a07dc68b2bfc6caf97a3b5bf400d981970e9682a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/P/Portishead/Dummy/Roads/"
  end
end
