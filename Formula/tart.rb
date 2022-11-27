class Tart < Formula
  desc "macOS and Linux VMs on Apple Silicon to use in CI and other automations"
  homepage "https://github.com/cirruslabs/tart"
  url "https://github.com/cirruslabs/tart/archive/refs/tags/0.35.0.tar.gz"
  sha256 "a7c16318d70c4d8b418e253da8ab8b024bdc9f71f08721dfbbb8cbb251a87e0a"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87589f6dbefeebcf0db61407fbf652754ce0d761754622b0fec5f0e35d70ee3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81b374095aa9a1ac6012a4c3df29dc0179aa7ab72dbc60c246513b9816a735a6"
  end

  depends_on "rust" => :build
  depends_on xcode: ["14.1", :build]
  depends_on arch: :arm64
  depends_on macos: :monterey
  depends_on :macos

  uses_from_macos "swift"

  resource "softnet" do
    url "https://github.com/cirruslabs/softnet/archive/refs/tags/0.3.2.tar.gz"
    sha256 "7bdb4c4c1996257769f11fb1b17d50954bc083c0155cb1509ad30bd8f304ee76"
  end

  def install
    resource("softnet").stage do
      system "cargo", "install", *std_cargo_args
    end
    system "swift", "build", "--disable-sandbox", "-c", "release"
    system "/usr/bin/codesign", "-f", "-s", "-", "--entitlement", "Resources/tart.entitlements", ".build/release/tart"
    bin.install ".build/release/tart"
  end

  test do
    ENV["TART_HOME"] = testpath/".tart"
    (testpath/"empty.ipsw").write ""
    output = shell_output("tart create --from-ipsw #{testpath/"empty.ipsw"} test", 1)
    assert_match "Unable to load restore image", output
  end
end
