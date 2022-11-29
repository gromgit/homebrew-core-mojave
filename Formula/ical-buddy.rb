class IcalBuddy < Formula
  desc "Get events and tasks from the macOS calendar database"
  homepage "https://hasseg.org/icalBuddy/"
  url "https://github.com/dkaluta/icalBuddy64/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "aff42b809044efbf9a1f7df7598e9e110c1c4de0a4c27ddccde5ea325ddc4b77"
  license "MIT"
  revision 1
  head "https://github.com/dkaluta/icalBuddy64.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ical-buddy"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "01fd60770752eff263c6f184ece6b142bbb7c213d529f1346165c78c742f231b"
  end

  depends_on :macos

  def install
    # Allow native builds rather than only x86_64
    inreplace "Makefile", "-arch x86_64", ""

    args = %W[
      icalBuddy
      icalBuddy.1
      icalBuddyLocalization.1
      icalBuddyConfig.1
      COMPILER=#{ENV.cc}
      APP_VERSION=#{version}
    ]
    system "make", *args
    bin.install "icalBuddy"
    man1.install Dir["*.1"]
  end
end
