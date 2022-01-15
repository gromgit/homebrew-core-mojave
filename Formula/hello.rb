class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftp.gnu.org/gnu/hello/hello-2.11.tar.gz"
  sha256 "8c9ce0572d3c44ed0670eb1cde980584e038b6f62c25fdfde8ef128de15004bd"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hello"
    sha256 mojave: "f9ab50395d9cd57d31f441a6264263d584e4d1da63bbeaee74d9d8783599c395"
  end

  conflicts_with "perkeep", because: "both install `hello` binaries"

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    assert_equal "brew", shell_output("#{bin}/hello --greeting=brew").chomp
  end
end
