class Boxes < Formula
  desc "Draw boxes around text"
  homepage "https://boxes.thomasjensen.com/"
  url "https://github.com/ascii-boxes/boxes/archive/v2.2.0.tar.gz"
  sha256 "98b8e3cf5008f46f096d5775d129c34db9f718728bffb0f5d67ae89bb494102e"
  license "GPL-3.0-only"
  head "https://github.com/ascii-boxes/boxes.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/boxes"
    sha256 mojave: "218d36a4bbad3cf3528c1e3b26cda45fa7e20893098561049c5fa863c8eaaa13"
  end

  depends_on "bison" => :build
  depends_on "libunistring"
  depends_on "pcre2"

  uses_from_macos "flex" => :build

  def install
    # distro uses /usr/share/boxes change to prefix
    system "make", "GLOBALCONF=#{share}/boxes-config",
                   "CC=#{ENV.cc}",
                   "YACC=#{Formula["bison"].opt_bin/"bison"}"

    bin.install "out/boxes"
    man1.install "doc/boxes.1"
    share.install "boxes-config"
  end

  test do
    assert_match "test brew", pipe_output("#{bin}/boxes", "test brew")
  end
end
