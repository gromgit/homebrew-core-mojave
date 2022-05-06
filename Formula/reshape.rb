class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://github.com/fabianlindfors/reshape/archive/v0.6.0.tar.gz"
  sha256 "4a69ec4476e0983224d446b63ebf78e3f764b57ac4e73aab49ac34b8f506851c"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/reshape"
    sha256 cellar: :any_skip_relocation, mojave: "6d514f91ac2fa9c61abafcea031683858413da7e6028ac5110f321d4a2e152b5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"migrations/test.toml").write <<~EOS
      [[actions]]
      type = "create_table"
      name = "users"
      primary_key = ["id"]

        [[actions.columns]]
        name = "id"
        type = "INTEGER"
        generated = "ALWAYS AS IDENTITY"

        [[actions.columns]]
        name = "name"
        type = "TEXT"
    EOS

    assert_match "SET search_path TO migration_test",
      shell_output("#{bin}/reshape generate-schema-query")

    assert_match "Error: error connecting to server:",
      shell_output("#{bin}/reshape migrate 2>&1", 1)
  end
end
