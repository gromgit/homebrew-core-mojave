class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://podofo.sourceforge.io"
  url "https://downloads.sourceforge.net/project/podofo/podofo/0.9.8/podofo-0.9.8.tar.gz"
  sha256 "5de607e15f192b8ad90738300759d88dea0f5ccdce3bf00048a0c932bc645154"
  license all_of: ["LGPL-2.0-only", "GPL-2.0-only"]
  head "svn://svn.code.sf.net/p/podofo/code/podofo/trunk"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/podofo"
    sha256 cellar: :any, mojave: "29b99558fcbc5f01f017848bdc88fb27ad8aecd5a48779d79e80cc54c3e5a5f6"
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libidn"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@1.1"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_NAME_DIR=#{opt_lib}
      -DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_CppUnit=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_LUA=ON
      -DPODOFO_BUILD_SHARED:BOOL=ON
      -DFREETYPE_INCLUDE_DIR_FT2BUILD=#{Formula["freetype"].opt_include}/freetype2
      -DFREETYPE_INCLUDE_DIR_FTHEADER=#{Formula["freetype"].opt_include}/freetype2/config/
    ]
    # C++ standard settings may be implemented upstream in which case the below will not be necessary.
    # See https://sourceforge.net/p/podofo/tickets/121/
    args += %w[
      -DCMAKE_CXX_STANDARD=11
      -DCMAKE_CXX_STANDARD_REQUIRED=ON
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "500 x 800 pts", shell_output("#{bin}/podofopdfinfo test.pdf")
  end
end
