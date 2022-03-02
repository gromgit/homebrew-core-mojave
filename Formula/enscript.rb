class Enscript < Formula
  desc "Convert text to Postscript, HTML, or RTF, with syntax highlighting"
  homepage "https://www.gnu.org/software/enscript/"
  url "https://ftp.gnu.org/gnu/enscript/enscript-1.6.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/enscript/enscript-1.6.6.tar.gz"
  sha256 "6d56bada6934d055b34b6c90399aa85975e66457ac5bf513427ae7fc77f5c0bb"
  license "GPL-3.0-or-later"
  revision 1
  head "https://git.savannah.gnu.org/git/enscript.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/enscript"
    rebuild 1
    sha256 mojave: "6201d52a700c4dba18d94b4b052d7ac62905c53cd9c51a61d56a8ad4dabfb018"
  end


  depends_on "gettext"

  conflicts_with "cspice", because: "both install `states` binaries"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "GNU Enscript #{version}", shell_output("#{bin}/enscript -V")
  end
end
