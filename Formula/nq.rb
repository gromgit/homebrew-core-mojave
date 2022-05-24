class Nq < Formula
  desc "Unix command-line queue utility"
  homepage "https://github.com/leahneukirchen/nq"
  url "https://github.com/leahneukirchen/nq/archive/v0.5.tar.gz"
  sha256 "3f01aaf0b8eee4f5080ed1cd71887cb6485d366257d4cf5470878da2b734b030"
  license "CC0-1.0"
  head "https://github.com/leahneukirchen/nq.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nq"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "0b34346051fce2d862ae4d9ee8ddf2d007c5ac622e46e8c77b3b8a552d169ca4"
  end

  def install
    system "make", "all", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/nq", "touch", "TEST"
    assert_match "exited with status 0", shell_output("#{bin}/fq -a")
    assert_predicate testpath/"TEST", :exist?
  end
end
