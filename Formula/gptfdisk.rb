class Gptfdisk < Formula
  desc "Text-mode partitioning tools"
  homepage "https://www.rodsbooks.com/gdisk/"
  url "https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.9/gptfdisk-1.0.9.tar.gz"
  sha256 "dafead2693faeb8e8b97832b23407f6ed5b3219bc1784f482dd855774e2d50c2"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gptfdisk"
    sha256 cellar: :any, mojave: "ed13c0bcc27692e29cb7412f908a2817e023f7372a46bcea126cc5520f4bf2b6"
  end

  depends_on "popt"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "util-linux"
  end

  def install
    if OS.mac?
      inreplace "Makefile.mac" do |s|
        s.gsub! "/usr/local/Cellar/ncurses/6.2/lib/libncurses.dylib", "-L/usr/lib -lncurses"
        s.gsub! "-L/usr/local/lib $(LDLIBS) -lpopt", "-L#{Formula["popt"].opt_lib} $(LDLIBS) -lpopt"
      end

      system "make", "-f", "Makefile.mac"
    else
      %w[ncurses popt util-linux].each do |dep|
        ENV.append_to_cflags "-I#{Formula[dep].opt_include}"
        ENV.append "LDFLAGS", "-L#{Formula[dep].opt_lib}"
      end

      system "make", "-f", "Makefile"
    end

    %w[cgdisk fixparts gdisk sgdisk].each do |program|
      bin.install program
      man8.install "#{program}.8"
    end
  end

  test do
    system "dd", "if=/dev/zero", "of=test.dmg", "bs=1024k", "count=1"
    assert_match "completed successfully", shell_output("#{bin}/sgdisk -o test.dmg")
    assert_match "GUID", shell_output("#{bin}/sgdisk -p test.dmg")
    assert_match "Found valid GPT with protective MBR", shell_output("#{bin}/gdisk -l test.dmg")
  end
end
