class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/v0.6.4.tar.gz"
  sha256 "b97d27cefb2de7a18079aad31c9aef8e3b8a38313182b73aaf8b83701275ac83"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docker-credential-helper"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "9fc58cd818a39a8b61145876db3db853b80548468f64d8d5923ec08675d3aee2"
  end

  depends_on "go" => :build
  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
  end

  def install
    if OS.mac?
      system "make", "vet_osx"
      system "make", "osxkeychain"
      bin.install "bin/docker-credential-osxkeychain"
    else
      system "make", "vet_linux"
      system "make", "pass"
      system "make", "secretservice"
      bin.install "bin/docker-credential-pass"
      bin.install "bin/docker-credential-secretservice"
    end
  end

  test do
    if OS.mac?
      run_output = shell_output("#{bin}/docker-credential-osxkeychain", 1)
      assert_match %r{^Usage: .*/docker-credential-osxkeychain.*}, run_output
    else
      run_output = shell_output("#{bin}/docker-credential-pass list")
      assert_match "{}", run_output

      run_output = shell_output("#{bin}/docker-credential-secretservice list", 1)
      assert_match "Error from list function in secretservice_linux.c", run_output
    end
  end
end
