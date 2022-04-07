class Rcs < Formula
  desc "GNU revision control system"
  homepage "https://www.gnu.org/software/rcs/"
  url "https://ftp.gnu.org/gnu/rcs/rcs-5.10.1.tar.lz"
  mirror "https://ftpmirror.gnu.org/rcs/rcs-5.10.1.tar.lz"
  sha256 "43ddfe10724a8b85e2468f6403b6000737186f01e60e0bd62fde69d842234cc5"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rcs"
    sha256 cellar: :any_skip_relocation, mojave: "e81f62e6bd058a3e84a42db0bc294ce4762814230d3959cf30a4d0e7bead7d47"
  end

  uses_from_macos "ed" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"merge", "--version"
  end
end
