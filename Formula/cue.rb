class Cue < Formula
  desc "Validate and define text-based and dynamic configuration"
  homepage "https://cuelang.org/"
  url "https://github.com/cue-lang/cue/archive/v0.4.3.tar.gz"
  sha256 "3d51f780f6d606a0341a5321b66e7d80bd54c294073c0d381e2ed96a3ae07c6e"
  license "Apache-2.0"
  head "https://github.com/cue-lang/cue.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cue"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "a02eab92b62b4bf800d0007c94c7fe57b4c6b0b9a60d41d2ba1dee042447fcf7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X cuelang.org/go/cmd/cue/cmd.version=v#{version}"), "./cmd/cue"

    generate_completions_from_executable(bin/"cue", "completion")
  end

  test do
    (testpath/"ranges.yml").write <<~EOS
      min: 5
      max: 10
      ---
      min: 10
      max: 5
    EOS

    (testpath/"check.cue").write <<~EOS
      min?: *0 | number    // 0 if undefined
      max?: number & >min  // must be strictly greater than min if defined.
    EOS

    expected = <<~EOS
      max: invalid value 5 (out of bound >10):
          ./check.cue:2:16
          ./ranges.yml:5:7
    EOS

    assert_equal expected, shell_output(bin/"cue vet ranges.yml check.cue 2>&1", 1)

    assert_match version.to_s, shell_output(bin/"cue version")
  end
end
