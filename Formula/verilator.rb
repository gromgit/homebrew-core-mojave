class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v4.222.tar.gz"
  sha256 "15c60175807c0f3536c3c5b435f131c2b1e8725aefd30645efd946bf401b4c84"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/verilator"
    sha256 mojave: "1489278e68e56928a05ba3f3646dbe6bdee15993c028841ab8359064be3039ac"
  end

  head do
    url "https://github.com/verilator/verilator.git", using: :git
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.10" => :build

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "perl"

  on_linux do
    depends_on "gcc"
  end

  skip_clean "bin" # Allows perl scripts to keep their executable flag

  # error: specialization of 'template<class _Tp> struct std::hash' in different namespace
  fails_with gcc: "5"

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    # `make` and `make install` need to be separate for parallel builds
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.v").write <<~EOS
      module test;
         initial begin $display("Hello World"); $finish; end
      endmodule
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include "Vtest.h"
      #include "verilated.h"
      int main(int argc, char **argv, char **env) {
          Verilated::commandArgs(argc, argv);
          Vtest* top = new Vtest;
          while (!Verilated::gotFinish()) { top->eval(); }
          delete top;
          exit(0);
      }
    EOS
    system "/usr/bin/perl", bin/"verilator", "-Wall", "--cc", "test.v", "--exe", "test.cpp"
    cd "obj_dir" do
      system "make", "-j", "-f", "Vtest.mk", "Vtest"
      expected = <<~EOS
        Hello World
        - test.v:2: Verilog $finish
      EOS
      assert_equal expected, shell_output("./Vtest")
    end
  end
end
