class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.10.0.tar.gz"
  sha256 "f9a30d8e94b81eefbbe3455c21dc547ec0ebf0e010a809c72db617a4b37223a6"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gomplate"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "3b6b73e45d78adddfc0381cd8c02beaf0a1ff4f26b7645768db4dee5e951f07c"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/gomplate" => "gomplate"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/gomplate --version")
    assert_equal "gomplate version #{version}", output.chomp

    test_template = <<~EOS
      {{ range ("foo:bar:baz" | strings.SplitN ":" 2) }}{{.}}
      {{end}}
    EOS

    expected = <<~EOS
      foo
      bar:baz
    EOS

    assert_match expected, pipe_output("#{bin}/gomplate", test_template, 0)
  end
end
