class Seexpr < Formula
  desc "Embeddable expression evaluation engine"
  homepage "https://wdas.github.io/SeExpr/"
  url "https://github.com/wdas/SeExpr/archive/v3.0.1.tar.gz"
  sha256 "1e4cd35e6d63bd3443e1bffe723dbae91334c2c94a84cc590ea8f1886f96f84e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "d525a96b58f896e76192699ed10018bc992287604d1902c7c8614ebc508b7fe7"
    sha256 cellar: :any, arm64_big_sur:  "722581c38cd9860d5dc9b53f85b9560f3c1039b49a17180114c6f2370556fc86"
    sha256 cellar: :any, monterey:       "45a50904ddbd4940674d0c844878effb7f7175af28c37feabb0f6ee52509e48d"
    sha256 cellar: :any, big_sur:        "8045ec68c468b5db8a118006756e34c54425bbcc3e29306c16a52e86ccefdbb7"
    sha256 cellar: :any, catalina:       "2a55400ad86255b300843f7cde1dbed4130d0ba26ffc4c8725fec83b50e7f9e3"
    sha256 cellar: :any, mojave:         "e5ba2fcca24837fc43d11524fdeff04d9f4429f6c66421dec6c1925b60893f82"
    sha256 cellar: :any, high_sierra:    "b5a3d64c08f692d25d3eb12dd9409c414939303b0b9f19396c95a13d07b46fa9"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libpng"

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DUSE_PYTHON=FALSE
      -DENABLE_LLVM_BACKEND=FALSE
      -DENABLE_QT5=FALSE
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "doc"
    system "cmake", "--install", "build"
  end

  test do
    actual_output = shell_output("#{bin}/asciiGraph2 'x^3-8*x'").lines.map(&:rstrip).join("\n")
    expected_output = <<~EOS
                                    |        #
                              ##    |        #
                              ###   |
                             #  #   |        #
                             #  ##  |        #
                             #   #  |        #
                            ##   #  |        #
                            #    ## |        #
                            #     # |        #
                            #     # |        #
                            #     # |        #
                            #      #|       #
                           #       #|       #
                           #       #|       #
      ---------------------#-------##-------#---------------------
                           #        #       #
                           #        #       #
                           #        #       #
                           #        ##      #
                           #        |#     #
                          #         |#     #
                          #         |#     #
                          #         |##    #
                          #         | #    #
                          #         | #   #
                          #         | ##  #
                          #         |  #  #
                                    |  ###
                          #         |   ##
                          #         |
    EOS

    assert_equal actual_output, expected_output.rstrip
  end
end
