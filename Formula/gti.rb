class Gti < Formula
  desc "ASCII-art displaying typo-corrector for commands"
  homepage "https://r-wos.org/hacks/gti"
  url "https://github.com/rwos/gti/archive/v1.7.0.tar.gz"
  sha256 "cea8baf25ac5e6272f9031bd5e36a17a4b55038830b108f4f24e7f55690198f7"
  head "https://github.com/rwos/gti.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gti"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "cd9e841cffbab4d5603732a80f7a8b79ad266ef8e2ae0afef2addbfad3d36d56"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "gti"
    man6.install "gti.6"
  end

  test do
    system "#{bin}/gti", "init"
  end
end
