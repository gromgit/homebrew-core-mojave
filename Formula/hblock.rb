class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://hblock.molinero.dev/"
  url "https://github.com/hectorm/hblock/archive/v3.3.1.tar.gz"
  sha256 "649ef980871d4be467a43edfa99c636b95b5af38ee976985082a65c4989eac01"
  license "MIT"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hblock"
    sha256 cellar: :any_skip_relocation, mojave: "8d80ae28ae37a10148f0f523752cf89445277580aca5a1590ed30d0b665dc305"
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
