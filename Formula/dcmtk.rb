class Dcmtk < Formula
  desc "OFFIS DICOM toolkit command-line utilities"
  homepage "https://dicom.offis.de/dcmtk.php.en"
  url "https://dicom.offis.de/download/dcmtk/dcmtk366/dcmtk-3.6.6.tar.gz"
  sha256 "6859c62b290ee55677093cccfd6029c04186d91cf99c7642ae43627387f3458e"
  head "https://git.dcmtk.org/dcmtk.git", branch: "master"

  livecheck do
    url "https://dicom.offis.de/download/dcmtk/release/"
    regex(/href=.*?dcmtk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dcmtk"
    rebuild 1
    sha256 mojave: "e765684abfa76fa8adaab5716a4145b3b6f71e08b4877697a05e03de67b9beed"
  end


  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"

  def install
    mkdir "build" do
      system "cmake", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args, ".."
      system "make", "install"
      system "cmake", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args, ".."
      system "make", "install"

      inreplace lib/"cmake/dcmtk/DCMTKConfig.cmake", Superenv.shims_path, ""
    end
  end

  test do
    system bin/"pdf2dcm", "--verbose",
           test_fixtures("test.pdf"), testpath/"out.dcm"
    system bin/"dcmftest", testpath/"out.dcm"
  end
end
