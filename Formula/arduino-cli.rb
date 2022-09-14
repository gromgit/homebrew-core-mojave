class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
      tag:      "0.27.1",
      revision: "a900cfb2e7e58a9ed7e06be607c0f9878a17b15d"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/arduino-cli"
    sha256 cellar: :any_skip_relocation, mojave: "bb2b4bdf6fdccff380fc5e2f60df1c5208cd7842e71661dba80e7d0e4b038357"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-cli/version.versionString=#{version}
      -X github.com/arduino/arduino-cli/version.commit=#{Utils.git_head(length: 8)}
      -X github.com/arduino/arduino-cli/version.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"arduino-cli", "completion")
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/test_sketch")

    version_output = shell_output("#{bin}/arduino-cli version 2>&1")
    assert_match("arduino-cli  Version: #{version}", version_output)
    assert_match("Commit:", version_output)
    assert_match(/[a-f0-9]{8}/, version_output)
    assert_match("Date: ", version_output)
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/, version_output)
  end
end
