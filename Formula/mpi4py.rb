class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/3.1.4/mpi4py-3.1.4.tar.gz"
  sha256 "17858f2ebc623220d0120d1fa8d428d033dde749c4bc35b33d81a66ad7f93480"
  license "BSD-2-Clause"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mpi4py"
    sha256 cellar: :any, mojave: "46f33446d898c2ab83738b88bf0c2db3ecd6817204bddc4bb2bb6c6a4825b271"
  end

  depends_on "libcython" => :build
  depends_on "open-mpi"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    system python3, *Language::Python.setup_install_args(libexec, python3)

    system python3, "setup.py",
                    "build", "--mpicc=mpicc -shared", "--parallel=#{ENV.make_jobs}",
                    "install", "--prefix=#{prefix}",
                    "--single-version-externally-managed", "--record=installed.txt",
                    "--install-lib=#{prefix/Language::Python.site_packages(python3)}"
  end

  test do
    system python3, "-c", "import mpi4py"
    system python3, "-c", "import mpi4py.MPI"
    system python3, "-c", "import mpi4py.futures"

    system "mpiexec", "-n", ENV.make_jobs, "--use-hwthread-cpus",
           python3, "-m", "mpi4py.run", "-m", "mpi4py.bench", "helloworld"
    system "mpiexec", "-n", ENV.make_jobs, "--use-hwthread-cpus",
           python3, "-m", "mpi4py.run", "-m", "mpi4py.bench", "ringtest", "-l", "10", "-n", "1024"
  end
end
