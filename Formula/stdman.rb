class Stdman < Formula
  desc "Formatted C++ stdlib man pages from cppreference.com"
  homepage "https://github.com/jeaye/stdman"
  url "https://github.com/jeaye/stdman/archive/2021.12.21.tar.gz"
  sha256 "5cfea407f0cd6da0c66396814cafc57504e90df518b7c9fa3748edd5cfdd08e3"
  license "MIT"
  version_scheme 1
  head "https://github.com/jeaye/stdman.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stdman"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "020351e0f4461d8ce16a8695939016aa506cc4ff3c925d6c3b77b3d2ddbf1b57"
  end

  on_linux do
    depends_on "man-db" => :test
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    man = OS.mac? ? "man" : "gman"
    system man, "-w", "std::string"
  end
end
