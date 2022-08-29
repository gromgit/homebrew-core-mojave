class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v2.0.7.tar.gz"
  sha256 "4c7986174dc3941220bf14feaacaad409c3e1526d9ad7f490366fede9a6f43fa"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/flatbuffers"
    sha256 cellar: :any, mojave: "c4e2424a396f492fcd10034d764337c0cb146dbf1f3e9d686276c8b8b43b09dd"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  conflicts_with "osrm-backend", because: "both install flatbuffers headers"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DFLATBUFFERS_BUILD_SHAREDLIB=ON",
                    "-DFLATBUFFERS_BUILD_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    def testfbs
      <<~EOS
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
    end
    (testpath/"test.fbs").write(testfbs)

    def testjson
      <<~EOS
        {
          pos: {
            x: 1,
            y: 2,
            z: 3
          },
          hp: 80,
          name: "MyMonster"
        }
      EOS
    end
    (testpath/"test.json").write(testjson)

    system bin/"flatc", "-c", "-b", "test.fbs", "test.json"
  end
end
