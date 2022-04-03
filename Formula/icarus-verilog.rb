class IcarusVerilog < Formula
  desc "Verilog simulation and synthesis tool"
  homepage "http://iverilog.icarus.com/"
  url "https://github.com/steveicarus/iverilog/archive/v11_0.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/i/iverilog/iverilog_11.0.orig.tar.gz"
  sha256 "6327fb900e66b46803d928b7ca439409a0dc32731d82143b20387be0833f1c95"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/steveicarus/iverilog.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/icarus-verilog"
    rebuild 1
    sha256 mojave: "6860aaba48dd692bbf1c66de1d5bcc5dce28c08c34cce30722db474088a7e9a2"
  end

  # support for autoconf >= 2.70 was added after the current release
  # switch to `autoconf` in the next release
  # ref: https://github.com/steveicarus/iverilog/commit/4b3e1099e5517333dd690ba948bce1236466a395
  depends_on "autoconf@2.69" => :build
  # parser is subtly broken when processed with an old version of bison
  depends_on "bison" => :build

  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
  end

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    # https://github.com/steveicarus/iverilog/issues/85
    ENV.deparallelize
    system "make", "install", "BISON=#{Formula["bison"].opt_bin}/bison"
  end

  test do
    (testpath/"test.v").write <<~EOS
      module main;
        initial
          begin
            $display("Boop");
            $finish;
          end
      endmodule
    EOS
    system bin/"iverilog", "-otest", "test.v"
    assert_equal "Boop", shell_output("./test").chomp

    # test syntax errors do not cause segfaults
    (testpath/"error.v").write "error;"
    assert_equal "-:1: error: variable declarations must be contained within a module.",
      shell_output("#{bin}/iverilog error.v 2>&1", 1).chomp
  end
end
