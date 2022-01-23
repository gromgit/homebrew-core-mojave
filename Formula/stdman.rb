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
    sha256 cellar: :any_skip_relocation, mojave: "4aaf0feb8cc42f571b96c6d84b991a993a3007a419c449a4bb1d9d3436ffcb89"
  end

  on_linux do
    depends_on "man-db" => :test
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "man", "-w", "std::string"
  end
end
