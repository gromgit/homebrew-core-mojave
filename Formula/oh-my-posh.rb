class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.19.1.tar.gz"
  sha256 "072a9cfb17ae159a5217eae9354ffb46872884c9ae2602eb467f59166226f2cf"
  license "GPL-3.0-only"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/oh-my-posh"
    sha256 cellar: :any_skip_relocation, mojave: "54fb8b83d7063640ac65775db8211f40ad972dd19905ee135e5fa41676d9cfca"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
