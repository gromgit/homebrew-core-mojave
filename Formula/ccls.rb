class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20210330.tar.gz"
  sha256 "28c228f49dfc0f23cb5d581b7de35792648f32c39f4ca35f68ff8c9cb5ce56c2"
  license "Apache-2.0"
  revision 5
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ccls"
    sha256 mojave: "c173c20f5fd1e817b4c8bbcfb060f2e53df49788437004d776014638df572209"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm@13"
  depends_on macos: :high_sierra # C++ 17 is required

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    resource_dir = Utils.safe_popen_read(Formula["llvm@13"].bin/"clang", "-print-resource-dir").chomp
    resource_dir.gsub! Formula["llvm@13"].prefix.realpath, Formula["llvm@13"].opt_prefix
    system "cmake", *std_cmake_args, "-DCLANG_RESOURCE_DIR=#{resource_dir}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/ccls -index=#{testpath} 2>&1")

    resource_dir = output.match(/resource-dir=(\S+)/)[1]
    assert_path_exists "#{resource_dir}/include"
  end
end
