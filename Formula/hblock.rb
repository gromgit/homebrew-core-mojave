class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://hblock.molinero.dev/"
  url "https://github.com/hectorm/hblock/archive/v3.3.2.tar.gz"
  sha256 "35bd4af1dbae3b57de6cede6c05f3d4ce25227b33a53358ef47c76a491304eb0"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hblock"
    sha256 cellar: :any_skip_relocation, mojave: "b408e7de0b8d0d3634deac27adcf630e303dcf03eee853a16af4b8b9d2f75714"
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
