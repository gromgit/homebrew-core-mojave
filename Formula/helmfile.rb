class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.145.4.tar.gz"
  sha256 "1bfc5e805525c3629d2c28b30747ef5da7cbcce2c482cd163c0e716898f4f8be"
  license "MIT"
  version_scheme 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/helmfile"
    sha256 cellar: :any_skip_relocation, mojave: "9531a33b463bea0d54600cc886ec94c1fd1c5f5db283a3ebb32307d4b186c4ce"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    ldflags = %W[
      -s -w
      -X github.com/helmfile/helmfile/pkg/app/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"helmfile.yaml").write <<-EOS
    repositories:
    - name: stable
      url: https://charts.helm.sh/stable

    releases:
    - name: vault                            # name of this release
      namespace: vault                       # target namespace
      createNamespace: true                  # helm 3.2+ automatically create release namespace (default true)
      labels:                                # Arbitrary key value pairs for filtering releases
        foo: bar
      chart: stable/vault                    # the chart being installed to create this release, referenced by `repository/chart` syntax
      version: ~1.24.1                       # the semver of the chart. range constraint is supported
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
