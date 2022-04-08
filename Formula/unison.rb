class Unison < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/v2.52.0.tar.gz"
  sha256 "a11389971212915328fe69101c92737b17664595c4318ebcb8da367e5ba63540"
  license "GPL-3.0-or-later"
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
  # release candidates), so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/unison"
    sha256 cellar: :any_skip_relocation, mojave: "f766c5086ddc9eb3fca774ebb8232c17ac92aff526ff7773e73a3ebb4f2687a6"
  end

  depends_on "ocaml" => :build

  def install
    ENV.deparallelize
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
    system "make", "UISTYLE=text"
    bin.install "src/unison"
    prefix.install_metafiles "src"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unison -version")
  end
end
