class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-6.2.5.tar.gz"
  mirror "https://github.com/hashcat/hashcat/archive/v6.2.5.tar.gz"
  sha256 "6f6899d7ad899659f7b43a4d68098543ab546d2171f8e51d691d08a659378969"
  license "MIT"
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?hashcat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hashcat"
    rebuild 4
    sha256 mojave: "3bdf4d2c2bb7d1001eb859ebd7bb81dca487564867a8965658b4744117e43a7e"
  end

  depends_on "gnu-sed" => :build

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath
    ENV["XDG_CACHE_HOME"] = testpath
    cp_r pkgshare.children, testpath
    cp bin/"hashcat", testpath
    system testpath/"hashcat --benchmark -m 0 -D 1,2 -w 2"
  end
end
