class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.16.0.tar.gz"
  sha256 "035f3508ad3954aa1117f662f9f59541e7a0059483b15d573a8146d997b54827"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/trunk"
    sha256 cellar: :any_skip_relocation, mojave: "2ecbc82d0dba8cba795df9625c9b25a4b9f03ecfe16dbd7c3f53fac8b20c89bc"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
