class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  url "https://dicom.offis.de/download/dcmtk/dcmtk367/dcmtk-3.6.7.tar.gz"
  sha256 "7c58298e3e8d60232ee6fc8408cfadd14463cc11a3c4ca4c59af5988c7e9710a"
  head "https://git.dcmtk.org/dcmtk.git", branch: "master"

  livecheck do
    url "https://dicom.offis.de/download/dcmtk/release/"
    regex(/href=.*?dcmtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dcmtk"
    sha256 mojave: "62a28a81ce7a235db59586f2908351e65cb833846870e8eccfd3f0320b03c476"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@3"

  uses_from_macos "libxml2"

  def install
    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    lib.install Dir["build/static/lib/*.a"]

    inreplace lib/"cmake/dcmtk/DCMTKConfig.cmake", "#{Superenv.shims_path}/", ""
  end

  test do
    system bin/"pdf2dcm", "--verbose",
           test_fixtures("test.pdf"), testpath/"out.dcm"
    system bin/"dcmftest", testpath/"out.dcm"
  end
end
