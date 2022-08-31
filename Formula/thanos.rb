class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.28.0.tar.gz"
  sha256 "095466b601fbe5c0323beb4b8d93970d6bcb8b2f9607cd5da9514c2d4207b072"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/thanos"
    sha256 cellar: :any_skip_relocation, mojave: "4f626a967eeccdf81dba3e2ff7f45b32b0f2d5dad74c1a8a4d0ce0ff0ad449c4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/thanos"
  end

  test do
    (testpath/"bucket_config.yaml").write <<~EOS
      type: FILESYSTEM
      config:
        directory: #{testpath}
    EOS

    output = shell_output("#{bin}/thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end
