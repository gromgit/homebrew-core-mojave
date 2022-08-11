class Libmng < Formula
  desc "MNG/JNG reference library"
  # Use Homebrew curl to work around audit failure from TLS 1.3-only homepage.
  # TODO: The `using: :homebrew_curl` can be removed once default curl on all
  # CI runners support TLS 1.3 or if there is a way to skip homepage audit in CI.
  homepage "https://libmng.com/"
  url "https://downloads.sourceforge.net/project/libmng/libmng-devel/2.0.3/libmng-2.0.3.tar.gz", using: :homebrew_curl
  sha256 "cf112a1fb02f5b1c0fce5cab11ea8243852c139e669c44014125874b14b7dfaa"
  license "Zlib"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libmng"
    sha256 cellar: :any, mojave: "3d490f8da62691dc585f99c7cd42d8bc06dc71bacf5c17ee3f9fa4649703100a"
  end

  depends_on "jpeg-turbo"
  depends_on "little-cms2"

  uses_from_macos "zlib"

  resource "sample" do
    url "https://telparia.com/fileFormatSamples/image/mng/abydos.mng"
    sha256 "4819310da1bbee591957185f55983798a0f8631c32c72b6029213c67071caf8d"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"

    # Keep an example for test purposes, but fix header location to use system-level includes
    inreplace "contrib/gcc/mngtree/mngtree.c", "\"../../../libmng.h\"", "<libmng.h>"
    pkgshare.install "contrib/gcc/mngtree/mngtree.c"
  end

  test do
    system ENV.cc, pkgshare/"mngtree.c", "-DMNG_USE_SO",
           "-I#{Formula["jpeg-turbo"].opt_include}",
           "-I#{include}", "-L#{lib}", "-lmng", "-o", "mngtree"

    resource("sample").stage do
      output = shell_output("#{testpath}/mngtree abydos.mng")
      assert_match "Starting dump of abydos.mng.", output
      assert_match "Done.", output
    end
  end
end
