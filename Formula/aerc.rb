class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.7.1.tar.gz"
  sha256 "e149236623c103c8526b1f872b4e630e67f15be98ac604c0ea0186054dbef0cc"
  license "MIT"
  revision 1
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/aerc"
    sha256 mojave: "24ed5208b6716645289a1bc7c3f02d037639677c655a65e0155191a876bf8328"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "SHAREDIR=#{opt_pkgshare}", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end
