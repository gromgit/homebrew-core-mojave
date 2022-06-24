class Analog < Formula
  desc "Logfile analyzer"
  homepage "https://www.c-amie.co.uk/software/analog/"
  url "https://github.com/c-amie/analog-ce/archive/refs/tags/6.0.17.tar.gz"
  sha256 "0e5794c2eaa5826dc014916e413e90eb2714a646ff8d6ec026437182d789b117"
  head "https://github.com/c-amie/analog-ce.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/analog"
    sha256 mojave: "ff008121307b29d3f517be7c859c1b2750508d32fa554be8953be309b50bb8a3"
  end

  depends_on "gd"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "pcre"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = [
      "CC=#{ENV.cc}",
      "CFLAGS=#{ENV.cflags}",
      %Q(DEFS='-DLANGDIR="#{pkgshare}/lang/"' -DHAVE_GD -DHAVE_ZLIB -DHAVE_BZLIB -DHAVE_PCRE),
      "LIBS=-lgd -lpng -ljpeg -lz -lbz2 -lpcre -lm",
      "OS=#{OS.mac? ? "OSX" : "UNIX"}",
    ]
    system "make", *args

    bin.install "analog"
    pkgshare.install "examples", "how-to", "images", "lang"
    pkgshare.install "analog.cfg-sample"
    (pkgshare/"examples").install "logfile.log"
    man1.install "analog.man" => "analog.1"
  end

  test do
    output = pipe_output("#{bin}/analog #{pkgshare}/examples/logfile.log")
    assert_match "(United Kingdom)", output
  end
end
