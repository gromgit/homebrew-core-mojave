class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/26823/cdo-2.0.5.tar.gz"
  sha256 "edeebbf1c3b1a1f0c642dae6bc8c7624e0c54babe461064dc5c7daca4a5b0dce"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/files"
    regex(/href=.*?cdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cdo"
    sha256 cellar: :any, mojave: "f3a258fa7642556c2242fc8d0110628144a85adff448f6d4644efb74f5dc3465"
  end

  depends_on "eccodes"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "netcdf"
  depends_on "proj"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-eccodes=#{Formula["eccodes"].opt_prefix}
      --with-netcdf=#{Formula["netcdf"].opt_prefix}
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
      --with-szlib=#{Formula["libaec"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    data = <<~EOF.unpack1("m")
      R1JJQgABvAEAABz/AAD/gAEBAABkAAAAAAEAAAoAAAAAAAAAAAAgAP8AABIACgB+9IBrbIABLrwA4JwTiBOIQAAAAAAAAXQIgAPEFI2rEBm9AACVLSuNtwvRALldqDul2GV1pw1CbXsdub2q9a/17Yi9o11DE0UFWwRjqsvH80wgS82o3UJ9rkitLcPgxJDVaO9No4XV6EWNPeUSSC7txHi7/aglVaO5uKKtwr2slV5DYejEoKOwpdirLXPIGUAWCya7ntil1amLu4PCtafNp5OpPafFqVWmxaQto72sMzGQJeUxcJkbqEWnOKM9pTOlTafdqPCoc6tAq0WqFarTq2i5M1NdRq2AHWzFpFWj1aJtmAOrhaJzox2nwKr4qQWofaggqz2rkHcog2htuI2YmOB9hZDIpxXA3ahdpzOnDarjqj2k0KlIqM2oyJsjjpODmGu1YtU6WHmNZ5uljcbVrduuOK1DrDWjGKM4pQCmfdVFprWbnVd7Vw1QY1s9VnNzvZiLmGucPZwVnM2bm5yFqb2cHdRQqs2hhZrrm1VGeEQgOduhjbWrqAWfzaANnZOdWJ0NnMWeJQA3Nzc3AAAAAA==
    EOF
    File.binwrite("test.grb", data)
    system "#{bin}/cdo", "-f", "nc", "copy", "test.grb", "test.nc"
    assert_predicate testpath/"test.nc", :exist?
  end
end
