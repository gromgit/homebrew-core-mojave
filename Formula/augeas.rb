class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "https://augeas.net/"
  license "LGPL-2.1"
  head "https://github.com/hercules-team/augeas.git", branch: "master"

  stable do
    url "https://github.com/hercules-team/augeas/releases/download/release-1.13.0/augeas-1.13.0.tar.gz"
    sha256 "5002f33f42365ab78be974609a0f3b76a4c277fc404ec79f516305cab5ce5de1"

    # Replace deprecated 'security_context_t' with 'char *'. Remove in the next release.
    patch do
      url "https://github.com/hercules-team/augeas/commit/f38398a2d07028b892eac59449a35e1a3d645fac.patch?full_index=1"
      sha256 "1697379e0676edf94346a3377a75c871d1d0d033e3a37a29d69ae66f6e57553a"
    end
  end

  livecheck do
    url "http://download.augeas.net/"
    regex(/href=.*?augeas[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/augeas"
    sha256 mojave: "88ec30b7300b2e079d830c6048973793503d0817286bf9cc47c0b85e76f8fb24"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  uses_from_macos "libxml2"

  def install
    if build.head?
      system "./autogen.sh", *std_configure_args
    else
      # autoreconf is needed to work around
      # https://debbugs.gnu.org/cgi/bugreport.cgi?bug=44605.
      system "autoreconf", "--force", "--install"
      system "./configure", *std_configure_args
    end

    system "make", "install"
  end

  def caveats
    <<~EOS
      Lenses have been installed to:
        #{HOMEBREW_PREFIX}/share/augeas/lenses/dist
    EOS
  end

  test do
    system bin/"augtool", "print", etc
  end
end
