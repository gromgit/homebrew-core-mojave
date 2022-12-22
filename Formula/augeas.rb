class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "https://augeas.net/"
  license "LGPL-2.1-or-later"
  head "https://github.com/hercules-team/augeas.git", branch: "master"

  # Remove stable block when patch is no longer needed.
  stable do
    url "https://github.com/hercules-team/augeas/releases/download/release-1.14.0/augeas-1.14.0.tar.gz"
    sha256 "8c101759ca3d504bd1d805e70e2f615fa686af189dd7cf0529f71d855c087df1"

    # Fix "fatal error: 'malloc.h' file not found".
    # Remove when https://github.com/hercules-team/augeas/pull/792 is merged.
    patch do
      url "https://github.com/hercules-team/augeas/commit/6cc785a46f2c651a299549eab25c6476c39f3080.patch?full_index=1"
      sha256 "754beea4f75e6ada6a6093a41f8071d18e067f9d60137b135a4188a6e3a80227"
    end
  end

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/\D*?(\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/augeas"
    sha256 mojave: "b97544646269b12da6c09467047e0fe1773b8ab1967b497d5859f1d702792af1"
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
