class Click < Formula
  desc "Command-line interactive controller for Kubernetes"
  homepage "https://github.com/databricks/click"
  url "https://github.com/databricks/click/archive/v0.6.2.tar.gz"
  sha256 "8caa28e3dd3af40e0a8686e86457baa65d0c8cea2c8c530ad4834f44694c31e4"
  license "Apache-2.0"
  head "https://github.com/databricks/click.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/click"
    sha256 cellar: :any_skip_relocation, mojave: "1252424e12414fa795cd24d79b61c617b4dc1a2ce2b2a51a46b597536e599288"
  end

  depends_on "rust" => :build

  uses_from_macos "expect" => :test

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir testpath/"config"
    # Default state configuration file to avoid warning on startup
    (testpath/"config/click.config").write <<~EOS
      ---
      namespace: ~
      context: ~
      editor: ~
      terminal: ~
    EOS

    # Fake K8s configuration
    (testpath/"config/config").write <<~EOS
      apiVersion: v1
      clusters:
        - cluster:
            insecure-skip-tls-verify: true
            server: 'https://localhost:6443'
          name: test-cluster
      contexts:
        - context:
            cluster: test-cluster
            user: test-user
          name: test-context
      current-context: test-context
      kind: Config
      preferences:
        colors: true
      users:
        - name: test-cluster
          user:
            client-certificate-data: >-
              invalid
            client-key-data: >-
              invalid
    EOS

    # This test cannot test actual K8s connectivity, but it is enough to prove click starts
    (testpath/"click-test").write <<~EOS
      spawn "#{bin}/click" --config_dir "#{testpath}/config"
      expect "*\\[*none*\\]* *\\[*none*\\]* *\\[*none*\\]* >"
      send "quit\\r"
    EOS
    system "expect", "-f", "click-test"
  end
end
