class Csvprintf < Formula
  desc "Command-line utility for parsing CSV files"
  homepage "https://github.com/archiecobbs/csvprintf"
  url "https://github.com/archiecobbs/csvprintf/archive/1.3.0.tar.gz"
  sha256 "f15737526f0505f0a26dbdd7799f7f3acc950001c64b18a5b233b8b0fd301b0c"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/csvprintf"
    sha256 cellar: :any_skip_relocation, mojave: "eb9177ef3e10174db33500bb213e479e03257f42fe2c07eb087bf4843c85df17"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libxslt"

  # Fix for missing 'u_char', remove in next version
  patch do
    url "https://github.com/archiecobbs/csvprintf/commit/c8798ed8.patch?full_index=1"
    sha256 "94142117ec45922d8f6aa001ef17421e76600f761689e096015448fd3424f301"
  end

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "Fred Smith\n",
                 pipe_output("#{bin}/csvprintf -i '%2$s %1$s\n'", "Last,First\nSmith,Fred\n")
  end
end
