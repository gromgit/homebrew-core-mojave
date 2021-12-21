class TeensyLoaderCli < Formula
  desc "Command-line integration for Teensy USB development boards"
  homepage "https://www.pjrc.com/teensy/loader_cli.html"
  url "https://github.com/PaulStoffregen/teensy_loader_cli/archive/2.2.tar.gz"
  sha256 "103c691f412d04906c4f46038c234d3e5f78322c1b78ded102df9f900724cd54"
  license "GPL-3.0-only"
  head "https://github.com/PaulStoffregen/teensy_loader_cli.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/teensy_loader_cli"
    sha256 cellar: :any_skip_relocation, mojave: "53d3820c12bd41cfe6b24b8d6502ae6b977a8a14b55688bc01ae79c4c0cd0010"
  end

  on_linux do
    depends_on "libusb-compat"
  end

  def install
    if OS.mac?
      ENV["OS"] = "MACOSX"
      ENV["SDK"] = MacOS.sdk_path || "/"

      # Work around "Error opening HID Manager" by disabling HID Manager check. Port of alswl's fix.
      # Ref: https://github.com/alswl/teensy_loader_cli/commit/9c16bb0add3ba847df5509328ad6bd5bc09d9ecd
      # Ref: https://forum.pjrc.com/threads/36546-teensy_loader_cli-on-OSX-quot-Error-opening-HID-Manager-quot
      inreplace "teensy_loader_cli.c", /ret != kIOReturnSuccess/, "0"
    end

    system "make"
    bin.install "teensy_loader_cli"
  end

  test do
    output = shell_output("#{bin}/teensy_loader_cli 2>&1", 1)
    assert_match "Filename must be specified", output
  end
end
