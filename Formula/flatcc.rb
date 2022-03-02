class Flatcc < Formula
  desc "FlatBuffers Compiler and Library in C for C"
  homepage "https://github.com/dvidelabs/flatcc"
  url "https://github.com/dvidelabs/flatcc/archive/v0.6.0.tar.gz"
  sha256 "a92da3566d11e19bb807a83554b1a2c644a5bd91c9d9b088514456bb56e1c666"
  license "Apache-2.0"
  head "https://github.com/dvidelabs/flatcc.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/flatcc"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "f878a5869dd8010e6af04c7015538ad02457342bf8413e3271a900272cf2cc11"
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
