class Periscope < Formula
  desc "Organize and de-duplicate your files without losing data"
  homepage "https://github.com/anishathalye/periscope"
  url "https://github.com/anishathalye/periscope.git",
      tag:      "v0.3.2",
      revision: "fc3a56637217d55014189c43e76c58ceddb7bfc4"
  license "GPL-3.0-only"
  head "https://github.com/anishathalye/periscope.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/periscope"
    sha256 cellar: :any_skip_relocation, mojave: "276585c6eca331050623e6c68dd9a8e1b4c5a2160f7d4c836b9161d721717e19"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(output: bin/"psc", ldflags: ldflags), "./cmd/psc"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"psc", "completion", "bash")
    (bash_completion/"psc").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"psc", "completion", "zsh")
    (zsh_completion/"_psc").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"psc", "completion", "fish")
    (fish_completion/"psc.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/psc version")

    # setup
    scandir = testpath/"scandir"
    scandir.mkdir
    (scandir/"a").write("dupe")
    (scandir/"b").write("dupe")
    (scandir/"c").write("unique")

    # scan + summary is correct
    shell_output "#{bin}/psc scan #{scandir} 2>/dev/null"
    summary = shell_output("#{bin}/psc summary").strip.split("\n").map { |l| l.strip.split }
    assert_equal [["tracked", "3"], ["unique", "2"], ["duplicate", "1"], ["overhead", "4", "B"]], summary

    # rm allows deleting dupes but not uniques
    shell_output "#{bin}/psc rm #{scandir/"a"}"
    refute_predicate (scandir/"a"), :exist?
    # now b is unique
    shell_output "#{bin}/psc rm #{scandir/"b"} 2>/dev/null", 1
    assert_predicate (scandir/"b"), :exist?
    shell_output "#{bin}/psc rm #{scandir/"c"} 2>/dev/null", 1
    assert_predicate (scandir/"c"), :exist?

    # cleanup
    shell_output("#{bin}/psc finish")
  end
end
