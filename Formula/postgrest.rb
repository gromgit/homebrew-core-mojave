class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/v9.0.1.tar.gz"
  sha256 "45ea15e617c209fffbbff90d90f55237cd15d62a4600d1bf86c87693fb973702"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/postgrest"
    sha256 cellar: :any, mojave: "63ec6748e7c7c3277d0cb9087f44d7630d1061e9e1617fda88625bd32ed07184"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "postgresql"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end
