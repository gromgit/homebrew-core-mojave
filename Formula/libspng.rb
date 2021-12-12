class Libspng < Formula
  desc "C library for reading and writing PNG format files"
  homepage "https://libspng.org/"
  url "https://github.com/randy408/libspng/archive/v0.7.1.tar.gz"
  sha256 "0726a4914ad7155028f3baa94027244d439cd2a2fbe8daf780c2150c4c951d8e"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libspng"
    sha256 cellar: :any, mojave: "b20164949e2bbd0fc3f929d9685d32237b91e31e2141f7657c5858eafc4105bb"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
    pkgshare.install "examples/example.c"
  end

  test do
    fixture = test_fixtures("test.png")
    cp pkgshare/"example.c", testpath/"example.c"
    system ENV.cc, "example.c", "-L#{lib}", "-I#{include}", "-lspng", "-o", "example"

    output = shell_output("./example #{fixture}")
    assert_match "width: 8\nheight: 8\nbit depth: 1\ncolor type: 3 - indexed color\n" \
                 "compression method: 0\nfilter method: 0\ninterlace method: 0", output
  end
end
