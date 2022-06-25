class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-4.2.2.tar.gz"
  sha256 "77c12d80bb76fe774b16996e6bac6d4ad950070d0816c3409dc0397dfc62725f"
  license "ISC"
  revision 2
  head "https://github.com/jorisvink/kore.git", branch: "master"

  livecheck do
    url "https://kore.io/source"
    regex(/href=.*?kore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kore"
    sha256 mojave: "d07dfb5a6a7a8fb7e0e1b983d0625934eaf52b4bc658bef22a6998b3ca920276"
  end

  depends_on "pkg-config" => :build
  depends_on macos: :sierra # needs clock_gettime
  depends_on "openssl@1.1"

  def install
    ENV.deparallelize { system "make", "PREFIX=#{prefix}", "TASKS=1" }
    system "make", "install", "PREFIX=#{prefix}"

    # Remove openssl cellar references, which breaks kore on openssl updates
    openssl = Formula["openssl@1.1"]
    inreplace [pkgshare/"features", pkgshare/"linker"], openssl.prefix.realpath, openssl.opt_prefix if OS.mac?
  end

  test do
    system bin/"kodev", "create", "test"
    cd "test" do
      system bin/"kodev", "build"
      system bin/"kodev", "clean"
    end
  end
end
