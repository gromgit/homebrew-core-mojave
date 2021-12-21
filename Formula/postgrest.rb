class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/v9.0.0.tar.gz"
  sha256 "14ce20a0e4eb12f7cacb73360c3d40c837a4007d94b7a82f5a586f34587bf233"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/postgrest"
    sha256 cellar: :any, mojave: "8c4b3ffe272ed91c846b448b2118d8e1ae9f5ecd940d910722a23db95b1fa68b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "postgresql"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end
