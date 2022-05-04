class Nedit < Formula
  desc "Fast, compact Motif/X11 plain text editor"
  homepage "https://sourceforge.net/projects/nedit/"
  url "https://downloads.sourceforge.net/project/nedit/nedit-source/nedit-5.7-src.tar.gz"
  sha256 "add9ac79ff973528ad36c86858238bac4f59896c27dbf285cbe6a4d425fca17a"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9ee06ab3c8df64e26b87d80ac63acfff12ce97286ce115f2fc8882b3e4c88605"
    sha256 cellar: :any,                 arm64_big_sur:  "e81454f55e5a3b396abe741f65a4a2600d18e93301385edd3481d8d55cee20c0"
    sha256 cellar: :any,                 monterey:       "97501b6d060c2da91ce81ff637fc9898e5f3696c0ca6005ea862d5cf3b9b59f6"
    sha256 cellar: :any,                 big_sur:        "d39ce752a03c79732c908a3cbe93df61f413a12126f764e7e1c3d71f4106f701"
    sha256 cellar: :any,                 catalina:       "c726811764a5d12465d4c11b273229482af935921df472f6d083a27e34b39b3f"
    sha256 cellar: :any,                 mojave:         "7e3760fcb4d5a78393094c94b0c97a4e9b73487eeca6510963f098ebaeddf281"
    sha256 cellar: :any,                 high_sierra:    "0f1ea26247cf5abe89ecc7038820b937ee20046fa44b504363604af4a7bbb093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd75a55df6025af2525c13fb2657d74632fac30c2d813eda1d07ae1eea146ffa"
  end

  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "openmotif"

  uses_from_macos "bison" => :build

  def install
    os = OS.mac? ? "macosx" : OS.kernel_name.downcase
    system "make", os, "MOTIFLINK='-lXm'"
    system "make", "-C", "doc", "man", "doc"

    bin.install "source/nedit"
    bin.install "source/nc" => "ncl"

    man1.install "doc/nedit.man" => "nedit.1x"
    man1.install "doc/nc.man" => "ncl.1x"
    (etc/"X11/app-defaults").install "doc/NEdit.ad" => "NEdit"
    doc.install Dir["doc/*"]
  end

  test do
    assert_match "Can't open display", shell_output("DISPLAY= #{bin}/nedit 2>&1", 1)
    assert_match "Can't open display", shell_output("DISPLAY= #{bin}/ncl 2>&1", 1)
  end
end
