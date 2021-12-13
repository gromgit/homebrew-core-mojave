class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.11.1/sleuthkit-4.11.1.tar.gz"
  sha256 "8ad94f5a69b7cd1a401afd882ab6b8e5daadb39dd2a6a3bbd5aecee2a2ea57a0"
  license all_of: ["IPL-1.0", "CPL-1.0", "GPL-2.0-or-later"]

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/sleuthkit[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sleuthkit"
    rebuild 2
    sha256 cellar: :any, mojave: "d7fc660493b94b16c2744ca89f563b4bf1c3be5274b606b5b0a73c7acedadb76"
  end

  depends_on "ant" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on "libpq"
  depends_on "openjdk"

  uses_from_macos "sqlite"

  conflicts_with "ffind", because: "both install a `ffind` executable"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    ENV["ANT_FOUND"] = Formula["ant"].opt_bin/"ant"
    ENV.append_to_cflags "-DNDEBUG"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"

    cd "bindings/java" do
      system "ant"

      inreplace ["Makefile", "jni/Makefile"], Superenv.shims_path/"ld", "ld" if OS.linux?
    end
    prefix.install "bindings"
  end

  test do
    system "#{bin}/tsk_loaddb", "-V"
  end
end
