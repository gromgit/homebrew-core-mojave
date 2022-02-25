class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.8.2.tar.gz"
  sha256 "1a35db08b90c35df7c211119a8d064500999dfe2e419ed5b753007f8f7382912"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/aerc"
    sha256 cellar: :any_skip_relocation, mojave: "b77ef037fd1a946d6a9fffb038b244715c24f10c3edb4db866ad0541833f24a7"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end
