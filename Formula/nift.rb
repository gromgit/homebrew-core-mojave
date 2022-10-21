class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.dev/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.4.12.tar.gz"
  sha256 "7a28987114cd5e4717b31a96840c0be505d58a07e20dcf26b25add7dbdf2668b"
  license "MIT"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nift"
    sha256 cellar: :any, mojave: "e5dc141b9dfe38fc39f28fa79c56dbdbda1339daca14dea88f22af7d18b3ecf4"
  end

  depends_on "luajit"

  # Fix build on Apple Silicon by removing -pagezero_size/-image_base flags.
  # TODO: Remove if upstream PR is merged and included in release.
  # PR ref: https://github.com/nifty-site-manager/nsm/pull/33
  patch do
    url "https://github.com/nifty-site-manager/nsm/commit/00b3ef1ea5ffe2dedc501f0603d16a9a4d57d395.patch?full_index=1"
    sha256 "c05f0381feef577c493d3b160fc964cee6aeb3a444bc6bde70fda4abc96be8bf"
  end

  def install
    inreplace "Lua.h", "/usr/local/include", Formula["luajit"].opt_include
    system "make", "BUNDLED=0", "LUAJIT_VERSION=2.1"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    mkdir "empty" do
      system "#{bin}/nsm", "init", ".html"
      assert_predicate testpath/"empty/output/index.html", :exist?
    end
  end
end
