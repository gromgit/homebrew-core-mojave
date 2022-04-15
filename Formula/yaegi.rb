class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.11.3.tar.gz"
  sha256 "46e73955145cd829e41a906677edfcd78846862ca0274770dd4668dda2a949c1"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/yaegi"
    sha256 cellar: :any_skip_relocation, mojave: "38b33752fb52a21e61afc444323904912a63921158f3e820945a44684cd4dc12"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
