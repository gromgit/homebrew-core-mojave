class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  # Check whether this can be switched to `openexr` and `imath` at version bump
  url "https://github.com/ampas/CTL/archive/ctl-1.5.2.tar.gz"
  sha256 "d7fac1439332c4d84abc3c285b365630acf20ea041033b154aa302befd25e0bd"
  license "AMPAS"
  revision 7

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ctl"
    sha256 cellar: :any, mojave: "4d2627e2b7de66e1a96a76dc27eb30af8b0e007a0e82ef2236b51ecb460232da"
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "ilmbase"
  depends_on "libtiff"
  depends_on "openexr@2"

  # from https://github.com/ampas/CTL/pull/73
  patch do
    url "https://github.com/ampas/CTL/commit/bda2165b97e512a39ee67cf36fe95e1d897e823b.patch?full_index=1"
    sha256 "09145020a79b180bb8bb8e18129194b064d4c8a949940fb97be4945b99b06d7f"
  end

  # from https://github.com/ampas/CTL/pull/74
  patch do
    url "https://github.com/ampas/CTL/commit/0646adf9dcf966db3c6ec9432901c08387c1a1eb.patch?full_index=1"
    sha256 "5ec79eed7499612855d09d7bb18a66a660b6be9785fdfcc880d946f95fb7a44c"
  end

  def install
    ENV.cxx11
    ENV.delete "CTL_MODULE_PATH"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "transforms an image", shell_output("#{bin}/ctlrender -help", 1)
  end
end
