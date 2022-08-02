class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      tag:      "v2.0.11",
      revision: "225927b9a25f0d50ea63ea18bc7bb68e404c0cfd"
  license "MIT"
  head "https://github.com/zyedidia/micro.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/micro"
    sha256 cellar: :any_skip_relocation, mojave: "d6b5537f44d2a2f43b593476d36ef2db85c1124a483ba04b1d5bc427d2b41625"
  end

  depends_on "go" => :build

  def install
    system "make", "build-tags"
    bin.install "micro"
    man1.install "assets/packaging/micro.1"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
