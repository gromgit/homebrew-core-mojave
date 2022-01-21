class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.7.1.tar.gz"
  sha256 "e149236623c103c8526b1f872b4e630e67f15be98ac604c0ea0186054dbef0cc"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/aerc"
    sha256 cellar: :any_skip_relocation, mojave: "3af78434c4651742b7fdeeaeafa94ed3a12026f94ce61429c6ae311a2e22cf45"
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
