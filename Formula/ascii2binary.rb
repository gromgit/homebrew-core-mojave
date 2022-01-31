class Ascii2binary < Formula
  desc "Converting Text to Binary and Back"
  homepage "https://billposer.org/Software/a2b.html"
  url "https://www.billposer.org/Software/Downloads/ascii2binary-2.14.tar.gz"
  sha256 "addc332b2bdc503de573bfc1876290cf976811aae28498a5c9b902a3c06835a9"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ascii2binary"
    sha256 cellar: :any, mojave: "67df361d2aeb6bd4fe6f48d19e6e78783087e38fd944d70a5c3343e738f01224"
  end

  depends_on "gettext"

  def install
    gettext = Formula["gettext"]
    ENV.append "CFLAGS", "-I#{gettext.include}"
    ENV.append "LDFLAGS", "-L#{gettext.lib}"
    ENV.append "LDFLAGS", "-lintl" if OS.mac?

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-debug",
                          "--disable-dependency-tracking"

    system "make", "install"
    man1.install "ascii2binary.1", "binary2ascii.1"
  end

  test do
    binary = pipe_output("#{bin}/ascii2binary -t ui", "42")
    ascii = pipe_output("#{bin}/binary2ascii -t ui", binary).strip
    assert_equal "42", ascii
  end
end
