class Fits < Formula
  desc "File Information Tool Set"
  homepage "https://projects.iq.harvard.edu/fits"
  url "https://github.com/harvard-lts/fits/releases/download/1.5.1/fits-1.5.1.zip"
  sha256 "4bf4adfedf0779221cc2f4648f5dfd3040c7a3e5daa4060c5754d73dc1964442"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, all: "0da280076217b759472c440df96df7c866f0226af4a53f7845c19fc565e09270"
  end

  # Installs pre-built x86_64 binaries
  depends_on arch: :x86_64
  depends_on "openjdk"

  uses_from_macos "zlib"

  def install
    # Remove Windows, PPC, and 32-bit Linux binaries
    %w[macho elf exe].each do |ext|
      (buildpath/"tools/exiftool/perl/t/images/EXE.#{ext}").unlink
    end

    # Remove Windows-only directories
    %w[exiftool/windows file_utility_windows mediainfo/windows].each do |dir|
      (buildpath/"tools"/dir).rmtree
    end

    libexec.install "lib", "tools", "xml", *buildpath.glob("*.properties")

    inreplace "fits-env.sh" do |s|
      s.gsub!(/^FITS_HOME=.*/, "FITS_HOME=#{libexec}")
      s.gsub! "${FITS_HOME}/lib", "#{libexec}/lib"
    end

    inreplace %w[fits.sh fits-ngserver.sh],
              %r{\$\(dirname .*\)/fits-env\.sh}, "#{libexec}/fits-env.sh"

    # fits-env.sh is a helper script that sets up environment
    # variables, so we want to tuck this away in libexec
    libexec.install "fits-env.sh"
    (libexec/"bin").install %w[fits.sh fits-ngserver.sh]
    (bin/"fits").write_env_script libexec/"bin/fits.sh", Language::Java.overridable_java_home_env
    (bin/"fits-ngserver").write_env_script libexec/"bin/fits.sh", Language::Java.overridable_java_home_env
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    assert_match 'mimetype="audio/mpeg"', shell_output("#{bin}/fits -i test.mp3")
  end
end
