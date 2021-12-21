class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://snapraid.sourceforge.io/"
  url "https://github.com/amadvance/snapraid/releases/download/v12.0/snapraid-12.0.tar.gz"
  sha256 "f07652261e9821a5adfbfa8dad3350aae3e7c285f42a6bd7d96a854e5bc56dda"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/snapraid"
    sha256 cellar: :any_skip_relocation, mojave: "cbcb5ee0038df3ef80cf685ebf27085772999e3babcd13e37cfa807db0e97f48"
  end

  head do
    url "https://github.com/amadvance/snapraid.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
