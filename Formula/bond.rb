class Bond < Formula
  desc "Cross-platform framework for working with schematized data"
  homepage "https://github.com/microsoft/bond"
  url "https://github.com/microsoft/bond/archive/10.0.0.tar.gz"
  sha256 "87858b597a1da74421974d5c3cf3a9ea56339643b19b48274d44b13bc9483f29"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bond"
    sha256 cellar: :any, mojave: "b4badb413a365f36c25462aa7663696b9064eba9844e57a973cd4a8a0d35f91a"
  end

  depends_on "cmake" => :build
  depends_on "ghc@8.6" => :build
  depends_on "haskell-stack" => :build
  depends_on "boost"
  depends_on "rapidjson"

  uses_from_macos "xz" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DBOND_ENABLE_GRPC=FALSE",
                            "-DBOND_FIND_RAPIDJSON=TRUE",
                            "-DBOND_STACK_OPTIONS=--system-ghc;--no-install-ghc"
      system "make"
      system "make", "install"
    end
    chmod 0755, bin/"gbc"
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/cpp/core/serialization/.", testpath
    system bin/"gbc", "c++", "serialization.bond"
    system ENV.cxx, "-std=c++11", "serialization_types.cpp", "serialization.cpp",
                    "-o", "test", "-L#{lib}/bond", "-lbond", "-lbond_apply"
    system "./test"
  end
end
