class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.8.2.tar.gz"
  sha256 "1a35db08b90c35df7c211119a8d064500999dfe2e419ed5b753007f8f7382912"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/aerc"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "88d104e1afb4c3f8049959b7fcb331ac2c711585968a5c2155c106ea3ff7c8d9"
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
