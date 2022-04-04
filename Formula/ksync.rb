class Ksync < Formula
  desc "Sync files between your local system and a kubernetes cluster"
  homepage "https://ksync.github.io/ksync/"
  url "https://github.com/ksync/ksync.git",
      tag:      "0.4.7-hotfix",
      revision: "14ec9e24670b90ee45d4571984e58d3bff02c50e"
  license "Apache-2.0"
  head "https://github.com/ksync/ksync.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ksync"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "94b49f0c08199d7abeb8b1ccb8e68e34bb9dd7491dce1f522b87b8562dfd7a4e"
  end

  depends_on "go" => :build

  # Support go 1.17, remove after next release
  # Patch is equivalent to https://github.com/ksync/ksync/pull/544,
  # but does not apply cleanly
  patch :DATA

  def install
    project = "github.com/ksync/ksync"
    ldflags = %W[
      -w
      -X #{project}/pkg/ksync.GitCommit=#{Utils.git_short_head}
      -X #{project}/pkg/ksync.GitTag=#{version}
      -X #{project}/pkg/ksync.BuildDate=#{time.rfc3339(9)}
      -X #{project}/pkg/ksync.VersionString=#{tap.user}
      -X #{project}/pkg/ksync.GoVersion=go#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "#{project}/cmd/ksync"
  end

  test do
    # Basic build test. Potential for more sophisticated tests in the future
    # Initialize the local client and see if it completes successfully
    expected = "level=fatal"
    assert_match expected.to_s, shell_output("#{bin}/ksync init --local --log-level debug", 1)
  end
end

__END__
diff --git a/go.mod b/go.mod
index e2ff1b7..dd4bed9 100644
--- a/go.mod
+++ b/go.mod
@@ -51,6 +51,7 @@ require (
 	github.com/timfallmk/overseer v0.0.0-20200214205711-64f40ac3a421
 	golang.org/x/crypto v0.0.0-20201016220609-9e8e0b390897
 	golang.org/x/net v0.0.0-20201031054903-ff519b6c9102
+	golang.org/x/sys v0.0.0-20210819135213-f52c844e1c1c // indirect
 	google.golang.org/grpc v1.36.0
 	gopkg.in/ini.v1 v1.52.0 // indirect
 	gopkg.in/resty.v1 v1.12.0
diff --git a/go.sum b/go.sum
index babd1b5..063f1af 100644
--- a/go.sum
+++ b/go.sum
@@ -813,8 +813,9 @@ golang.org/x/sys v0.0.0-20200814200057-3d37ad5750ed/go.mod h1:h1NjWce9XRLGQEsW7w
 golang.org/x/sys v0.0.0-20200930185726-fdedc70b468f/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
 golang.org/x/sys v0.0.0-20201015000850-e3ed0017c211/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
 golang.org/x/sys v0.0.0-20201024232916-9f70ab9862d5/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
-golang.org/x/sys v0.0.0-20201101102859-da207088b7d1 h1:a/mKvvZr9Jcc8oKfcmgzyp7OwF73JPWsQLvH1z2Kxck=
 golang.org/x/sys v0.0.0-20201101102859-da207088b7d1/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs=
+golang.org/x/sys v0.0.0-20210819135213-f52c844e1c1c h1:Lyn7+CqXIiC+LOR9aHD6jDK+hPcmAuCfuXztd1v4w1Q=
+golang.org/x/sys v0.0.0-20210819135213-f52c844e1c1c/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
 golang.org/x/text v0.0.0-20160726164857-2910a502d2bf/go.mod h1:NqM8EUOU14njkJ3fqMW+pc6Ldnwhi/IjpwHt7yyuwOQ=
 golang.org/x/text v0.0.0-20170915032832-14c0d48ead0c/go.mod h1:NqM8EUOU14njkJ3fqMW+pc6Ldnwhi/IjpwHt7yyuwOQ=
 golang.org/x/text v0.3.0/go.mod h1:NqM8EUOU14njkJ3fqMW+pc6Ldnwhi/IjpwHt7yyuwOQ=
