class Mtr < Formula
  desc "'traceroute' and 'ping' in a single tool"
  homepage "https://www.bitwizard.nl/mtr/"
  url "https://github.com/traviscross/mtr/archive/v0.94.tar.gz"
  sha256 "ea036fdd45da488c241603f6ea59a06bbcfe6c26177ebd34fff54336a44494b8"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/traviscross/mtr.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mtr"
    sha256 cellar: :any, mojave: "15ffd097dd7ce12c427009c8a84db23a74167e59521a1280aa9328b0d9cf5b6d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"

  def install
    # Fix UNKNOWN version reported by `mtr --version`.
    inreplace "configure.ac",
              "m4_esyscmd([build-aux/git-version-gen .tarball-version])",
              version.to_s

    # We need to add this because nameserver8_compat.h has been removed in Snow Leopard
    ENV["LIBS"] = "-lresolv"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-glib
      --without-gtk
    ]
    system "./bootstrap.sh"
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      mtr requires root privileges so you will need to run `sudo mtr`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    # We patch generation of the version, so let's check that we did that properly.
    assert_match "mtr #{version}", shell_output("#{sbin}/mtr --version")
    # mtr will not run without root privileges
    assert_match "Failure to open", shell_output("#{sbin}/mtr google.com 2>&1", 1)
    # Check that the `--json` flag is recognised.
    assert_match "Failure to open", shell_output("#{sbin}/mtr --json google.com 2>&1", 1)
  end
end
