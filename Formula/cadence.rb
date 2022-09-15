class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  stable do
    url "https://github.com/onflow/cadence/archive/v0.26.0.tar.gz"
    sha256 "6ec4bd26e2563b3ea8df180f55f9aa370ae090ef635043d210e3f5b4d8aedee7"

    # add build patch, remove in next release
    # upstream PR reference
    patch do
      url "https://github.com/onflow/cadence/commit/a4657de4d03d5e3cfb144df24dbc75636c7c4d8c.patch?full_index=1"
      sha256 "fcf60195d3bdca45cd3e421119846b2a70ff04858ba173ce3a505bfd2e87b0d3"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cadence"
    sha256 cellar: :any_skip_relocation, mojave: "ac4575674a8fdf60234bb5286f02d850df3465068d1069a1d4a247c60bd52459"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
