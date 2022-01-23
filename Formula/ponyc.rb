class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.46.0",
      revision: "afda8d1408bd4fc6ff420fb25e80f7ee91f3933c"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ponyc"
    sha256 cellar: :any_skip_relocation, mojave: "f3ba0b28bad837b11579bca6cc097a24afae0dcfded5a6b44d3f0f475e6ac010"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    ENV.cxx11

    inreplace "CMakeLists.txt", "PONY_COMPILER=\"${CMAKE_C_COMPILER}\"", "PONY_COMPILER=\"#{ENV.cc}\"" if OS.linux?

    ENV["MAKEFLAGS"] = "build_flags=-j#{ENV.make_jobs}"
    system "make", "libs"
    system "make", "configure"
    system "make", "build"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/stdlib"

    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end
