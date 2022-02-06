class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/v1.5.1.tar.gz"
  sha256 "6cc716026d366b4a3b235cf7142a29a0234459a4c845c01c6e94a13e02efc7d3"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jd"
    sha256 cellar: :any_skip_relocation, mojave: "3ad0f040ec59ec2d710130f053d4040bd275220a64bda603118b31ed5614bd62"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"a.json").write('{"foo":"bar"}')
    (testpath/"b.json").write('{"foo":"baz"}')
    (testpath/"c.json").write('{"foo":"baz"}')
    expected = <<~EOF
      @ ["foo"]
      - "bar"
      + "baz"
    EOF
    output = shell_output("#{bin}/jd a.json b.json", 1)
    assert_equal output, expected
    assert_empty shell_output("#{bin}/jd b.json c.json")
  end
end
