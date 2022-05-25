class Flatcc < Formula
  desc "FlatBuffers Compiler and Library in C for C"
  homepage "https://github.com/dvidelabs/flatcc"
  url "https://github.com/dvidelabs/flatcc/archive/v0.6.1.tar.gz"
  sha256 "2533c2f1061498499f15acc7e0937dcf35bc68e685d237325124ae0d6c600c2b"
  license "Apache-2.0"
  head "https://github.com/dvidelabs/flatcc.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/flatcc"
    sha256 cellar: :any_skip_relocation, mojave: "0519b2f0e641e2315fb0c18465ebac4c99dc22d5c80a3cb0802ceff19d620abf"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-G", "Unix Makefiles", buildpath, *std_cmake_args
    system "make"

    bin.install "bin/flatcc"
    lib.install "lib/libflatcc.a"
    lib.install "lib/libflatccrt.a"
    include.install Dir["include/*"]
  end

  test do
    (testpath/"test.fbs").write <<~EOS
      // example IDL file

      namespace MyGame.Sample;

      enum Color:byte { Red = 0, Green, Blue = 2 }

      union Any { Monster }  // add more elements..

        struct Vec3 {
          x:float;
          y:float;
          z:float;
        }

        table Monster {
          pos:Vec3;
          mana:short = 150;
          hp:short = 100;
          name:string;
          friendly:bool = false (deprecated);
          inventory:[ubyte];
          color:Color = Blue;
        }

      root_type Monster;

    EOS

    system bin/"flatcc", "-av", "--json", "test.fbs"
  end
end
