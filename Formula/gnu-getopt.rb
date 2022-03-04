class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.37/util-linux-2.37.4.tar.xz"
  sha256 "634e6916ad913366c3536b6468e7844769549b99a7b2bf80314de78ab5655b83"
  license "GPL-2.0-or-later"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gnu-getopt"
    rebuild 1
    sha256 cellar: :any, mojave: "241a4eaeb075e6c139c35733e645fda0bd0142efafcc1615deccf3ef2da8f102"
  end

  keg_only :provided_by_macos

  depends_on "asciidoctor" => :build

  on_linux do
    keg_only "conflicts with util-linux"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt", "misc-utils/getopt.1"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
