class Nlopt < Formula
  desc "Free/open-source library for nonlinear optimization"
  homepage "https://nlopt.readthedocs.io/"
  url "https://github.com/stevengj/nlopt/archive/v2.7.1.tar.gz"
  sha256 "db88232fa5cef0ff6e39943fc63ab6074208831dc0031cf1545f6ecd31ae2a1a"
  license "LGPL-2.1"
  head "https://github.com/stevengj/nlopt.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nlopt"
    rebuild 1
    sha256 cellar: :any, mojave: "0374fba99febfe54c30e8f09e31dfdc41da777647da7913db7327ad480f878a7"
  end

  depends_on "cmake" => [:build, :test]

  def install
    args = *std_cmake_args + %w[
      -DNLOPT_GUILE=OFF
      -DNLOPT_MATLAB=OFF
      -DNLOPT_OCTAVE=OFF
      -DNLOPT_PYTHON=OFF
      -DNLOPT_SWIG=OFF
      -DNLOPT_TESTS=OFF
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end

    pkgshare.install "test/box.c"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.0)
      project(box C)
      find_package(NLopt REQUIRED)
      add_executable(box "#{pkgshare}/box.c")
      target_link_libraries(box NLopt::nlopt)
    EOS
    system "cmake", "."
    system "make"
    assert_match "found", shell_output("./box")
  end
end
