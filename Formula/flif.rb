class Flif < Formula
  desc "Free Loseless Image Format"
  homepage "https://flif.info/"
  # When updating, please check if FLIF switched to CMake yet
  url "https://github.com/FLIF-hub/FLIF/archive/v0.3.tar.gz"
  sha256 "aa02a62974d78f8109cff21ecb6d805f1d23b05b2db7189cfdf1f0d97ff89498"
  license "LGPL-3.0"
  head "https://github.com/FLIF-hub/FLIF.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "3562aa4e5c79586e5edd3908ae34bf87cd75d1d9ba35fe270166a0604c3dc6e8"
    sha256 cellar: :any,                 big_sur:       "7c50517e175d15ba665f2ea5a138a762c017270c38636e55cf1ef1fb6c2d83d2"
    sha256 cellar: :any,                 catalina:      "0c21811ef5a29e427952afbc57fb657ece17c91fc84e69eba7ab9f97fb439303"
    sha256 cellar: :any,                 mojave:        "41d1a634a2442550395bd454b84606570cc9f670fa2df158d39fddb70de39367"
    sha256 cellar: :any,                 high_sierra:   "40b85a93738e195a6eec2b3bf9bfe7b2831f74d464e1e5145681f9ec2c3cfe68"
    sha256 cellar: :any,                 sierra:        "756f685e55f7c798743756723815fb3f39d82ef92f5cc78eb175d8cea52498a3"
    sha256 cellar: :any,                 el_capitan:    "3fd4e69366470a6810815d111a8e0188c627fe7d50375cd93c0da00ad6617fb2"
    sha256 cellar: :any,                 yosemite:      "bbd4e35f6947e3b304469031f42c3720a94c10d9fb7540eed9e7b08bef6ee319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff311c649c3357c593fa165175971438c4c5cc5b582307845c722da847579479"
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "sdl2"

  resource "test_c" do
    url "https://raw.githubusercontent.com/FLIF-hub/FLIF/dcc2011/tools/test.c"
    sha256 "a20b625ba0efdb09ad21a8c1c9844f686f636656f0e9bd6c24ad441375223afe"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install", "install-dev"
    doc.install "doc/flif.pdf"
  end

  test do
    testpath.install resource("test_c")
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lflif", "-o", "test"
    system "./test", "dummy.flif"
    system bin/"flif", "-i", "dummy.flif"
    system bin/"flif", "-I", test_fixtures("test.png"), "test.flif"
    system bin/"flif", "-d", "test.flif", "test.png"
    assert_predicate testpath/"test.png", :exist?, "Failed to decode test.flif"
  end
end
