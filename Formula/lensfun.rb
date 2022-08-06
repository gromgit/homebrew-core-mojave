class Lensfun < Formula
  include Language::Python::Shebang

  desc "Remove defects from digital images"
  homepage "https://lensfun.github.io/"
  url "https://github.com/lensfun/lensfun/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "57ba5a0377f24948972339e18be946af12eda22b7c707eb0ddd26586370f6765"
  license all_of: [
    "LGPL-3.0-only",
    "GPL-3.0-only",
    "CC-BY-3.0",
    :public_domain,
  ]
  revision 1
  version_scheme 1
  head "https://github.com/lensfun/lensfun.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lensfun"
    sha256 mojave: "87745747e4040f0bc14cb9b3b311eaa458e6474983d5249c822c86677007dc26"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libpng"
  depends_on "python@3.10"

  def install
    # setuptools>=60 prefers its own bundled distutils, which breaks the installation
    ENV["SETUPTOOLS_USE_DISTUTILS"] = "stdlib"

    # Work around Homebrew's "prefix scheme" patch which causes non-pip installs
    # to incorrectly try to write into HOMEBREW_PREFIX/lib since Python 3.10.
    site_packages = prefix/Language::Python.site_packages("python3")
    inreplace "apps/CMakeLists.txt", "${SETUP_PY} install ", "\\0 --install-lib=#{site_packages} "

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    rewrite_shebang detected_python_shebang,
      bin/"lensfun-add-adapter", bin/"lensfun-convert-lcp", bin/"lensfun-update-data"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"lensfun-update-data"
  end
end
