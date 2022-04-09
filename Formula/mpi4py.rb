class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/3.1.3/mpi4py-3.1.3.tar.gz"
  sha256 "f1e9fae1079f43eafdd9f817cdb3fd30d709edc093b5d5dada57a461b2db3008"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mpi4py"
    rebuild 2
    sha256 cellar: :any, mojave: "5d4e2632138c12f613ea30f8ef47e79516477652024698c646968eb8e62568ee"
  end

  depends_on "libcython" => :build
  depends_on "open-mpi"
  depends_on "python@3.9"

  def install
    system "#{Formula["python@3.9"].opt_bin}/python3",
           *Language::Python.setup_install_args(libexec)

    system Formula["python@3.9"].bin/"python3", "setup.py",
      "build", "--mpicc=mpicc -shared", "--parallel=#{ENV.make_jobs}",
      "install", "--prefix=#{prefix}",
      "--single-version-externally-managed", "--record=installed.txt"
  end

  test do
    python = Formula["python@3.9"].opt_bin/"python3"

    system python, "-c", "import mpi4py"
    system python, "-c", "import mpi4py.MPI"
    system python, "-c", "import mpi4py.futures"

    system "mpiexec", "-n", ENV.make_jobs, "--use-hwthread-cpus",
           python, "-m", "mpi4py.run", "-m", "mpi4py.bench", "helloworld"
    system "mpiexec", "-n", ENV.make_jobs, "--use-hwthread-cpus",
           python, "-m", "mpi4py.run", "-m", "mpi4py.bench", "ringtest", "-l", "10", "-n", "1024"
  end
end
