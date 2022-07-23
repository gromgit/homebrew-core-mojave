class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.29.1.tar.gz"
  sha256 "7cf67f1359ac042ed98420933408dbbbfff39d27021c086d271ee2cf6301b15c"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dub"
    sha256 cellar: :any_skip_relocation, mojave: "1ef2d283f02ef24216ef6859eb0b56c2abdecc88ecb2fd0d0199136dba80f669"
  end

  depends_on "ldc" => :build
  depends_on "pkg-config"

  uses_from_macos "curl"

  def install
    ENV["GITVER"] = version.to_s
    system "ldc2", "-run", "./build.d"
    system "bin/dub", "scripts/man/gen_man.d"
    bin.install "bin/dub"
    man1.install Dir["scripts/man/*.1"]
    zsh_completion.install "scripts/zsh-completion/_dub"
    fish_completion.install "scripts/fish-completion/dub.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
