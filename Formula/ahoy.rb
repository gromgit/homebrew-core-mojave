class Ahoy < Formula
  desc "Creates self documenting CLI programs from commands in YAML files"
  homepage "https://ahoy-cli.readthedocs.io/"
  url "https://github.com/ahoy-cli/ahoy/archive/refs/tags/2.0.1.tar.gz"
  sha256 "44376afc56f2c24be78fff09bc80e8e621991eca7bc755daede664d0e8aaf122"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ahoy"
    sha256 cellar: :any_skip_relocation, mojave: "8f081f1b09982c3b6da87d37a61624680193b498fb896c65e8ca17ad357d8ff7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}-homebrew")
  end

  def caveats
    <<~EOS
      ===== UPGRADING FROM 1.x TO 2.x =====

      If you are upgrading from ahoy 1.x, note that you'll
      need to upgrade your ahoyapi settings in your .ahoy.yml
      files to 'v2' instead of 'v1'.

      See other changes at:

      https://github.com/ahoy-cli/ahoy

    EOS
  end

  test do
    (testpath/".ahoy.yml").write <<~EOS
      ahoyapi: v2
      commands:
        hello:
          cmd: echo "Hello Homebrew!"
    EOS
    assert_equal "Hello Homebrew!\n", `#{bin}/ahoy hello`

    assert_equal "#{version}-homebrew", shell_output("#{bin}/ahoy --version").strip
  end
end
