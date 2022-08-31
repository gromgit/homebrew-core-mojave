class Teller < Formula
  desc "Secrets management tool for developers built in Go"
  homepage "https://tlr.dev/"
  url "https://github.com/SpectralOps/teller.git",
      tag:      "v1.5.4",
      revision: "604abece2a4a4ca1e32c6d812f5f0aa0e256548c"
  license "Apache-2.0"
  head "https://github.com/SpectralOps/teller.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/teller"
    sha256 cellar: :any_skip_relocation, mojave: "08c42cdc78f7c6169fa9d7fa6382387d5c4a2f2d71e072d3ec18c7744bd43ba7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"test.env").write <<~EOS
      foo: var
    EOS

    (testpath/".teller.yml").write <<~EOS
      project: brewtest
      providers:
        # this will fuse vars with the below .env file
        # use if you'd like to grab secrets from outside of the project tree
        dotenv:
          env_sync:
            path: #{testpath}/test.env
    EOS

    output = shell_output("#{bin}/teller -c #{testpath}/.teller.yml show  2>&1")
    assert_match "teller: loaded variables for brewtest using #{testpath}/.teller.yml", output
    assert_match "foo", output

    assert_match "Teller #{version}", shell_output("#{bin}/teller version")
  end
end
