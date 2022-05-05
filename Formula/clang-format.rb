class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.3/llvm-14.0.3.src.tar.xz"
    sha256 "1e09e8c26e1b67bc94a128b62e9b9c24b70c697a2436a479c9e5eedc4ae29654"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.3/clang-14.0.3.src.tar.xz"
      sha256 "f85c55f192cb35b9d6af1f998b7d5abe90e369f8b16445503ffab1b02e75a6f0"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/clang-format"
    sha256 cellar: :any_skip_relocation, mojave: "5461843311203e4a8fc9ca49c7ed7b2bf3b35e11ec1a875859af6dca05e6dd21"
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
    llvmpath = if build.head?
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"

      buildpath/"llvm"
    else
      resource("clang").stage do |r|
        (buildpath/"llvm-#{version}.src/tools/clang").install Pathname("clang-#{r.version}.src").children
      end

      buildpath/"llvm-#{version}.src"
    end

    system "cmake", "-S", llvmpath, "-B", "build",
                    "-DLLVM_EXTERNAL_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    git_clang_format = llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    inreplace git_clang_format, %r{^#!/usr/bin/env python$}, "#!/usr/bin/env python3"

    bin.install "build/bin/clang-format", git_clang_format
    (share/"clang").install llvmpath.glob("tools/clang/tools/clang-format/clang-format*")
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS
    system "git", "add", "test.c"

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format")
  end
end
