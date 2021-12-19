class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  # Please add to synced_versions_formulae.json once version synced with boost
  url "https://boostorg.jfrog.io/artifactory/main/release/1.78.0/source/boost_1_78_0.tar.bz2"
  sha256 "8681f175d4bdb26c52222665793eef08490d7758529330f98d3b29dd0735bccc"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/boost-bcp"
    sha256 cellar: :any_skip_relocation, mojave: "fff9a56c2fc29b5f54edf3b789e53dcad6a9b8ee4961773d9e8b3f4b6ab3c6a0"
  end

  depends_on "boost-build" => :build
  depends_on "boost" => :test

  def install
    # remove internal reference to use brewed boost-build
    rm "boost-build.jam"
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--boost=#{Formula["boost"].opt_include}", "--scan", "./"
  end
end
