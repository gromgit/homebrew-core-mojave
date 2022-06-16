class Imageworsener < Formula
  desc "Utility and library for image scaling and processing"
  homepage "https://entropymine.com/imageworsener/"
  license "MIT"
  revision 1

  stable do
    url "https://entropymine.com/imageworsener/imageworsener-1.3.4.tar.gz"
    sha256 "bae0b2bb35e565133dd804a6f4af303992527f53068cd67b03e5d9961d8512b6"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?imageworsener[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/imageworsener"
    sha256 cellar: :any, mojave: "7406c5fca92bc9394269a35b087cafc067250b16feed167687e0a36db980183f"
  end

  head do
    url "https://github.com/jsummers/imageworsener.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "zlib"

  def install
    if build.head?
      inreplace "./scripts/autogen.sh", "libtoolize", "glibtoolize"
      system "./scripts/autogen.sh"
    end

    system "./configure", *std_configure_args, "--without-webp"
    system "make", "install"
    pkgshare.install "tests"
  end

  test do
    cp_r Dir["#{pkgshare}/tests/*"], testpath
    system "./runtest", bin/"imagew"
  end
end
