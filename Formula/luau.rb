class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  # Download from a commit temporarily since we can't untar the tagged release.
  # This commit is the same as the tagged release but includes a fix that prevents
  # us from using the release tag. Switch back to a release tag tarball in the next release.
  # https://github.com/Roblox/luau/issues/373
  url "https://github.com/Roblox/luau/archive/a9bdce6cc06577cb412c38db757e44ea783f7c05.tar.gz"
  version "0.515"
  sha256 "6234ea76f65f7f7eaae2e285dd834dbfe64a58a8aebc4e4681654dd635b35dfa"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/luau"
    sha256 cellar: :any_skip_relocation, mojave: "24322e12507dc7b29eaacf6081440080df041d6c4220d828bba075b10e29b3b4"
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
