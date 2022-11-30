class Truecrack < Formula
  desc "Brute-force password cracker for TrueCrypt"
  homepage "https://github.com/lvaccaro/truecrack"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/truecrack/truecrack_v35.tar.gz"
  version "3.5"
  sha256 "25bf270fa3bc3591c3d795e5a4b0842f6581f76c0b5d17c0aef260246fe726b3"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/truecrack"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "137785bc725fad295a2cfe458e462b04abe83d0fc9130b1958100dabf152a3f8"
  end

  # Fix missing return value compilation issue
  # https://github.com/lvaccaro/truecrack/issues/41
  patch do
    url "https://gist.githubusercontent.com/anonymous/b912a1ede06eb1e8eb38/raw/1394a8a6bedb7caae8ee034f512f76a99fe55976/truecrack-return-value-fix.patch"
    sha256 "8aa608054f9b822a1fb7294a5087410f347ba632bbd4b46002aada76c289ed77"
  end

  def install
    # Re datarootdir override: Dumps two files in top-level share
    # (autogen.sh and cudalt.py) which could cause conflict elsewhere.
    system "./configure", "--enable-cpu",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--datarootdir=#{pkgshare}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/truecrack"
  end
end
