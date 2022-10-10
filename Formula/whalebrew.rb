class Whalebrew < Formula
  desc "Homebrew, but with Docker images"
  homepage "https://github.com/whalebrew/whalebrew"
  url "https://github.com/whalebrew/whalebrew.git",
      tag:      "0.4.0",
      revision: "bdf94887abf0397341c1d241974eea790626ae7c"
  license "Apache-2.0"
  head "https://github.com/whalebrew/whalebrew.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/whalebrew"
    sha256 cellar: :any_skip_relocation, mojave: "2822de077dff27810c5171e8c18097171be75c98f4b57fff51df05b8fb214289"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/whalebrew install whalebrew/whalesay -y", 255)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
