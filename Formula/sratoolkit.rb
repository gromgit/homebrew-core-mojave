class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]

  stable do
    url "https://github.com/ncbi/sra-tools/archive/refs/tags/3.0.3.tar.gz"
    sha256 "ea4b9a4b2e6e40e6b2bf36b01eb8df2b50280ef9dcdc66b504c1d1296600afbd"

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb/archive/refs/tags/3.0.2.tar.gz"
      sha256 "275ccb225ddb156688c8c71f772f73276cb18ebff773a51150f86f8002ed2d59"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9fac24d57962e0b711e915e3603f1fe9e74035ee24ce8fb66a6019ba0cfc39d7"
    sha256 cellar: :any,                 arm64_monterey: "f3b3de271cc0f04ff40c25d405ede0cafa9b045bcbb5cbf09f9a923b6bb0db95"
    sha256 cellar: :any,                 arm64_big_sur:  "b10a2b505112c1770814aba5a346019cdef789ee4c17ba13e45de006f61c54da"
    sha256 cellar: :any,                 ventura:        "5d643b579db1c5487c23f4091e6603f5d6b3b41b6f082dca9083215d69adc6f3"
    sha256 cellar: :any,                 monterey:       "5ffe635f09dd6398aebfc5a5a1af23f3022b70892bd809ba4b94fc7f738a3de5"
    sha256 cellar: :any,                 big_sur:        "431ccf7fabaeddaffb398447b7d54bf79300d879a6b6cd8e415b35f90f0af501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f469089c23a834c41f7bd865a76651648f2c54688f9262da72a075b61fd247be"
  end

  head do
    url "https://github.com/ncbi/sra-tools.git", branch: "master"

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on macos: :catalina

  uses_from_macos "libxml2"

  def install
    (buildpath/"ncbi-vdb-source").install resource("ncbi-vdb")

    # Workaround to allow clang/aarch64 build to use the gcc/arm64 directory
    # Issue ref: https://github.com/ncbi/ncbi-vdb/issues/65
    ln_s "../gcc/arm64", buildpath/"ncbi-vdb-source/interfaces/cc/clang/arm64" if Hardware::CPU.arm?

    # Need to use HDF 1.10 API: error: too few arguments to function call, expected 5, have 4
    # herr_t h5e = H5Oget_info_by_name( self->hdf5_handle, buffer, &obj_info, H5P_DEFAULT );
    ENV.append_to_cflags "-DH5_USE_110_API"

    system "cmake", "-S", "ncbi-vdb-source", "-B", "ncbi-vdb-build", *std_cmake_args,
                    "-DNGS_INCDIR=#{buildpath}/ngs/ngs-sdk"
    system "cmake", "--build", "ncbi-vdb-build"

    system "cmake", "-S", ".", "-B", "sra-tools-build", *std_cmake_args,
                    "-DVDB_BINDIR=#{buildpath}/ncbi-vdb-build",
                    "-DVDB_LIBDIR=#{buildpath}/ncbi-vdb-build/lib",
                    "-DVDB_INCDIR=#{buildpath}/ncbi-vdb-source/interfaces"
    system "cmake", "--build", "sra-tools-build"
    system "cmake", "--install", "sra-tools-build"

    # Remove non-executable files.
    (bin/"ncbi").rmtree
  end

  test do
    # For testing purposes, generate a sample config noninteractively in lieu of running vdb-config --interactive
    # See upstream issue: https://github.com/ncbi/sra-tools/issues/291
    require "securerandom"
    mkdir ".ncbi"
    (testpath/".ncbi/user-settings.mkfg").write "/LIBS/GUID = \"#{SecureRandom.uuid}\"\n"

    assert_match "Read 1 spots for SRR000001", shell_output("#{bin}/fastq-dump -N 1 -X 1 SRR000001")
    assert_match "@SRR000001.1 EM7LVYS02FOYNU length=284", File.read("SRR000001.fastq")
  end
end
