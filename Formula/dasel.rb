class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.26.1.tar.gz"
  sha256 "44c90753cf4c1b6e7fb82074c6701fd4b47dc6dc26fe4e5504dcccb4d273b946"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dasel"
    sha256 cellar: :any_skip_relocation, mojave: "bb31b1605663e5aeefe675f1c969f62d718a9b260a17cf07cc61f77d27d7988d"
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
