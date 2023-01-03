class Eiffelstudio < Formula
  desc "Development environment for the Eiffel language"
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/22.05/pp/PorterPackage_std_106302.tar"
  version "22.05.10.6302"
  sha256 "c2ede38b19cedead58a9e075cf79d6a4b113e049c0723fe9556c4f36ee68b80d"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/eiffelstudio"
    sha256 cellar: :any, mojave: "e714dc32b347921ecc8e96285e6677a98d4e10b4f80656c24f1a70438eb98f3c"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  uses_from_macos "pax" => :build

  def install
    # Fix flat namespace usage in C shared library.
    if OS.mac?
      system "tar", "xf", "c.tar.bz2"
      inreplace "C/CONFIGS/macosx-x86-64", "-flat_namespace -undefined suppress", "-undefined dynamic_lookup"
      system "tar", "cjf", "c.tar.bz2", "C"
    end

    # Use ENV.cc to link shared objects instead of directly invoking ld.
    # Reported upstream: https://support.eiffel.com/report_detail/19873.
    if OS.linux?
      system "tar", "xf", "c.tar.bz2"
      inreplace "C/CONFIGS/linux-x86-64", "sharedlink='ld'", "sharedlink='#{ENV.cc}'"
      inreplace "C/CONFIGS/linux-x86-64", "ldflags=\"-m elf_x86_64\"", "ldflags=''"
      system "tar", "cjf", "c.tar.bz2", "C"
    end

    os = OS.mac? ? "macosx" : OS.kernel_name.downcase
    os_tag = "#{os}-x86-64"
    system "./compile_exes", os_tag
    system "./make_images", os_tag
    prefix.install Dir["Eiffel_#{version.major}.#{version.minor.to_s.rjust(2, "0")}/*"]
    eiffel_env = { ISE_EIFFEL: prefix, ISE_PLATFORM: os_tag }
    {
      studio:       %w[ec ecb estudio finish_freezing],
      tools:        %w[compile_all iron syntax_updater],
      vision2_demo: %w[vision2_demo],
    }.each do |subdir, targets|
      targets.each do |target|
        (bin/target).write_env_script prefix/subdir.to_s/"spec"/os_tag/"bin"/target, eiffel_env
      end
    end
  end

  test do
    # More extensive testing requires the full test suite
    # which is not part of this package.
    system bin/"ec", "-version"
  end
end
