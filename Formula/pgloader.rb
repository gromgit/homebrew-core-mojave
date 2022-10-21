class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/releases/download/v3.6.8/pgloader-bundle-3.6.8.tgz"
  sha256 "879bc1f8a39aa5b5ec49534855612c69a9f27336827e5f35f925dd88d98d6e81"
  license "PostgreSQL"
  head "https://github.com/dimitri/pgloader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pgloader"
    sha256 cellar: :any, mojave: "7a8a7db8a385f4e90b615ca13ef747e31469cc16500c47b6caa837612d7743b3"
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
