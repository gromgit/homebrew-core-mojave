class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.7.7.tar.gz"
  sha256 "9b00a6680a82f5ed962e2bc46b689753ca899bd439613887754000d6a4041a88"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/youtubedr"
    sha256 cellar: :any_skip_relocation, mojave: "34b9f7f6aef9b2da4d7913ce554eae80f9c5a46e0ba07d9ce8f9a6109ab76493"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ].join(" ")

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/youtubedr"
  end

  test do
    version_output = pipe_output("#{bin}/youtubedr version").split("\n")
    assert_match(/Version:\s+#{version}/, version_output[0])

    info_output = pipe_output("#{bin}/youtubedr info https://www.youtube.com/watch\?v\=pOtd1cbOP7k").split("\n")
    assert_match "Title:       History of homebrew-core", info_output[0]
    assert_match "Author:      Rui Chen", info_output[1]
    assert_match "Duration:    13m15s", info_output[2]
  end
end
