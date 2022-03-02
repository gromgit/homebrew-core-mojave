class ElixirBuild < Formula
  desc "Elixir version of ruby-build"
  homepage "https://github.com/mururu/elixir-build"
  url "https://github.com/mururu/elixir-build/archive/v20141001.tar.gz"
  sha256 "825637780a580b7ebe8c5265a43d37ceff9f3876e771aa2f824079e504ad7347"
  license "MIT"
  head "https://github.com/mururu/elixir-build.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/elixir-build"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "6d16e3510b6111c6ae643794f7fe5167add0480050f4ea342d4754d697051c05"
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
