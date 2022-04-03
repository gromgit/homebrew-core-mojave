class Hexedit < Formula
  desc "View and edit files in hexadecimal or ASCII"
  homepage "http://rigaux.org/hexedit.html"
  url "https://github.com/pixel/hexedit/archive/1.5.tar.gz"
  sha256 "27a2349f659e995d7731ad672450f61a2e950330049a6fb59b77490c5e0015ac"
  license "GPL-2.0-or-later"
  head "https://github.com/pixel/hexedit.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hexedit"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "713e354697e5900b8c09d2daa21a5b2264b753a18bf25ed9a5ddeb39cbae3cdb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "ncurses"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/hexedit -h 2>&1", 1)
  end
end
