class Mdzk < Formula
  desc "Plain text Zettelkasten based on mdBook"
  homepage "https://mdzk.app/"
  url "https://github.com/mdzk-rs/mdzk/archive/0.5.2.tar.gz"
  sha256 "292a0ae7b91d535ffa1cfd3649d903b75a1bb1604abc7d98202f3e13e97de702"
  license "MPL-2.0"
  head "https://github.com/mdzk-rs/mdzk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mdzk"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "32c3f8c41c104cbdf5b2d85bbd09c5c2457707896526c0c302bdbbae21667ca4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/mdzk", "init", "test_mdzk"
    assert_predicate testpath/"test_mdzk", :exist?
  end
end
