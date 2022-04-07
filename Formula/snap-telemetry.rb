class SnapTelemetry < Formula
  desc "Snap is an opensource telemetry framework"
  homepage "https://snap-telemetry.io/"
  url "https://github.com/intelsdi-x/snap/archive/2.0.0.tar.gz"
  sha256 "35f6ddcffcff27677309abb6eb4065b9fe029a266c3f7ff77103bf822ff315ab"
  license "Apache-2.0"
  head "https://github.com/intelsdi-x/snap.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/snap-telemetry"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "442b15fbbf135af47a14911b23ccbaadc4b5b7fc476bbe7bdaf50ce3f0aec314"
  end

  # https://github.com/intelsdi-x/snap/commit/e3a6c8e39994b3980df0c7b069d5ede810622952
  deprecate! date: "2018-12-20", because: :deprecated_upstream

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    ENV["GO111MODULE"] = "auto"

    snapteld = buildpath/"src/github.com/intelsdi-x/snap"
    snapteld.install buildpath.children

    cd snapteld do
      system "glide", "install"
      system "go", "build", "-o", "snapteld", "-ldflags", "-w -X main.gitversion=#{version}"
      sbin.install "snapteld"
      prefix.install_metafiles
    end

    snaptel = buildpath/"src/github.com/intelsdi-x/snap/cmd/snaptel"
    cd snaptel do
      system "go", "build", "-o", "snaptel", "-ldflags", "-w -X main.gitversion=#{version}"
      bin.install "snaptel"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/snapteld --version")
    assert_match version.to_s, shell_output("#{bin}/snaptel --version")

    begin
      snapteld_pid = fork do
        exec "#{sbin}/snapteld -t 0 -l 1 -o #{testpath}"
      end
      sleep 5
      assert_match("No plugins", shell_output("#{bin}/snaptel plugin list"))
      assert_match("No task", shell_output("#{bin}/snaptel task list"))
      assert_predicate testpath/"snapteld.log", :exist?
    ensure
      Process.kill("TERM", snapteld_pid)
    end
  end
end
