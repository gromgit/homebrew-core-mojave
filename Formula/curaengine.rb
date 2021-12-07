class Curaengine < Formula
  desc "C++ 3D printing GCode generator"
  homepage "https://github.com/Ultimaker/CuraEngine"
  url "https://github.com/Ultimaker/CuraEngine/archive/4.12.1.tar.gz"
  sha256 "d23514cb0140926c929b18b09db01c439b822db3243a13bc907f38adeca0252b"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/Ultimaker/CuraEngine.git", branch: "master"

  # Releases like xx.xx or xx.xx.x are older than releases like x.x.x, so we
  # work around this less-than-ideal situation by restricting the major version
  # to one digit. This won't pick up versions where the major version is 10+
  # but thankfully that hasn't been true yet. This should be handled in a better
  # way in the future, to avoid the possibility of missing good versions.
  livecheck do
    url :stable
    regex(/^v?(\d(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/curaengine"
    sha256 cellar: :any_skip_relocation, mojave: "d1d2714db57624d60a8dbf72bad0964aceee42dc019d74fd1bd3ba0966402ed6"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # The version tag in these resources (e.g., `/1.2.3/`) should be changed as
  # part of updating this formula to a new version.
  resource "fdmextruder_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.11.0/resources/definitions/fdmextruder.def.json"
    sha256 "331c3e203eaf012b19b62795235becec9f1da8939e96fc6834213291269c769e"
  end

  resource "fdmprinter_defaults" do
    url "https://raw.githubusercontent.com/Ultimaker/Cura/4.11.0/resources/definitions/fdmprinter.def.json"
    sha256 "7e6d73c6165c6d50e09ed2b6cd417ebb82fe6832e99ebfec19f7584224ffd60c"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DCMAKE_INSTALL_PREFIX=#{libexec}",
                            "-DENABLE_ARCUS=OFF"
      system "make", "install"
    end
    bin.install "build/CuraEngine"
  end

  test do
    testpath.install resource("fdmextruder_defaults")
    testpath.install resource("fdmprinter_defaults")
    (testpath/"t.stl").write <<~EOS
      solid t
        facet normal 0 -1 0
         outer loop
          vertex 0.83404 0 0.694596
          vertex 0.36904 0 1.5
          vertex 1.78814e-006 0 0.75
         endloop
        endfacet
      endsolid Star
    EOS

    system "#{bin}/CuraEngine", "slice", "-j", "fdmprinter.def.json", "-l", "#{testpath}/t.stl"
  end
end
