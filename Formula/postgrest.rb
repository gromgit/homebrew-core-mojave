class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https://github.com/PostgREST/postgrest"
  url "https://github.com/PostgREST/postgrest/archive/v10.0.0.tar.gz"
  sha256 "34e09612e8ad2f26fc6897b41ce2c260497a89425c3860be17c369ddb3229c3a"
  license "MIT"
  head "https://github.com/PostgREST/postgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/postgrest"
    sha256 cellar: :any, mojave: "23cc7e88cc2b8fab1e93bf9452adb03792bb54612814c64deb6ba4bf8dd150bb"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "libpq"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end
