class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/spotify/XCLogParser"
  url "https://github.com/spotify/XCLogParser/archive/v0.2.21.tar.gz"
  sha256 "ee0a031bd096766046af7904595685bb154d3d3f777123615fefa4c5927f9a59"
  license "Apache-2.0"

  deprecate! date: "2021-12-24", because: "can no longer be updated under Mojave"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xclogparser"
    sha256 cellar: :any_skip_relocation, mojave: "36eccfe179576772ac5f94087f811cb1da786397216ee5852effaafd0b5ee3ab"
  end

  depends_on xcode: "11.0"

  resource "test_log" do
    url "https://github.com/tinder-maxwellelliott/XCLogParser/releases/download/0.2.9/test.xcactivitylog"
    sha256 "bfcad64404f86340b13524362c1b71ef8ac906ba230bdf074514b96475dd5dca"
  end

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/xclogparser"
  end

  test do
    resource("test_log").stage(testpath)
    shell_output = shell_output("#{bin}/xclogparser dump --file #{testpath}/test.xcactivitylog")
    match_data = shell_output.match(/"title" : "(Run custom shell script 'Run Script')"/)
    assert_equal "Run custom shell script 'Run Script'", match_data[1]
  end
end
