class Mongrel2 < Formula
  desc "Application, language, and network architecture agnostic web server"
  homepage "https://mongrel2.org/"
  url "https://github.com/mongrel2/mongrel2/releases/download/v1.13.0/mongrel2-v1.13.0.tar.bz2"
  sha256 "b6f1f50c9f65b605342d8792b1cc8a1c151105339030313b9825b6a68d400c10"
  license "BSD-3-Clause"
  head "https://github.com/mongrel2/mongrel2.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mongrel2"
    sha256 cellar: :any, mojave: "05f6d21b99d29a26e683b4d7cbac9460218f83a296305391ae23bf3226726b53"
  end

  depends_on "zeromq"

  uses_from_macos "sqlite"

  # Fix src/server.c:185:23: error: #elif with no expression
  # PR ref: https://github.com/mongrel2/mongrel2/pull/358
  patch do
    url "https://github.com/mongrel2/mongrel2/commit/d6c38361cb31a3de8ddfc3e8a3971330a40eb241.patch?full_index=1"
    sha256 "52afa21830d5e3992136c113c5a54ad55cccc07f763ab7532f7ba122140b3e6b"
  end

  def install
    # Build in serial. See:
    # https://github.com/Homebrew/homebrew/issues/8719
    ENV.deparallelize

    # Mongrel2 pulls from these ENV vars instead
    ENV["OPTFLAGS"] = "#{ENV.cflags} #{ENV.cppflags}"
    ENV["OPTLIBS"] = ENV.ldflags
    if OS.mac?
      ENV.append "OPTFLAGS", "-DHAS_ARC4RANDOM"
      ENV.append "OPTLIBS", "-undefined dynamic_lookup"
    end

    # The Makefile now uses system mbedtls, but `make` fails during filter_tests.
    # As workaround, use previous localmbedtls.mak that builds with bundled mbedtls.
    # Issue ref: https://github.com/mongrel2/mongrel2/issues/342
    system "make", "-f", "localmbedtls.mak", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"m2sh", "help"
  end
end
