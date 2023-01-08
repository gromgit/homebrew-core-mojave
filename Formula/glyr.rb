class Glyr < Formula
  desc "Music related metadata search engine with command-line interface and C API"
  homepage "https://github.com/sahib/glyr"
  url "https://github.com/sahib/glyr/archive/1.0.10.tar.gz"
  sha256 "77e8da60221c8d27612e4a36482069f26f8ed74a1b2768ebc373c8144ca806e8"
  license "LGPL-3.0-or-later"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/glyr"
    rebuild 1
    sha256 cellar: :any, mojave: "b6573b55f24fde0ec6c468c00701fa26d1b2388d09930d0df36df26f3804a0b1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    search = "--artist Beatles --title 'Eight Days A Week'"
    cmd = "#{bin}/glyrc lyrics --no-download #{search} -w stdout"
    assert_match "Love you all the time", pipe_output(cmd, nil, 0)
  end
end
