class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.10.3.tar.gz"
  sha256 "39c5f8f88a8aa6d32575ddb26017572f2683fae129b9be5442acbae74019ea5e"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/starship"
    sha256 cellar: :any_skip_relocation, mojave: "1c07972f583ec7cce5b54354591816159ec636b5f4b8a7879a3729c2a2b98ec7"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"starship", "completions")
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
