class Editorconfig < Formula
  desc "Maintain consistent coding style between multiple editors"
  homepage "https://editorconfig.org/"
  url "https://github.com/editorconfig/editorconfig-core-c/archive/v0.12.5.tar.gz"
  sha256 "b2b212e52e7ea6245e21eaf818ee458ba1c16117811a41e4998f3f2a1df298d2"
  license "BSD-2-Clause"
  head "https://github.com/editorconfig/editorconfig-core-c.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/editorconfig"
    rebuild 1
    sha256 cellar: :any, mojave: "687eb2b819295967d2894f16aeaf88c40f29cd973af558321961ac03f7f5eea5"
  end


  depends_on "cmake" => :build
  depends_on "pcre2"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/editorconfig", "--version"
  end
end
