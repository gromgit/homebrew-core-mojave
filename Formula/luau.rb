class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.512.tar.gz"
  sha256 "9d0c6813d77c28de8a6de06991dfc3bf90d32bc0ea7157fa52afe066ace9447b"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/luau"
    sha256 cellar: :any_skip_relocation, mojave: "7b1e8d3b2397ba567db1f7e8ea764eca2bc2920def245756abfec71f87a924de"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DLUAU_BUILD_TESTS=OFF"
    system "cmake", "--build", "build"
    bin.install "build/luau", "build/luau-analyze"
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end
