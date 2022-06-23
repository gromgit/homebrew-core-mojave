class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom.git",
      tag:      "v1.12.0",
      revision: "d3abd6b22fe4afc0daa64d6b905911999b12dcdd"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vroom"
    sha256 cellar: :any, mojave: "9de4f3856af7af0342748e5ef5a2968333e7f5ea5c55f583be7f730144d998c3"
  end

  depends_on "cxxopts" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "asio"
  depends_on macos: :mojave # std::optional C++17 support
  depends_on "openssl@1.1"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # Fix build on macOS (https://github.com/VROOM-Project/vroom/issues/723)
  # Patch accepted upstream, remove on next release
  patch do
    url "https://github.com/VROOM-Project/vroom/commit/f9e66df218e32eeb0026d2e1611a27ccf004fefd.patch?full_index=1"
    sha256 "848d5f03910d5cd4ae78b68f655c2db75a0e9f855e5ec34855e8cac58a0601b7"
  end

  def install
    # Use brewed dependencies instead of vendored dependencies
    cd "include" do
      rm_rf ["cxxopts", "rapidjson"]
      mkdir_p "cxxopts"
      ln_s Formula["cxxopts"].opt_include, "cxxopts/include"
      ln_s Formula["rapidjson"].opt_include, "rapidjson"
    end

    cd "src" do
      system "make"
    end
    bin.install "bin/vroom"
    pkgshare.install "docs"
  end

  test do
    output = shell_output("#{bin}/vroom -i #{pkgshare}/docs/example_2.json")
    expected_routes = JSON.parse((pkgshare/"docs/example_2_sol.json").read)["routes"]
    actual_routes = JSON.parse(output)["routes"]
    assert_equal expected_routes, actual_routes
  end
end
