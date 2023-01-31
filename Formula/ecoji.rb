class Ecoji < Formula
  desc "Encodes (and decodes) data as emojis"
  homepage "https://github.com/keith-turner/ecoji"
  url "https://github.com/keith-turner/ecoji/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "59c78ddaef057bbfb06ea8522dfc51ea8bce3e8f149a3231823a37f6de0b4ed2"
  license "Apache-2.0"
  head "https://github.com/keith-turner/ecoji.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ecoji"
    sha256 cellar: :any_skip_relocation, mojave: "b8f9f73e72937fc32456568d6b919a371fb986a902da9dd250c42375976da9ec"
  end

  depends_on "go" => :build

  def install
    cd "cmd" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
    # system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd"
  end

  test do
    text = "Base64 is so 1999"
    encoded_text = "🧏📩🧈🐇🧅📘🔯🚜💞😽♏🐊🎱🤾☕"
    assert_equal encoded_text, pipe_output("#{bin}/ecoji -e", text).chomp
    assert_equal text, pipe_output("#{bin}/ecoji -d", encoded_text).chomp
  end
end
