class Cproto < Formula
  desc "Generate function prototypes for functions in input files"
  homepage "https://invisible-island.net/cproto/"
  url "https://invisible-mirror.net/archives/cproto/cproto-4.7u.tgz"
  mirror "https://deb.debian.org/debian/pool/main/c/cproto/cproto_4.7u.orig.tar.gz"
  sha256 "64ebbbcc5e0501aff296f431d06f9fb70863afe5b0ce66c3b3479072914fc51e"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/cproto/"
    regex(/href=.*?cproto[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cproto"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "880c94a64f3bc868d623f27a768524fdcea4d309e5d057b89477c8087375a777"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"woot.c").write("int woot() {\n}")
    assert_match(/int woot.void.;/, shell_output("#{bin}/cproto woot.c"))
  end
end
