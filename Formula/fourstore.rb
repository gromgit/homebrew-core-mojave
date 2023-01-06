class Fourstore < Formula
  desc "Efficient, stable RDF database"
  homepage "https://github.com/4store/4store"
  # NOTE: Try building without `avahi` at version bump.
  url "https://github.com/4store/4store/archive/v1.1.6.tar.gz"
  sha256 "a0c8143fcceeb2f1c7f266425bb6b0581279129b86fdd10383bf1c1e1cab8e00"
  license "GPL-3.0"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fourstore"
    rebuild 1
    sha256 mojave: "7ec2e4cffdd92f0af3a365efdfc324229120f4b8b94677d005e8aecb633f7ac6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "dbus"
  depends_on "gettext"
  depends_on "glib"
  depends_on "pcre"
  depends_on "raptor"
  depends_on "rasqal"
  depends_on "readline"

  # TODO: Check if this dependency can be removed at version bump.
  on_linux do
    depends_on "avahi"
  end

  # Fix build on Linux. Remove on the next release
  # sigval_t.h:13:3: error: #error "sigval_t defined for standard not including union sigval"
  patch do
    on_linux do
      url "https://github.com/4store/4store/commit/c5a56d7c7504551a1f2fff6c16c4d9a440e4a317.patch?full_index=1"
      sha256 "f476aa38098aaaebf970603a5003aae40fa43f3243890e404f799be8bdbf0aad"
    end
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # /usr/bin/ld: query.o:(.bss+0x0): multiple definition of `rasqal_mutex'
    ENV.append_to_cflags "-fcommon" if OS.linux?
    # Upstream issue garlik/4store#138
    # Otherwise .git directory is needed
    (buildpath/".version").write("v1.1.6")

    system "./autogen.sh"
    (var/"fourstore").mkpath
    system "./configure", "--prefix=#{prefix}",
                          "--with-storage-path=#{var}/fourstore",
                          "--sysconfdir=#{etc}/fourstore"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Databases will be created at #{var}/fourstore.

      Create and start up a database:
          4s-backend-setup mydb
          4s-backend mydb

      Load RDF data:
          4s-import mydb datafile.rdf

      Start up HTTP SPARQL server without daemonizing:
          4s-httpd -p 8000 -D mydb

      See https://4store.danielknoell.de/trac/wiki/Documentation/ for more information.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/4s-admin --version")
  end
end
