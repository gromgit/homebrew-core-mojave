class Pacman4console < Formula
  desc "Pacman for console"
  homepage "https://sites.google.com/site/doctormike/pacman.html"
  url "https://ftp.debian.org/debian/pool/main/p/pacman4console/pacman4console_1.3.orig.tar.gz"
  sha256 "9a5c4a96395ce4a3b26a9896343a2cdf488182da1b96374a13bf5d811679eb90"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76baeb05e81f233319586317c30e30807fa417e99497c16bb1004c2d193c74ea"
    sha256                               arm64_big_sur:  "b9f6328a3b683121a3ef8cfb48d6db7c6a25ba07f73a006430298ca7fc5bf658"
    sha256 cellar: :any_skip_relocation, monterey:       "8d9c58bcd4cedd42b28812ca3e4f1f4afd3fa4684bf7bb390f640567be8d7c97"
    sha256                               big_sur:        "299dbf7613b12c270c398dc9aa3255eb5f987331c4a1ace1f1ef811bb6070514"
    sha256                               catalina:       "6fdf8244cec5bb8ab55eefb1be9dc8f034c31ddbb3b39b21cd83f535e4e1a500"
    sha256                               mojave:         "ea3959a6317d2a3cfdb317622dafa97be5763b13509e06c7c0199eda4e349d33"
    sha256                               high_sierra:    "8b75a7198742924ea2e7545c4ed98dac3d28dcdc9469ff097666b0249a8ff2f7"
    sha256                               sierra:         "496938f00189695a57af2ef862b97c237d8bcf4c422b8e1d24c309cb8e83d0cd"
    sha256                               el_capitan:     "713a6a48016edcd709c27f84c5e743a0f95f95a3d01da7303a2562b2f3dee68d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a75b6bd17159e6e36dff479cb8b4f72cd20b4b84b0e76a619a1e07a1649c7a23"
  end

  # The Google Sites website is no longer available.
  deprecate! date: "2021-10-23", because: :unmaintained

  uses_from_macos "ncurses"

  def install
    system "make", "prefix=#{prefix}", "datarootdir=#{pkgshare}"
    bin.install ["pacman", "pacmanedit"]
    (pkgshare+"pacman").install "Levels"
  end
end
