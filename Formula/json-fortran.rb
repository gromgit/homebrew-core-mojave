class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/8.3.0.tar.gz"
  sha256 "5fe9ad709a726416cec986886503e0526419742e288c4e43f63c1c22026d1e8a"
  license "BSD-3-Clause"
  head "https://github.com/jacobwilliams/json-fortran.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/json-fortran"
    sha256 cellar: :any, mojave: "cc3f057c63f6c30a053dcb342b284e6cd59708f0070b560674c2e38bf8ea27d1"
  end

  depends_on "cmake" => :build
  depends_on "ford" => :build
  depends_on "gcc" # for gfortran

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DUSE_GNU_INSTALL_CONVENTION:BOOL=TRUE",
                            "-DENABLE_UNICODE:BOOL=TRUE"
      system "make", "install"
    end
  end

  test do
    (testpath/"json_test.f90").write <<~EOS
      program example
      use json_module, RK => json_RK
      use iso_fortran_env, only: stdout => output_unit
      implicit none
      type(json_core) :: json
      type(json_value),pointer :: p, inp
      call json%initialize()
      call json%create_object(p,'')
      call json%create_object(inp,'inputs')
      call json%add(p, inp)
      call json%add(inp, 't0', 0.1_RK)
      call json%print(p,stdout)
      call json%destroy(p)
      if (json%failed()) error stop 'error'
      end program example
    EOS
    system "gfortran", "-o", "test", "json_test.f90", "-I#{include}",
                       "-L#{lib}", "-ljsonfortran"
    system "./test"
  end
end
