class FabricInstaller < Formula
  desc "Installer for Fabric for the vanilla launcher"
  homepage "https://fabricmc.net/"
  url "https://maven.fabricmc.net/net/fabricmc/fabric-installer/0.9.0/fabric-installer-0.9.0.jar"
  sha256 "11bf2058eb2d0441e1af38f570c5b920571449dadb2e316fcf021ba78443592b"
  license "Apache-2.0"

  # The first-party download page (https://fabricmc.net/use/) uses JavaScript
  # to create download links, so we check the related JSON data for versions.
  livecheck do
    url "https://meta.fabricmc.net/v2/versions/installer"
    regex(/["']url["']:\s*["'][^"']*?fabric-installer[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fabric-installer"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "36de0adb455a3e89c5b3195477c85af4208b816067d2be776e3df223bf824333"
  end

  depends_on "openjdk"

  def install
    libexec.install "fabric-installer-#{version}.jar"
    bin.write_jar_script libexec/"fabric-installer-#{version}.jar", "fabric-installer"
  end

  test do
    system "#{bin}/fabric-installer", "server"
    assert_predicate testpath/"fabric-server-launch.jar", :exist?
  end
end
