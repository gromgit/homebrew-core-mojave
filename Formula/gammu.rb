class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.42.0.tar.xz"
  sha256 "d8f152314d7e4d3d643610d742845e0a016ce97c234ad4b1151574e1b09651ee"
  license "GPL-2.0-or-later"
  head "https://github.com/gammu/gammu.git", branch: "master"

  livecheck do
    url "https://wammu.eu/download/gammu/"
    regex(/href=.*?gammu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gammu"
    rebuild 1
    sha256 mojave: "be22082ae4c6104cc71fdb4652f1626eb43419d4ffc0fc54699aef23c52c4be8"
  end

  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    # Disable opportunistic linking against Postgres
    inreplace "CMakeLists.txt", "macro_optional_find_package (Postgres)", ""
    system "cmake", "-S", ".", "-B", "build",
                    "-DBASH_COMPLETION_COMPLETIONSDIR=#{bash_completion}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"gammu", "--help"
  end
end
