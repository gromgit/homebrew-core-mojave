class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://hblock.molinero.dev/"
  url "https://github.com/hectorm/hblock/archive/v3.4.0.tar.gz"
  sha256 "762dbe5f2a0ea84078b194190f4fb51b9fe3e6ef043c1899fdda6a083328225f"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hblock"
    sha256 cellar: :any_skip_relocation, mojave: "9f1a12561e4c1d6a5c2fc4bc4178b4f9d49382ae2ab33e5e283264ecf3ee7ac8"
  end

  uses_from_macos "curl"

  def install
    system "make", "install", "prefix=#{prefix}", "bindir=#{bin}", "mandir=#{man}"
  end

  test do
    output = shell_output("#{bin}/hblock -H none -F none -S none -A none -D none -qO-")
    assert_match "Blocked domains:", output
  end
end
