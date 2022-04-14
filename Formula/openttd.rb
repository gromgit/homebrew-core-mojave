class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://cdn.openttd.org/openttd-releases/12.2/openttd-12.2-source.tar.xz"
  sha256 "81508f0de93a0c264b216ef56a05f8381fff7bffa6d010121a21490b4dace95c"
  license "GPL-2.0-only"
  head "https://github.com/OpenTTD/OpenTTD.git", branch: "master"

  livecheck do
    url :homepage
    regex(/Download stable \((\d+(\.\d+)+)\)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/openttd"
    sha256 cellar: :any, mojave: "72fcfe14d2b391f7744c968fe198fb1ec7b9105dbdcc81f50057a4de27519b48"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "lzo"
  depends_on macos: :high_sierra # needs C++17
  depends_on "xz"

  resource "opengfx" do
    url "https://cdn.openttd.org/opengfx-releases/7.1/opengfx-7.1-all.zip"
    sha256 "928fcf34efd0719a3560cbab6821d71ce686b6315e8825360fba87a7a94d7846"
  end

  resource "openmsx" do
    url "https://cdn.openttd.org/openmsx-releases/0.4.2/openmsx-0.4.2-all.zip"
    sha256 "5a4277a2e62d87f2952ea5020dc20fb2f6ffafdccf9913fbf35ad45ee30ec762"
  end

  resource "opensfx" do
    url "https://cdn.openttd.org/opensfx-releases/1.0.3/opensfx-1.0.3-all.zip"
    sha256 "e0a218b7dd9438e701503b0f84c25a97c1c11b7c2f025323fb19d6db16ef3759"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "cpack || :"
    end

    app = "build/_CPack_Packages/amd64/Bundle/openttd-#{version}-macos-amd64/OpenTTD.app"
    resources.each do |r|
      (buildpath/"#{app}/Contents/Resources/baseset/#{r.name}").install r
    end
    prefix.install app
    bin.write_exec_script "#{prefix}/OpenTTD.app/Contents/MacOS/openttd"
  end

  test do
    assert_match "OpenTTD #{version}\n", shell_output("#{bin}/openttd -h")
  end
end
