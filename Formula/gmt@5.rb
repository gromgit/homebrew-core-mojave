class GmtAT5 < Formula
  desc "Tools for manipulating and plotting geographic and Cartesian data"
  homepage "https://www.generic-mapping-tools.org/"
  url "https://github.com/GenericMappingTools/gmt/releases/download/5.4.5/gmt-5.4.5-src.tar.gz"
  mirror "https://mirrors.ustc.edu.cn/gmt/gmt-5.4.5-src.tar.gz"
  mirror "https://fossies.org/linux/misc/GMT/gmt-5.4.5-src.tar.gz"
  sha256 "225629c7869e204d5f9f1a384c4ada43e243f83e1ed28bdca4f7c2896bf39ef6"
  license "LGPL-3.0-or-later"
  revision 12

  bottle do
    sha256 big_sur:  "f8d14f1c37b086a21aecf7ff3d744bfe5f3362af7c33de49890b77073c7227ef"
    sha256 catalina: "f13e7d03b2ff5961cd7d0ccc294880574c5cddcbfc50274d7a75f8cf4d9f01c9"
    sha256 mojave:   "d4af49c8a7680a26b9f7b344a7e9acdaa8cd2cfa320d9d04365308e2afb43765"
  end

  keg_only :versioned_formula

  deprecate! date: "2021-05-22", because: :unmaintained

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gdal"
  depends_on "netcdf"
  depends_on "pcre"

  resource "gshhg" do
    url "https://github.com/GenericMappingTools/gshhg-gmt/releases/download/2.3.7/gshhg-gmt-2.3.7.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/gshhg-gmt-2.3.7.tar.gz"
    mirror "https://fossies.org/linux/misc/GMT/gshhg-gmt-2.3.7.tar.gz"
    sha256 "9bb1a956fca0718c083bef842e625797535a00ce81f175df08b042c2a92cfe7f"
  end

  resource "dcw" do
    url "https://github.com/GenericMappingTools/dcw-gmt/releases/download/1.1.4/dcw-gmt-1.1.4.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/dcw-gmt-1.1.4.tar.gz"
    mirror "https://fossies.org/linux/misc/GMT/dcw-gmt-1.1.4.tar.gz"
    sha256 "8d47402abcd7f54a0f711365cd022e4eaea7da324edac83611ca035ea443aad3"
  end

  # netcdf 4.7.4 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/cdbf0de198531528db908a5d827f3d2e5b9618cc/gmt%405/netcdf-4.7.4.patch"
    sha256 "d894869830f6e57b0670dc31df6b5c684e079418f8bf5c0cd0f7014b65c1981f"
  end

  # This patch is required because of incorrect usage of the `date` command in
  # cmake/modules/ConfigCMake.cmake; this arises because SOURCE_DATE_EPOCH is
  # set for builds.
  patch :DATA

  def install
    (buildpath/"gshhg").install resource("gshhg")
    (buildpath/"dcw").install resource("dcw")

    args = std_cmake_args.concat %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DGMT_DOCDIR=#{share}/doc/gmt
      -DGMT_MANDIR=#{man}
      -DGSHHG_ROOT=#{buildpath}/gshhg
      -DCOPY_GSHHG:BOOL=TRUE
      -DDCW_ROOT=#{buildpath}/dcw
      -DCOPY_DCW:BOOL=TRUE
      -DFFTW3_ROOT=#{Formula["fftw"].opt_prefix}
      -DGDAL_ROOT=#{Formula["gdal"].opt_prefix}
      -DNETCDF_ROOT=#{Formula["netcdf"].opt_prefix}
      -DPCRE_ROOT=#{Formula["pcre"].opt_prefix}
      -DFLOCK:BOOL=TRUE
      -DGMT_INSTALL_MODULE_LINKS:BOOL=TRUE
      -DGMT_INSTALL_TRADITIONAL_FOLDERNAMES:BOOL=FALSE
      -DLICENSE_RESTRICTED:BOOL=FALSE
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      GMT needs Ghostscript for the 'psconvert' command to convert PostScript files
      to other formats. To use 'psconvert', please 'brew install ghostscript'.
    EOS
  end

  test do
    system "#{bin}/pscoast -R0/360/-70/70 -Jm1.2e-2i -Ba60f30/a30f15 -Dc -G240 -W1/0 -P > test.ps"
    assert_predicate testpath/"test.ps", :exist?
  end
end

__END__
diff --git a/cmake/modules/ConfigCMake.cmake b/cmake/modules/ConfigCMake.cmake
index 3579171..cbe75d6 100644
--- a/cmake/modules/ConfigCMake.cmake
+++ b/cmake/modules/ConfigCMake.cmake
@@ -79,7 +79,7 @@ set (GMT_LONG_VERSION_STRING "${GMT_PACKAGE_NAME} - ${GMT_PACKAGE_DESCRIPTION_SU
 # Get date
 if(DEFINED ENV{SOURCE_DATE_EPOCH})
 	EXECUTE_PROCESS(
-	  COMMAND "date" "-u" "-d" "@$ENV{SOURCE_DATE_EPOCH}" "+%Y;%m;%d;%B"
+	  COMMAND "date" "-u" "-j" "-f" "%s" "@$ENV{SOURCE_DATE_EPOCH}" "+%Y;%m;%d;%B"
 	  OUTPUT_VARIABLE _today
 	  OUTPUT_STRIP_TRAILING_WHITESPACE)
 else(DEFINED ENV{SOURCE_DATE_EPOCH})
