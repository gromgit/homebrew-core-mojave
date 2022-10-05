class Sox < Formula
  desc "SOund eXchange: universal sound sample translator"
  homepage "https://sox.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz"
  sha256 "b45f598643ffbd8e363ff24d61166ccec4836fea6d3888881b8df53e3bb55f6c"
  revision 4

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sox"
    sha256 cellar: :any, mojave: "13e62bfff93cc8d310114131ce08022a74bbe402e921ca5a640fa8516210b60b"
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "opusfile"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    input = testpath/"test.wav"
    output = testpath/"concatenated.wav"
    cp test_fixtures("test.wav"), input
    system bin/"sox", input, input, output
    assert_predicate output, :exist?
  end
end
