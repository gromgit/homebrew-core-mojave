class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2022-07-21.tar.gz"
  version "2022.07.21"
  sha256 "44085e694a913d529d8f16d03cb9d3c7ba614e82452fc0156bb075f7f6df5920"
  license "MIT"
  revision 1
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d{4}(?:[._-]\d{2}){2})["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vcpkg"
    rebuild 1
    sha256 cellar: :any, mojave: "1ea988e31980a31d0ab684ab1762bdf7cbce9361e32d704c6722b3b9dc846c2e"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  fails_with gcc: "5"

  # Fix build with fmt 9+
  # https://github.com/microsoft/vcpkg-tool/pull/634
  patch do
    url "https://github.com/microsoft/vcpkg-tool/commit/5fba654cc47c175202491a5d80f280c0e39b364d.patch?full_index=1"
    sha256 "e9a61b8fc8e2ce21ae5eae36bf36b5e5214b0a624ef7c938ddea0e739a61340a"
  end

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace ["include/vcpkg/base/messages.h", "locales/messages.json", "locales/messages.en.json"],
              "If you are trying to use a copy of vcpkg that you've built, y", "Y"

    system "cmake", "-S", ".", "-B", "build",
                    "-DVCPKG_DEVELOPMENT_WARNINGS=OFF",
                    "-DVCPKG_BASE_VERSION=#{version.to_s.tr(".", "-")}",
                    "-DVCPKG_VERSION=#{version}",
                    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  # This is specific to the way we install only the `vcpkg` tool.
  def caveats
    <<~EOS
      This formula provides only the `vcpkg` executable. To use vcpkg:
        git clone https://github.com/microsoft/vcpkg "$HOME/vcpkg"
        export VCPKG_ROOT="$HOME/vcpkg"
    EOS
  end

  test do
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    message = "error: Could not detect vcpkg-root. You must define the VCPKG_ROOT environment variable"
    assert_match message, shell_output("#{bin}/vcpkg search sqlite", 1)
  end
end
