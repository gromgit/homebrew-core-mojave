class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.16.tar.gz"
  sha256 "289f6ab2f9b1efa655e8b3f6ed2baceb20ba4affd37194d20d4fb0bdd988c577"
  license "Apache-2.0"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mcap"
    sha256 cellar: :any_skip_relocation, mojave: "fe11be0b1a55717002e47eb8987d80818517de2337caf7b16ca5a69e2bf82684"
  end

  depends_on "go" => :build

  resource "homebrew-testdata" do
    url "https://media.githubusercontent.com/media/foxglove/mcap/releases/mcap-cli/v0.0.10/tests/conformance/data/OneMessage/OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap"
    sha256 "9db644f7fad2a256b891946a011fb23127b95d67dc03551b78224aa6cad8c5db"
  end

  def install
    cd "go/cli/mcap" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "bin/mcap"
    end
  end

  test do
    assert_equal "v#{version}", pipe_output("#{bin}/mcap version").strip

    resource("homebrew-testdata").stage do
      assert_equal "2 example [Example] [1 2 3]",
      pipe_output("#{bin}/mcap cat", File.read("OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap")).strip

      expected_info = <<~EOF
        library:
        profile:
        messages: 1
        duration: 0s
        start: 0.000
        end: 0.000
        compression:
        	: [1/1 chunks] (0.00%)
        channels:
          	(1) example  1 msgs (+Inf Hz)   : Example [c]
        attachments: 0
      EOF
      assert_equal expected_info.lines.map(&:strip),
        shell_output("#{bin}/mcap info OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap").lines.map(&:strip)
    end
  end
end
