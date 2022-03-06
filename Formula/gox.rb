class Gox < Formula
  desc "Go cross compile tool"
  homepage "https://github.com/mitchellh/gox"
  url "https://github.com/mitchellh/gox/archive/v1.0.1.tar.gz"
  sha256 "25aab55a4ba75653931be2a2b95e29216b54bd8fecc7931bd416efe49a388229"
  license "MPL-2.0"
  head "https://github.com/mitchellh/gox.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gox"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "0fb72eb0793a78c86435bd72ed54f56884c7f46d8145fe90c8f48a46780d8a09"
  end

  depends_on "go"

  resource "iochan" do
    url "https://github.com/mitchellh/iochan.git",
        revision: "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  # This resource is for the test so doesn't really need to be updated.
  resource "pup" do
    url "https://github.com/ericchiang/pup/archive/v0.4.0.tar.gz"
    sha256 "0d546ab78588e07e1601007772d83795495aa329b19bd1c3cde589ddb1c538b0"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    ENV["GOPATH"] = testpath
    ENV["GO111MODULE"] = "auto"
    (testpath/"src/github.com/ericchiang/pup").install resource("pup")
    cd "src/github.com/ericchiang/pup" do
      output = shell_output("#{bin}/gox -arch amd64 -os darwin -os freebsd")
      assert_match "parallel", output
      assert_predicate Pathname.pwd/"pup_darwin_amd64", :executable?
      assert_predicate Pathname.pwd/"pup_freebsd_amd64", :executable?
      refute_predicate Pathname.pwd/"pup_linux_amd64", :exist?
    end
  end
end
