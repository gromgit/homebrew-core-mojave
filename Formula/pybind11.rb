class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v2.10.0.tar.gz"
  sha256 "eacf582fa8f696227988d08cfc46121770823839fe9e301a20fbce67e7cd70ec"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pybind11"
    sha256 cellar: :any_skip_relocation, mojave: "1e749aa524598146c9854cec785ee91d28b5bdd9ffeb01502005738c6391e6d2"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.8" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@3\.\d+$/) }
  end

  def install
    # Install /include and /share/cmake to the global location
    system "cmake", "-S", ".", "-B", "build",
           "-DPYBIND11_TEST=OFF",
           "-DPYBIND11_NOPYTHON=ON",
           *std_cmake_args
    system "cmake", "--install", "build"

    pythons.each do |python|
      # Install Python package too
      site_packages = Language::Python.site_packages python.opt_bin/"python3"
      system python.opt_bin/"python3", *Language::Python.setup_install_args(libexec),
                                       "--install-lib=#{libexec/site_packages}"

      pyversion = Language::Python.major_minor_version python.opt_bin/"python3"
      pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
      (prefix/site_packages/"homebrew-pybind11.pth").write pth_contents

      bin.install libexec/"bin/pybind11-config" => "pybind11-config-#{pyversion}"

      next unless python == pythons.max_by(&:version)

      # The newest one is used as the default
      bin.install_symlink "pybind11-config-#{pyversion}" => "pybind11-config"
    end
  end

  test do
    (testpath/"example.cpp").write <<~EOS
      #include <pybind11/pybind11.h>

      int add(int i, int j) {
          return i + j;
      }
      namespace py = pybind11;
      PYBIND11_MODULE(example, m) {
          m.doc() = "pybind11 example plugin";
          m.def("add", &add, "A function which adds two numbers");
      }
    EOS

    (testpath/"example.py").write <<~EOS
      import example
      example.add(1,2)
    EOS

    pythons.each do |python|
      pyversion = Language::Python.major_minor_version python.opt_bin/"python3"
      site_packages = Language::Python.site_packages python.opt_bin/"python3"

      python_flags = Utils.safe_popen_read(python.opt_bin/"python3-config", "--cflags", "--ldflags", "--embed").split
      system ENV.cxx, "-shared", "-fPIC", "-O3", "-std=c++11", "example.cpp", "-o", "example.so", *python_flags
      system python.opt_bin/"python3", "example.py"

      test_module = shell_output("#{python.opt_bin}/python3 -m pybind11 --includes")
      assert_match (libexec/site_packages).to_s, test_module

      test_script = shell_output("#{opt_bin}/pybind11-config-#{pyversion} --includes")
      assert_match test_module, test_script

      next unless python == pythons.max_by(&:version)

      test_module = shell_output("#{python.opt_bin}/python3 -m pybind11 --includes")
      test_script = shell_output("#{opt_bin}/pybind11-config --includes")
      assert_match test_module, test_script
    end
  end
end
