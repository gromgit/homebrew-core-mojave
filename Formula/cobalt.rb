class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.18.0.tar.gz"
  sha256 "1ecab64da429ab362fa2c1eced7b1bb91bae0c3d144808db82d7410059099aff"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cobalt"
    sha256 cellar: :any_skip_relocation, mojave: "df5bcf36302fe3a3097e9adaaa41bb6073bcd05a9ec473338b0d2ee7f7f51e52"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
