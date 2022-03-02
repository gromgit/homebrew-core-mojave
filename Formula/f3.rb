class F3 < Formula
  desc "Test various flash cards"
  homepage "https://fight-flash-fraud.readthedocs.io/en/latest/"
  url "https://github.com/AltraMayor/f3/archive/v8.0.tar.gz"
  sha256 "fb5e0f3b0e0b0bff2089a4ea6af53278804dfe0b87992499131445732e311ab4"
  license "GPL-3.0-only"
  head "https://github.com/AltraMayor/f3.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/f3"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "de5ef4775ab308e250184428fca65d8c3a3443d2a0ede7620f9b506dfc2b160d"
  end


  depends_on "argp-standalone"

  def install
    system "make", "all", "ARGP=#{Formula["argp-standalone"].opt_prefix}"
    bin.install %w[f3read f3write]
    man1.install "f3read.1"
    man1.install_symlink "f3read.1" => "f3write.1"
  end

  test do
    system "#{bin}/f3read", testpath
  end
end
