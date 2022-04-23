class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.49.0.tar.gz"
  sha256 "c2afef0eb63127a14a6cda022f22690c720e355bb4c5ff44562d6d3e2c1c793b"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bitrise"
    sha256 cellar: :any_skip_relocation, mojave: "80ad0440b12eec5cff9a32e26be31478ed7c2db1ebf67db07dca09da8b0fbe49"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"bitrise.yml").write <<~EOS
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    system "#{bin}/bitrise", "setup"
    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
