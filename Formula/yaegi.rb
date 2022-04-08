class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.11.2.tar.gz"
  sha256 "7db575cc00cd01fc1e9c3bb7d00bf535ae54654d245bf994acd89eef810c94f6"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/yaegi"
    sha256 cellar: :any_skip_relocation, mojave: "b73a849666e70f45cbfca6465849c0ed2504d7fd8f3e07b27311c8a020a29c73"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
