class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.3",
      revision: "8d1f7f32209636f2d3127ffbf56ecd50a641579f"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tygo"
    sha256 cellar: :any_skip_relocation, mojave: "0a59d09f80606863fede14f10e1bd16e9169d0bfd23a302cb74203fce2c2bc9b"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = %W[
      -s -w
      -X github.com/gzuidhof/tygo/cmd.version=#{version}
      -X github.com/gzuidhof/tygo/cmd.commit=#{Utils.git_head}
      -X github.com/gzuidhof/tygo/cmd.commitDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    (zsh_completion/"_tygo").write Utils.safe_popen_read(bin/"tygo", "completion", "zsh")
    (bash_completion/"tygo").write Utils.safe_popen_read(bin/"tygo", "completion", "bash")
    (fish_completion/"tygo.fish").write Utils.safe_popen_read(bin/"tygo", "completion", "fish")
    pkgshare.install "examples"
  end

  test do
    (testpath/"tygo.yml").write <<~EOS
      packages:
        - path: "simple"
          type_mappings:
            time.Time: "string /* RFC3339 */"
            null.String: "null | string"
            null.Bool: "null | boolean"
            uuid.UUID: "string /* uuid */"
            uuid.NullUUID: "null | string /* uuid */"
    EOS

    system "go", "mod", "init", "simple"
    cp pkgshare/"examples/simple/simple.go", testpath
    system bin/"tygo", "--config", testpath/"tygo.yml", "generate"
    assert_match "source: simple.go", (testpath/"index.ts").read

    assert_match version.to_s, shell_output("#{bin}/tygo --version")
  end
end
