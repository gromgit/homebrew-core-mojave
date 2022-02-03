class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.28.tar.gz"
  sha256 "6dd0303998e70066d36905bd8fef1c01228ea182dbfbabc6c22ebacdbf8b5941"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mysql-client"
    sha256 mojave: "e550862703ebbf0a1d97fc125595a56f909588811ed6aff1a97878b300605d3c"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libfido2"
  # GCC is not supported either, so exclude for El Capitan.
  depends_on macos: :sierra if DevelopmentTools.clang_build_version < 900
  depends_on "openssl@1.1"
  depends_on "zstd"

  uses_from_macos "libedit"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DFORCE_INSOURCE_BUILD=1
      -DCOMPILATION_COMMENT=Homebrew
      -DDEFAULT_CHARSET=utf8mb4
      -DDEFAULT_COLLATION=utf8mb4_general_ci
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_BOOST=boost
      -DWITH_EDITLINE=system
      -DWITH_FIDO=system
      -DWITH_LIBEVENT=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
      -DWITH_SSL=yes
      -DWITH_UNIT_TESTS=OFF
      -DWITHOUT_SERVER=ON
    ]

    # Their CMake macros check for `pkg-config` only on Linux and FreeBSD,
    # so let's set `MY_PKG_CONFIG_EXECUTABLE` and `PKG_CONFIG_*` to make
    # sure `pkg-config` is found and used.
    if OS.mac?
      args += %W[
        -DMY_PKG_CONFIG_EXECUTABLE=pkg-config
        -DPKG_CONFIG_FOUND=TRUE
        -DPKG_CONFIG_VERSION_STRING=#{Formula["pkg-config"].version}
        -DPKG_CONFIG_EXECUTABLE=#{Formula["pkg-config"].opt_bin}/pkg-config
      ]

      if ENV["HOMEBREW_SDKROOT"].present?
        args << "-DPKG_CONFIG_ARGN=--define-variable=homebrew_sdkroot=#{ENV["HOMEBREW_SDKROOT"]}"
      end
    end

    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end
