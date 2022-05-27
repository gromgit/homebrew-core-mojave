class Manticoresearch < Formula
  desc "Open source text search engine"
  homepage "https://www.manticoresearch.com"
  url "https://github.com/manticoresoftware/manticoresearch/archive/refs/tags/4.2.0.tar.gz"
  sha256 "6b4af70fcc56b40aa83e606240b237e47e54c0bfbfdd32c47788d59469ef7146"
  license "GPL-2.0-only"
  version_scheme 1
  head "https://github.com/manticoresoftware/manticoresearch.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/manticoresearch"
    sha256 mojave: "97f278397b51242fd4bfd9cc3cd5d02949e3f256660f3dc0d48233eb7040f058"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "libpq"
  depends_on "mysql"
  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "gcc"
  end

  conflicts_with "sphinx", because: "manticoresearch is a fork of sphinx"

  fails_with gcc: "5"

  def install
    args = %W[
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DBoost_NO_BOOST_CMAKE=ON
      -DWITH_ICU=OFF
      -DWITH_ODBC=OFF
    ]

    if OS.mac?
      args << "-DDISTR_BUILD=macosbrew"
    else
      args += %W[
        -DCMAKE_INSTALL_BINDIR=#{bin}
        -DCMAKE_INSTALL_DATAROOTDIR=#{share}
        -DCMAKE_INSTALL_INCLUDEDIR=#{include}
        -DCMAKE_INSTALL_LIBDIR=#{lib}
        -DCMAKE_INSTALL_MANDIR=#{man}
        -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      ]
    end

    # Disable support for Manticore Columnar Library on ARM (since the library itself doesn't support it as well)
    args << "-DWITH_COLUMNAR=OFF" if Hardware::CPU.arm?

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *args
      system "make", "install"
    end
  end

  def post_install
    (var/"run/manticore").mkpath
    (var/"log/manticore").mkpath
    (var/"manticore/data").mkpath
  end

  service do
    run [opt_bin/"searchd", "--config", etc/"manticore/manticore.conf", "--nodetach"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
  end

  test do
    (testpath/"manticore.conf").write <<~EOS
      searchd {
        pid_file = searchd.pid
        binlog_path=#
      }
    EOS
    pid = fork do
      exec bin/"searchd"
    end
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
