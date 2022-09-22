class Hof < Formula
  desc "Flexible data modeling & code generation system"
  homepage "https://hofstadter.io/"
  url "https://github.com/hofstadter-io/hof.git",
      tag:      "v0.6.6",
      revision: "0f49b4d71a66788b006daacf905a2b138768beca"
  license "BSD-3-Clause"
  head "https://github.com/hofstadter-io/hof.git", branch: "_dev"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hof"
    sha256 cellar: :any_skip_relocation, mojave: "b3820d04ed50a608716a2594c01717f235fc0b11d4e3aa3f206b546a929dad85"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    ldflags = %W[
      -s -w
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.Version=#{version}
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.Commit=#{Utils.git_head}
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.BuildDate=#{time.iso8601}
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.GoVersion=#{Formula["go"].version}
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.BuildOS=#{os}
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.BuildArch=#{arch}
    ]

    ENV["CGO_ENABLED"] = "0"
    ENV["HOF_TELEMETRY_DISABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hof"

    generate_completions_from_executable(bin/"hof", "completion")
  end

  test do
    ENV["HOF_TELEMETRY_DISABLED"] = "1"
    assert_match "v#{version}", shell_output("#{bin}/hof version")

    system bin/"hof", "mod", "init", "cue", "brew.sh/brewtest"
    assert_predicate testpath/"cue.mods", :exist?
    assert_equal "module: \"brew.sh/brewtest\"", (testpath/"cue.mod/module.cue").read.chomp
  end
end
