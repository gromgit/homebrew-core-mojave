class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "http://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.19.1/gearmand-1.1.19.1.tar.gz"
  sha256 "8ea6e0d16a0c924e6a65caea8a7cd49d3840b9256d440d991de4266447166bfb"
  license "BSD-3-Clause"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gearman"
    sha256 cellar: :any, mojave: "c09ab7e72a487c1b895d11f3889a44a30b988bcbc5b6289a1b29a22b8503313c"
  end

  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "libmemcached"

  uses_from_macos "gperf" => :build
  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux" # for libuuid
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    # encountered when trying to detect boost regex in configure
    if MacOS.version == :high_sierra
      ENV.delete("HOMEBREW_SDKROOT")
      ENV.delete("SDKROOT")
    end

    # https://bugs.launchpad.net/gearmand/+bug/1368926
    Dir["tests/**/*.cc", "libtest/main.cc"].each do |test_file|
      next unless /std::unique_ptr/.match?(File.read(test_file))

      inreplace test_file, "std::unique_ptr", "std::auto_ptr"
    end

    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-cyassl
      --disable-hiredis
      --disable-libdrizzle
      --disable-libpq
      --disable-libtokyocabinet
      --disable-ssl
      --enable-libmemcached
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-memcached=#{Formula["memcached"].opt_bin}/memcached
      --with-sqlite3
      --without-mysql
      --without-postgresql
    ]

    ENV.append_to_cflags "-DHAVE_HTONLL"

    (var/"log").mkpath
    system "./configure", *args
    system "make", "install"
  end

  service do
    run opt_sbin/"gearmand"
  end

  test do
    assert_match(/gearman\s*Error in usage/, shell_output("#{bin}/gearman --version 2>&1", 1))
  end
end
