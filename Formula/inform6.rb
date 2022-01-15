class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.35-r8.tar.gz"
  version "6.35-r8"
  sha256 "a1babb9ac9fc68fc397905ba713f0651e16cade77f828d692f8f91195daa0f57"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/inform6"
    sha256 cellar: :any_skip_relocation, mojave: "a60c75f6df29c41f7be53ae90b3c2d38940b02fd1eecedd4bb64aa99907d9463"
  end

  resource "homebrew-test_resource" do
    url "https://inform-fiction.org/examples/Adventureland/Adventureland.inf"
    sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
  end

  def install
    # Parallel install fails because of: https://gitlab.com/DavidGriffith/inform6unix/-/issues/26
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "MANDIR=#{man1}", "install"
  end

  test do
    resource("homebrew-test_resource").stage do
      system "#{bin}/inform", "Adventureland.inf"
      assert_predicate Pathname.pwd/"Adventureland.z5", :exist?
    end
  end
end
