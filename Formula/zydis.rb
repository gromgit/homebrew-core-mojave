class Zydis < Formula
  desc "Fast and lightweight x86/x86_64 disassembler library"
  homepage "https://zydis.re"
  license "MIT"
  head "https://github.com/zyantific/zydis.git", branch: "master"

  stable do
    url "https://github.com/zyantific/zydis.git",
        tag:      "v3.2.1",
        revision: "4022f22f9280650082a9480519c86a6e2afde2f3"

    # Fix build on ARM Monterey. Remove in the next release.
    patch do
      url "https://github.com/zyantific/zydis/commit/29bb0163342b782b0c07134f989c0a9bb76beec0.patch?full_index=1"
      sha256 "8a23636bee945f9397367c65b4c0559e33f40a7650942047f5aca5c18b3601f6"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/zydis"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "0a63d8ae8def963707e741d727a3a463b5d7dbaabc090aa831fd5d090bf9a1d7"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/ZydisInfo -64 66 3E 65 2E F0 F2 F3 48 01 A4 98 2C 01 00 00")
    assert_match "xrelease lock add qword ptr gs:[rax+rbx*4+0x12C], rsp", output
  end
end
