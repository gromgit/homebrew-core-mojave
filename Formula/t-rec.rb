class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/v0.7.0.tar.gz"
  sha256 "f5830896bd8829061619916af5400a3a5fa974ab88d2c6631094116bd11e48a1"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/t-rec"
    sha256 cellar: :any_skip_relocation, mojave: "7280432b08a74d1bd1c9dd994c2e72e204c362795d7bfd10c16d4d5b489f2a45"
  end

  depends_on "rust" => :build
  depends_on "imagemagick"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    o = shell_output("WINDOWID=999999 #{bin}/t-rec 2>&1", 1).strip
    if OS.mac?
      assert_equal "Error: Cannot grab screenshot from CGDisplay of window id 999999", o
    else
      assert_equal "Error: Display parsing error", o
    end
  end
end
