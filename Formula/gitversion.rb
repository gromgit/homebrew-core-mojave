class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.8.2.tar.gz"
  sha256 "6a257db2f33cd2a14ffa38f22c35f42473d52810ee4c2be3560abe5458f477a7"
  license "MIT"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gitversion"
    rebuild 1
    sha256 cellar: :any, mojave: "8a715fa517b481ab93906782ba6a55530c3079a83356dc882bea04c7a3a08933"
  end

  depends_on "dotnet"

  def install
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{Formula["dotnet"].version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      -p:PublishSingleFile=true
    ]
    args << "-p:OsxArm64=true" if OS.mac? && Hardware::CPU.arm?

    system "dotnet", "publish", "src/GitVersion.App/GitVersion.App.csproj", *args
    env = { DOTNET_ROOT: "${DOTNET_ROOT:-#{Formula["dotnet"].opt_libexec}}" }
    (bin/"gitversion").write_env_script libexec/"gitversion", env
  end

  test do
    # Circumvent GitVersion's build server detection scheme:
    ENV["GITHUB_ACTIONS"] = nil

    (testpath/"test.txt").write("test")
    system "git", "init"
    system "git", "config", "user.name", "Test"
    system "git", "config", "user.email", "test@example.com"
    system "git", "add", "test.txt"
    system "git", "commit", "-q", "--message='Test'"
    assert_match '"FullSemVer": "0.1.0+0"', shell_output("#{bin}/gitversion -output json")
  end
end
