class Apophenia < Formula
  desc "C library for statistical and scientific computing"
  homepage "http://apophenia.info"
  url "https://github.com/b-k/apophenia/archive/refs/tags/v1.0.tar.gz"
  sha256 "c753047a9230f9d9e105541f671c4961dc7998f4402972424e591404f33b82ca"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/apophenia"
    sha256 cellar: :any, mojave: "68061005567239d6b0f2aa8a71fd5e055342f31541f777086c3fec9b18bef6de"
  end

  depends_on "gsl"

  uses_from_macos "sqlite"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    # Regenerate configure to avoid binaries being built with flat namespace
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?

    args = std_configure_args - ["--disable-debug"]
    system "./configure", *args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"foo.csv").write <<~EOS
      thud,bump
      1,2
      3,4
      5,6
      7,8
    EOS

    expected_gnuplot_output = <<~EOS
      plot '-' with lines
          1\t    2
          3\t    4
          5\t    6
          7\t    8
    EOS

    system bin/"apop_text_to_db", testpath/"foo.csv", "bar", testpath/"baz.db"
    sqlite_output = shell_output("sqlite3 baz.db '.mode csv' '.headers on' 'select * from bar'")
    assert_equal (testpath/"foo.csv").read, sqlite_output.gsub(/\r\n?/, "\n")

    query_output = shell_output("#{bin}/apop_plot_query -d #{testpath/"baz.db"} -q 'select thud,bump from bar' -f-")
    assert_equal query_output, expected_gnuplot_output
  end
end
