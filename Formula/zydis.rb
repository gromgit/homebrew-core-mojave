class Zydis < Formula
  desc "Fast and lightweight x86/x86_64 disassembler library"
  homepage "https://zydis.re"
  url "https://github.com/zyantific/zydis.git",
      tag:      "v3.2.1",
      revision: "4022f22f9280650082a9480519c86a6e2afde2f3"
  license "MIT"
  head "https://github.com/zyantific/zydis.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/zydis"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "3f97e852161157729678c9972cb41270b262a95dd67c0373da3c5822f3f63421"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/ZydisInfo -64 66 3E 65 2E F0 F2 F3 48 01 A4 98 2C 01 00 00")
    assert_match "xrelease lock add qword ptr gs:[rax+rbx*4+0x12C], rsp", output
  end
end
