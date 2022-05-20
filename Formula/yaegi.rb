class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/v0.11.3.tar.gz"
  sha256 "46e73955145cd829e41a906677edfcd78846862ca0274770dd4668dda2a949c1"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/yaegi"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "622782c32ceab4c81bba224adf5445d6372c491b8bdc8cabf22c545f3f77d118"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
