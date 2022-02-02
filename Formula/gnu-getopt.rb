class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.37/util-linux-2.37.3.tar.xz"
  sha256 "590c592e58cd6bf38519cb467af05ce6a1ab18040e3e3418f24bcfb2f55f9776"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gnu-getopt"
    sha256 cellar: :any, mojave: "85fadd045a349eb382c45d148f7956cceffa20a7267e5396825bca3ca7529829"
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
