class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.22.1.tar.gz"
  sha256 "2d80f2eaa326aef1aca1e535f89d73da0642c7c5709ee51a30b972d1bdd132d1"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dasel"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "17dd52bc7e7123accfc67e29ee5206949fc83561dd67eab6135e35d841f90bc2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
