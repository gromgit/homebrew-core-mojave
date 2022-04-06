class PinboardNotesBackup < Formula
  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/v1.0.5.4.tar.gz"
  sha256 "c2a239f8f5d7acba04c8a5bdf6e0f337e547f99c29d37db638d915712b97505d"
  license "GPL-3.0-or-later"
  head "https://github.com/bdesham/pinboard-notes-backup.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pinboard-notes-backup"
    sha256 cellar: :any_skip_relocation, mojave: "3ba8670a7997c4121747eda2f1e0161f8919599f0fee3eccdf3edc2a60d8aaf2"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    man1.install "man/pnbackup.1"
  end

  # A real test would require hard-coding someone's Pinboard API key here
  test do
    assert_match "TOKEN", shell_output("#{bin}/pnbackup Notes.sqlite 2>&1", 1)
    output = shell_output("#{bin}/pnbackup -t token Notes.sqlite 2>&1", 1)
    assert_match "HTTP 500 response", output
  end
end
