class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.18.0.tar.gz"
  sha256 "7a282d9eff88bb2e224b02d80b887de92286e451abf8a193248d30136d08f4e0"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/angle-grinder"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "60c5c7526f3ef8d6a182ab7d696755fe90d88768e8e836e2eb8c01a353267a72"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end
