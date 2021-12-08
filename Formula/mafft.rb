class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://mafft.cbrc.jp/alignment/software/mafft-7.490-with-extensions-src.tgz"
  sha256 "d6eef33d8b9e282e20f9b25b6b6fb2757b9b6900e397ca621d56da86d9976541"

  # The regex below is intended to avoid releases with trailing "Experimental"
  # text after the link for the archive.
  livecheck do
    url "https://mafft.cbrc.jp/alignment/software/source.html"
    regex(%r{href=.*?mafft[._-]v?(\d+(?:\.\d+)+)-with-extensions-src\.t.+?</a>\s*?<(?:br[^>]*?|/li|/ul)>}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mafft"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "ce7cb5cea7ce65f0f0aae2aeedfcb9be296d57535f9eba0a2cc24f1d9c0c6ec7"
  end

  def install
    make_args = %W[CC=#{ENV.cc} CXX=#{ENV.cxx} PREFIX=#{prefix} install]
    system "make", "-C", "core", *make_args
    system "make", "-C", "extensions", *make_args
  end

  test do
    (testpath/"test.fa").write ">1\nA\n>2\nA"
    output = shell_output("#{bin}/mafft test.fa")
    assert_match ">1\na\n>2\na", output
  end
end
