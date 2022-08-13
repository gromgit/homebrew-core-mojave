class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://openbabel.org"
  url "https://github.com/openbabel/openbabel/archive/openbabel-3-1-1.tar.gz"
  version "3.1.1"
  sha256 "c97023ac6300d26176c97d4ef39957f06e68848d64f1a04b0b284ccff2744f02"
  license "GPL-2.0"
  revision 2
  head "https://github.com/openbabel/openbabel.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/open-babel"
    sha256 mojave: "e658a6290aab86bba08cee6d771a8405bcbac3c783349983e774d06ded7f0a01"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "eigen"
  depends_on "python@3.10"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DRUN_SWIG=ON",
                    "-DPYTHON_BINDINGS=ON",
                    "-DPYTHON_EXECUTABLE=#{Formula["python@3.10"].opt_bin}/python3"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"obabel", "-:'C1=CC=CC=C1Br'", "-omol"
  end
end
