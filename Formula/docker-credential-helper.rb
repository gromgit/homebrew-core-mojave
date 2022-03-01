class DockerCredentialHelper < Formula
  desc "macOS Credential Helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://github.com/docker/docker-credential-helpers/archive/v0.6.4.tar.gz"
  sha256 "b97d27cefb2de7a18079aad31c9aef8e3b8a38313182b73aaf8b83701275ac83"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docker-credential-helper"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "d9a1bc4be02022ff2c88fe4ebce7b1a4b3ff43bb8f54703682fdda625d36fb45"
  end


  depends_on "go" => :build
  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    dir = buildpath/"src/github.com/docker/docker-credential-helpers"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
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
      prefix.install_metafiles
    end
  end

  test do
    on_macos do
      # A more complex test isn't possible as this tool operates using the macOS
      # user keychain (incompatible with CI).
      run_output = shell_output("#{bin}/docker-credential-osxkeychain", 1)
      assert_match %r{^Usage: .*/docker-credential-osxkeychain.*}, run_output
    end
    on_linux do
      run_output = shell_output("#{bin}/docker-credential-pass list")
      assert_match "{}", run_output

      run_output = shell_output("#{bin}/docker-credential-secretservice list", 1)
      assert_match "Error from list function in secretservice_linux.c", run_output
    end
  end
end
