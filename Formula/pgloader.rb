class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/releases/download/v3.6.6/pgloader-bundle-3.6.6.tgz"
  sha256 "1837565d8fcedb132c68885a40893ec3c590b7da9ebcef1c0e580b19f353544d"
  license "PostgreSQL"
  head "https://github.com/dimitri/pgloader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pgloader"
    sha256 cellar: :any, mojave: "37c2039406b2f939693d9808baad9d4926bd529643c63226258fc64fe17d6592"
  end

  depends_on "buildapp" => :build
  depends_on "freetds"
  depends_on "openssl@1.1"
  depends_on "postgresql"
  depends_on "sbcl"

  def install
    system "make"
    bin.install "bin/pgloader"
  end
end
