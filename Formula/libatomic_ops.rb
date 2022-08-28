class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.6.14/libatomic_ops-7.6.14.tar.gz"
  sha256 "390f244d424714735b7050d056567615b3b8f29008a663c262fb548f1802d292"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libatomic_ops"
    sha256 cellar: :any_skip_relocation, mojave: "ad16a7ede10eb338b3dcbad102bf8afe3925c7d05ff05742e4de20d81edae64d"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
