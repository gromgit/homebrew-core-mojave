class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://manfred.life/assh"
  url "https://github.com/moul/assh/archive/v2.14.0.tar.gz"
  sha256 "711721e2aece3b4d39c170924db8bf0f82c75690811d8b50f2310ccb2aa6b07f"
  license "MIT"
  head "https://github.com/moul/assh.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/assh"
    sha256 cellar: :any_skip_relocation, mojave: "ed54ea07e5e08f8ad3b82d080d6d838f9cd9d202bccb39f5e348b3407d615e08"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assh_config = testpath/"assh.yml"
    assh_config.write <<~EOS
      hosts:
        hosta:
          Hostname: 127.0.0.1
      asshknownhostfile: /dev/null
    EOS

    output = "hosta assh ping statistics"
    assert_match output, shell_output("#{bin}/assh --config #{assh_config} ping -c 4 hosta 2>&1")
  end
end
