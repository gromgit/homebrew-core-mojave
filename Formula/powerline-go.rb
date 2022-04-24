class PowerlineGo < Formula
  desc "Beautiful and useful low-latency prompt for your shell"
  homepage "https://github.com/justjanne/powerline-go"
  url "https://github.com/justjanne/powerline-go/archive/v1.22.1.tar.gz"
  sha256 "f47f31c864bd0389088bb739ecbf7c104b4580f8d4f9143282b7c4158dc53c96"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/powerline-go"
    sha256 cellar: :any_skip_relocation, mojave: "0e762fcfb63ef0b3ca82c72a13c7d7bd118bf931d0de0cc28d9cc28529ac33d9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args
  end

  test do
    system "#{bin}/#{name}"
  end
end
