class Lit < Formula
  include Language::Python::Virtualenv

  desc "Portable tool for LLVM- and Clang-style test suites"
  homepage "https://llvm.org"
  url "https://files.pythonhosted.org/packages/f7/fc/aba44ef618619519d4fb56e604163fd85f4b598a4fd8a105e32e4e456798/lit-13.0.0.tar.gz"
  sha256 "4da976f3d114e4ba6ba06cbe660ce1393230f4519c4df15b90bc1840f00e4195"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "306d83ed52347e1f2e8f0781048c20dcd147ba2248d3e1a6458f88a75d6ca8de"
  end

  depends_on "llvm" => :test
  depends_on "python@3.10"

  def install
    system "python3", *Language::Python.setup_install_args(prefix)

    # Install symlinks so that `import lit` works with multiple versions of Python
    python_versions = Formula.names
                             .select { |name| name.start_with? "python@" }
                             .map { |py| py.delete_prefix("python@") }
                             .reject { |xy| xy == Language::Python.major_minor_version("python3") }
    site_packages = Language::Python.site_packages("python3").delete_prefix("lib/")
    python_versions.each do |xy|
      (lib/"python#{xy}/site-packages").install_symlink (lib/site_packages).children
    end
  end

  test do
    ENV.prepend_path "PATH", Formula["llvm"].opt_bin

    (testpath/"example.c").write <<~EOS
      // RUN: cc %s -o %t
      // RUN: %t | FileCheck %s
      // CHECK: hello world
      #include <stdio.h>

      int main() {
        printf("hello world");
        return 0;
      }
    EOS

    (testpath/"lit.site.cfg.py").write <<~EOS
      import lit.formats

      config.name = "Example"
      config.test_format = lit.formats.ShTest(True)

      config.suffixes = ['.c']
    EOS

    system bin/"lit", "-v", "."

    if OS.mac?
      ENV.prepend_path "PYTHONPATH", prefix/Language::Python.site_packages("python3")
    else
      python = deps.reject { |d| d.build? || d.test? }
                   .find { |d| d.name.match?(/^python@\d+(\.\d+)*$/) }
                   .to_formula
      ENV.prepend_path "PATH", python.opt_bin
    end
    system "python3", "-c", "import lit"
  end
end
