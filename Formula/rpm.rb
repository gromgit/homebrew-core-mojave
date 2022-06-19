class Rpm < Formula
  desc "Standard unix software packaging tool"
  homepage "https://rpm.org/"
  url "http://ftp.rpm.org/releases/rpm-4.17.x/rpm-4.17.0.tar.bz2"
  mirror "https://ftp.osuosl.org/pub/rpm/releases/rpm-4.17.x/rpm-4.17.0.tar.bz2"
  sha256 "2e0d220b24749b17810ed181ac1ed005a56bbb6bc8ac429c21f314068dc65e6a"
  license "GPL-2.0-only"
  revision 1
  version_scheme 1

  livecheck do
    url "https://rpm.org/download.html"
    regex(/href=.*?rpm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rpm"
    rebuild 1
    sha256 mojave: "a40c2875be9908ca85b79e5ad3ca9b7db37d48e3d72272bad369d07edd848d15"
  end

  # We need autotools for the Lua patch below. Remove when the patch is no longer needed.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gettext"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "popt"
  depends_on "sqlite"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  # Fix `fstat64` detection for Apple Silicon.
  # https://github.com/rpm-software-management/rpm/pull/1775
  # https://github.com/rpm-software-management/rpm/pull/1897
  if Hardware::CPU.arm?
    patch do
      url "https://github.com/rpm-software-management/rpm/commit/ad87ced3990c7e14b6b593fa411505e99412e248.patch?full_index=1"
      sha256 "a129345c6ba026b337fe647763874bedfcaf853e1994cf65b1b761bc2c7531ad"
    end
  end

  # Remove defunct Lua rex extension, which causes linking errors with Homebrew's Lua.
  # https://github.com/rpm-software-management/rpm/pull/1797/files
  patch do
    url "https://github.com/rpm-software-management/rpm/commit/83d781c442158ce61286ac68cc350d10c2d3837e.patch?full_index=1"
    sha256 "5dc9fb093ad46657575e5782d257d9b47d3c8119914283794464a84a7aef50b0"
  end

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"
    ENV.append "LDFLAGS", "-lomp" if OS.mac?

    # only rpm should go into HOMEBREW_CELLAR, not rpms built
    inreplace ["macros.in", "platform.in"], "@prefix@", HOMEBREW_PREFIX

    # ensure that pkg-config binary is found for dep generators
    inreplace "scripts/pkgconfigdeps.sh",
              "/usr/bin/pkg-config", Formula["pkg-config"].opt_bin/"pkg-config"

    # Regenerate the `configure` script, since the lua patch touches luaext/Makefile.am.
    # This also fixes the "-flat-namespace" bug. Remove `autoreconf` when the Lua patch is no longer needed.
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sharedstatedir=#{var}/lib",
                          "--sysconfdir=#{etc}",
                          "--with-path-magic=#{HOMEBREW_PREFIX}/share/misc/magic",
                          "--enable-nls",
                          "--disable-plugins",
                          "--with-external-db",
                          "--with-crypto=openssl",
                          "--without-apidocs",
                          "--with-vendor=#{tap.user.downcase}",
                          # Don't allow superenv shims to be saved into lib/rpm/macros
                          "__MAKE=/usr/bin/make",
                          "__GIT=/usr/bin/git",
                          "__LD=/usr/bin/ld",
                          # GPG is not a strict dependency, so set stored GPG location to a decent default
                          "__GPG=#{Formula["gpg"].opt_bin}/gpg"

    system "make", "install"

    # NOTE: We need the trailing `/` to avoid leaving it behind.
    inreplace lib/"rpm/macros", "#{Superenv.shims_path}/", ""
  end

  def post_install
    (var/"lib/rpm").mkpath
  end

  def test_spec
    <<~EOS
      Summary:   Test package
      Name:      test
      Version:   1.0
      Release:   1
      License:   Public Domain
      Group:     Development/Tools
      BuildArch: noarch

      %description
      Trivial test package

      %prep
      %build
      %install
      mkdir -p $RPM_BUILD_ROOT/tmp
      touch $RPM_BUILD_ROOT/tmp/test

      %files
      /tmp/test

      %changelog

    EOS
  end

  def rpmdir(macro)
    Pathname.new(`#{bin}/rpm --eval #{macro}`.chomp)
  end

  test do
    (testpath/"rpmbuild").mkpath

    (testpath/".rpmmacros").write <<~EOS
      %_topdir		#{testpath}/rpmbuild
      %_tmppath		%\{_topdir}/tmp
    EOS

    system "#{bin}/rpm", "-vv", "-qa", "--dbpath=#{testpath}/var/lib/rpm"
    assert_predicate testpath/"var/lib/rpm/rpmdb.sqlite", :exist?,
                     "Failed to create 'rpmdb.sqlite' file"
    rpmdir("%_builddir").mkpath
    specfile = rpmdir("%_specdir")+"test.spec"
    specfile.write(test_spec)
    system "#{bin}/rpmbuild", "-ba", specfile
    assert_predicate rpmdir("%_srcrpmdir")/"test-1.0-1.src.rpm", :exist?
    assert_predicate rpmdir("%_rpmdir")/"noarch/test-1.0-1.noarch.rpm", :exist?
    system "#{bin}/rpm", "-qpi", "--dbpath=#{testpath}/var/lib/rpm",
                         rpmdir("%_rpmdir")/"noarch/test-1.0-1.noarch.rpm"
  end
end
