class Pev < Formula
  desc "PE analysis toolkit"
  homepage "https://pev.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pev/pev-0.81/pev-0.81.tar.gz"
  sha256 "4192691c57eec760e752d3d9eca2a1322bfe8003cfc210e5a6b52fca94d5172b"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/merces/pev.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pev"
    sha256 mojave: "a2139d5b3bdd40a0077a45c298c15c6c6d1bf6efa5550a183490c793aa078f57"
  end

  deprecate! date: "2022-02-28", because: :repo_archived

  depends_on "openssl@1.1"

  # Remove -flat_namespace.
  patch do
    url "https://github.com/merces/pev/commit/8169e6e9bbc4817ac1033578c2e383dc7f419106.patch?full_index=1"
    sha256 "015035b34e5bed108b969ecccd690019eaa2f837c0880fa589584cb2f7ede7c0"
  end

  # Make builds reproducible.
  patch do
    url "https://github.com/merces/pev/commit/cbcd9663ba9a5f903d26788cf6e86329fd513220.patch?full_index=1"
    sha256 "8f047c8db01d3a5ef5905ce05d8624ff7353e0fab5b6b00aa877ea6a3baaadcc"
  end

  def install
    ENV.deparallelize
    system "make", "prefix=#{prefix}", "CC=#{ENV.cc}"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "#{bin}/pedis", "--version"
  end
end
