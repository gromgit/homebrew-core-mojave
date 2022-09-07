class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/releases/download/v3.6.7/pgloader-bundle-3.6.7.tgz"
  sha256 "25f1767a5d2f2630c0c81da5dc7e1d2e010882799796b094558283a63da33356"
  license "PostgreSQL"
  head "https://github.com/dimitri/pgloader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pgloader"
    sha256 cellar: :any, mojave: "f6ecca43f89e61714b2e68a1365677a0e1837f8b1affc86d7b11feaf82bc054c"
  end

  depends_on "buildapp" => :build
  depends_on "freetds"
  depends_on "libpq"
  depends_on "openssl@1.1"
  depends_on "sbcl"

  def install
    system "make"
    bin.install "bin/pgloader"
  end
end
