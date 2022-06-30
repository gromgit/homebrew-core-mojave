class Sdcv < Formula
  desc "StarDict Console Version"
  homepage "https://dushistov.github.io/sdcv/"
  url "https://github.com/Dushistov/sdcv/archive/v0.5.4.tar.gz"
  sha256 "9fddec393f5dd6b208991d8225f90cb14d50fa9e7735f2414035d8a2ca065f28"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/Dushistov/sdcv.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sdcv"
    sha256 mojave: "8e1b0a204aa8826664c6370de6d8f6cc0a17d4ef138e3f747b94c62d2fc93996"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "readline"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "lang"
      system "make", "install"
    end
  end

  test do
    system bin/"sdcv", "-h"
  end
end
