class Octosql < Formula
  desc "SQL query tool to analyze data from different file formats and databases"
  homepage "https://github.com/cube2222/octosql/"
  url "https://github.com/cube2222/octosql/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "129ce13c45ab2d2d4a7f0db2fc1e63a93d38e80f929f9b387b8c530f9be56b59"
  license "MPL-2.0"
  head "https://github.com/cube2222/octosql.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/octosql"
    sha256 cellar: :any_skip_relocation, mojave: "dbe4df61ab939edfea96666c9f3b384db96a52614c302a9d45cd0146bc9fee0d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cube2222/octosql/cmd.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_output = Utils.safe_popen_read(bin/"octosql", "completion", "bash")
    (bash_completion/"octosql").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"octosql", "completion", "zsh")
    (zsh_completion/"_octosql").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"octosql", "completion", "fish")
    (fish_completion/"octosql.fish").write fish_output
  end

  test do
    ENV["OCTOSQL_NO_TELEMETRY"] = "1"

    test_json = testpath/"test.json"
    test_json.write <<~EOS
      {"field1": "value", "field2": 42, "field3": {"field4": "eulav", "field5": 24}}
      {"field1": "value", "field2": 42, "field3": {"field5": "eulav", "field6": "value"}}
    EOS

    expected = <<~EOS
      +---------+--------+--------------------------+
      | field1  | field2 |          field3          |
      +---------+--------+--------------------------+
      | 'value' |     42 | { <null>, 'eulav',       |
      |         |        | 'value' }                |
      | 'value' |     42 | { 'eulav', 24, <null> }  |
      +---------+--------+--------------------------+
    EOS

    assert_equal expected, shell_output("#{bin}/octosql \"select * from test.json\"")

    assert_match version.to_s, shell_output("#{bin}/octosql --version")
  end
end
