class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.28.3.tar.gz"
  sha256 "5c12d379a08de6483e8c7b7503c3b317cc639c8ecbd8015b8d415ec98018328a"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pint"
    sha256 cellar: :any_skip_relocation, mojave: "b8f79ed7368b33300419433f5c91f6efc52c32567dd8310d610aec1cc085ea23"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/pint"
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      groups:
      - name: example
        rules:
        - alert: HighRequestLatency
          expr: job:request_latency_seconds:mean5m{job="myjob"} > 0.5
          for: 10m
          labels:
            severity: page
          annotations:
            summary: High request latency
    EOS

    assert_equal("level=info msg=\"File parsed\" path=#{testpath}/test.yaml rules=1\n",
                 shell_output("#{bin}/pint -n lint #{testpath}/test.yaml 2>&1"))
  end
end
