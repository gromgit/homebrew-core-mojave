class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https://gomplate.hairyhenderson.ca/"
  url "https://github.com/hairyhenderson/gomplate/archive/v3.11.2.tar.gz"
  sha256 "310f2ae19f409ad45f0f19a53045a3e8345e4723fa5ca9c5eeb8cbaf7cc0e195"
  license "MIT"
  head "https://github.com/hairyhenderson/gomplate.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gomplate"
    sha256 cellar: :any_skip_relocation, mojave: "ec9c3529344540584ef54b5305eff03024f7ce1ad2a4d105fe3ec646d7fbe44b"
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
