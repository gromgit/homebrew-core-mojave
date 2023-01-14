class Mist < Formula
  desc "Mac command-line tool that automatically downloads macOS Firmwares / Installers"
  homepage "https://github.com/ninxsoft/mist-cli"
  url "https://github.com/ninxsoft/mist-cli/archive/refs/tags/v1.10.tar.gz"
  sha256 "c40ae66b84ab20998794a2e6d5e94e71afc65a4b3f9b4417babb2f34cd09608b"
  license "MIT"
  head "https://github.com/ninxsoft/mist-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc508927c1bdda99abe23778eac259286e54a7f36ccd0c76ed02821440261b9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b81d11c1a272ed78fc7dfd4c476d34d3f4e46184232e33013e83cfa917b937fc"
    sha256 cellar: :any_skip_relocation, ventura:        "6772980dd498a6b6ff21ad5541257c51f9eba540a3b252908ebc3b63a8a0f4db"
    sha256 cellar: :any_skip_relocation, monterey:       "1b55c65fcc47bc62c4ca6700610a4722a350deb69a1126cea19dce2b6dfd0765"
  end

  # Mist requires Swift 5.7
  depends_on xcode: ["14.0", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/mist"
  end

  test do
    # basic usage output
    assert_match "-h, --help", shell_output("#{bin}/mist").strip

    # check we can export the output list
    out = testpath/"out.json"
    system bin/"mist", "list", "firmware", "--quiet", "--export=#{out}", "--output-type=json"
    assert_predicate out, :exist?

    # check that it's parseable JSON in the format we expect
    parsed = JSON.parse(File.read(out))
    assert_kind_of Array, parsed
  end
end
