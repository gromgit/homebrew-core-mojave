class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.11.0.tar.gz"
  sha256 "532b4ab12e3e3d808d215b43e65ae225e1030f71c76e2418ab03eda83c36ded6"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/yaegi"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "44cda772c0b82ebbdc929dde1375281187a917205cb5160b40a7038607f8ba84"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
