class Sha3sum < Formula
  desc "Keccak, SHA-3, SHAKE, and RawSHAKE checksum utilities"
  homepage "https://github.com/maandree/sha3sum"
  url "https://github.com/maandree/sha3sum/archive/1.2.2.tar.gz"
  sha256 "57cfda5d9d16aa14c78d278b1c14fd9f3504424ee62bc18137ce6435c1364d12"
  license "ISC"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sha3sum"
    sha256 cellar: :any, mojave: "11ff080f1d9b7bd646b8743562845ebc6b7b60f6873cfef8fe33c1bb8fee4a9d"
  end

  depends_on "libkeccak"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    inreplace "test", "./", "#{bin}/"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    system "./test"
  end
end
