class IcalBuddy < Formula
  desc "Get events and tasks from the macOS calendar database"
  homepage "https://hasseg.org/icalBuddy/"
  url "https://github.com/DavidKaluta/icalBuddy64/releases/download/v1.10.1/icalBuddy-v1.10.1.zip"
  sha256 "720a6a3344ce32c2cab7c3d2b686ad8de8d9744b747ac48b275247ed54cb3945"
  license "MIT"
  head "https://github.com/DavidKaluta/icalBuddy64.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ical-buddy"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "efc6e18c606d05fbfba0cd4604fdf9dd43aac9e616a8f08d2b6fe908ce4c2e67"
  end

  depends_on :macos

  def install
    args = %W[icalBuddy icalBuddy.1 icalBuddyLocalization.1
              icalBuddyConfig.1 COMPILER=#{ENV.cc}]
    system "make", *args
    bin.install "icalBuddy"
    man1.install Dir["*.1"]
  end
end
