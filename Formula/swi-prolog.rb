class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-8.4.3.tar.gz"
  sha256 "946119a0b5f5c8f410ea21fbf6281e917e61ef35ac0aabbdd24e787470d06faa"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/swi-prolog"
    sha256 mojave: "201de5a8f2281c21019b1cbe598765eb0b6158a5ff2454f9378a846e5aaceb26"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "gmp"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "readline"
  depends_on "unixodbc"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Remove shim paths from binary files `swipl-ld` and `libswipl.so.*`
    if OS.linux?
      inreplace "cmake/Params.cmake" do |s|
        s.gsub! "${CMAKE_C_COMPILER}", "\"gcc\""
        s.gsub! "${CMAKE_CXX_COMPILER}", "\"g++\""
      end
    end

    args = ["-DSWIPL_PACKAGES_JAVA=OFF", "-DSWIPL_PACKAGES_X=OFF"]
    args << "-DCMAKE_INSTALL_RPATH=@loader_path" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: libexec), *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.pl").write <<~EOS
      test :-
          write('Homebrew').
    EOS
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end
