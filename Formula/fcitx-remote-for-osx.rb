class FcitxRemoteForOsx < Formula
  desc "Handle input method in command-line"
  homepage "https://github.com/xcodebuild/fcitx-remote-for-osx"
  url "https://github.com/xcodebuild/fcitx-remote-for-osx/archive/0.4.0.tar.gz"
  sha256 "453c99a0c2e227c29e2db640c592b657342a9294a3386d1810fd4c9237deeaae"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fcitx-remote-for-osx"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "164dd8b3291a168266cda202754516b57d982fb341608a7eedf56628c5db5266"
  end

  depends_on :macos

  # need py3.6+ for f-strings
  uses_from_macos "python" => :build, since: :catalina

  def install
    system "python3", "build.py", "build", "general"
    bin.install "fcitx-remote-general"
    bin.install_symlink "fcitx-remote-general" => "fcitx-remote"
  end

  test do
    system "#{bin}/fcitx-remote", "-n"
  end
end
