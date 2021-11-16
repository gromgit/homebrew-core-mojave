class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://www.bok.net/Bento4/source/Bento4-SRC-1-6-0-639.zip"
  version "1.6.0-639"
  sha256 "3c6be48e38e142cf9b7d9ff2713e84db4e39e544a16c6b496a6c855f0b99cc56"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www.bok.net/Bento4/source/"
    regex(/href=.*?Bento4-SRC[._-]v?(\d+(?:[.-]\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "e88e423282b02fbb08e16a35baabd24fbcfecacc68bcd1e6bd5ae6151074094f"
    sha256 cellar: :any_skip_relocation, big_sur:      "24f9c59b18a2730fe6e96d49d052d9a1697bc3b4ebed99bd23f23eacd27a2e9e"
    sha256 cellar: :any_skip_relocation, catalina:     "c4e3e66af58ce4e2058421f2107426c1a24f174ab1325490976864d33593ce75"
    sha256 cellar: :any_skip_relocation, mojave:       "85d5e0cbeef595dde2bdd79d9c207391a98bab9cff2736116f6debf6e3feb53f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "be5b120e691952f835be698e3a271e719da3da0a825623a98b7ffdb3940ff884"
  end

  depends_on xcode: :build
  # artifact does not produce arm64 native binaries
  depends_on arch: :x86_64
  depends_on "python@3.10"

  on_linux do
    depends_on "cmake" => :build
  end

  conflicts_with "gpac", because: "both install `mp42ts` binaries"
  conflicts_with "mp4v2", because: "both install `mp4extract` and `mp4info` binaries"

  def install
    if OS.mac?
      cd "Build/Targets/universal-apple-macosx" do
        xcodebuild "-target", "All", "-configuration", "Release", "SYMROOT=build"
        programs = Dir["build/Release/*"].select do |f|
          next if f.end_with? ".dylib"
          next if f.end_with? "Test"

          File.file?(f) && File.executable?(f)
        end
        bin.install programs
      end
    else
      mkdir "cmakebuild" do
        system "cmake", "..", *std_cmake_args
        system "make"
        programs = Dir["./*"].select do |f|
          File.file?(f) && File.executable?(f)
        end
        bin.install programs
      end
    end

    rm Dir["Source/Python/wrappers/*.bat"]
    inreplace Dir["Source/Python/wrappers/*"],
              "BASEDIR=$(dirname $0)", "BASEDIR=#{libexec}/Python/wrappers"
    libexec.install "Source/Python"
    bin.install_symlink Dir[libexec/"Python/wrappers/*"]
  end

  test do
    system "#{bin}/mp4mux", "--track", test_fixtures("test.m4a"), "out.mp4"
    assert_predicate testpath/"out.mp4", :exist?, "Failed to create out.mp4!"
  end
end
