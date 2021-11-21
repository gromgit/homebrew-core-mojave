class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.35-r5.tar.gz"
  version "6.35-r5"
  sha256 "4c5aa421b1c8c944e43142e1cb6b3c1e5ad7b03589fa470ce3734298ae61eaa8"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/inform6"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "87211f072d4b0546a1b2e84c8ba9f75651ae5479f4107dcd06a2b2fa49d0a497"
  end

  resource "test_resource" do
    url "https://inform-fiction.org/examples/Adventureland/Adventureland.inf"
    sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
  end

  def install
    # Parallel install fails because of: https://gitlab.com/DavidGriffith/inform6unix/-/issues/26
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "MANDIR=#{man1}", "install"
  end

  test do
    resource("test_resource").stage do
      system "#{bin}/inform", "Adventureland.inf"
      assert_predicate Pathname.pwd/"Adventureland.z5", :exist?
    end
  end
end
