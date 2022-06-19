class CollectorSidecar < Formula
  desc "Manage log collectors through Graylog"
  homepage "https://www.graylog.org/"
  url "https://github.com/Graylog2/collector-sidecar.git",
      tag:      "1.2.0",
      revision: "99c07ca667f2f3eeb9fc23afc1bf7f3152b002cb"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/collector-sidecar"
    sha256 cellar: :any_skip_relocation, mojave: "a76a652bbb2d5589efbab084ecbde903b7b9dd20559c5b48b17165b18ef36187"
  end

  depends_on "go" => :build
  depends_on "mercurial" => :build
  depends_on "filebeat"

  def install
    ldflags = %W[
      -s -w
      -X github.com/Graylog2/collector-sidecar/common.GitRevision=#{Utils.git_head}
      -X github.com/Graylog2/collector-sidecar/common.CollectorVersion=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"graylog-sidecar", ldflags: ldflags)
    (etc/"graylog/sidecar/sidecar.yml").install "sidecar-example.yml"
  end

  service do
    run opt_bin/"graylog-sidecar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graylog-sidecar -version")
  end
end
