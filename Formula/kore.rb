class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-4.2.3.tar.gz"
  sha256 "f9a9727af97441ae87ff9250e374b9fe3a32a3348b25cb50bd2b7de5ec7f5d82"
  license "ISC"
  head "https://github.com/jorisvink/kore.git", branch: "master"

  livecheck do
    url "https://kore.io/source"
    regex(/href=.*?kore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kore"
    sha256 mojave: "e3e44760247e590aec37b53d1bb99b2901efba2756dd92f48904ff426012ae4e"
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
