class ElixirBuild < Formula
  desc "Elixir version of ruby-build"
  homepage "https://github.com/mururu/elixir-build"
  url "https://github.com/mururu/elixir-build/archive/v20141001.tar.gz"
  sha256 "825637780a580b7ebe8c5265a43d37ceff9f3876e771aa2f824079e504ad7347"
  license "MIT"
  head "https://github.com/mururu/elixir-build.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0f434ba340b50a81c737a8de0b167293c1ce596972fa15a9f57abc81c6f69499"
  end

  conflicts_with "narwhal", because: "both install `json` binaries"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/elixir-build", "--version"
  end
end
