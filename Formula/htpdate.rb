class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "https://www.vervest.org/htp/"
  url "https://www.vervest.org/htp/archive/c/htpdate-1.2.3.tar.xz"
  sha256 "6b4e3fbf93d552a3a20f30a3906bf0caac05d9626bd508220744010fe9dd53f0"

  livecheck do
    url "https://www.vervest.org/htp/?download"
    regex(/href=.*?htpdate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/htpdate"
    sha256 cellar: :any_skip_relocation, mojave: "9e91e0ff30a4ed345d14a05a7527c0faf23bddc33f710f019838234fb3f42f2b"
  end

  depends_on macos: :high_sierra # needs <sys/timex.h>

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{bin}/htpdate", "-q", "-d", "-u", ENV["USER"], "example.org"
  end
end
