class ClozureCl < Formula
  desc "Common Lisp implementation with a long history"
  homepage "https://ccl.clozure.com"
  url "https://github.com/Clozure/ccl/archive/v1.12.1.tar.gz"
  sha256 "bd005fdb24cee2f7b20077cbca5e9174c10a82d98013df5cc3eabc7f31ccd933"
  license "Apache-2.0"
  head "https://github.com/Clozure/ccl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end


  depends_on xcode: :build
  depends_on macos: :catalina # The GNU assembler frontend which ships macOS 10.14 is incompatible with clozure-ccl: https://github.com/Clozure/ccl/issues/271

  on_linux do
    depends_on "m4"
  end

  resource "bootstrap" do
    on_macos do
      url "https://github.com/Clozure/ccl/releases/download/v1.12.1/darwinx86.tar.gz"
      sha256 "92c5776ba1ba8548361669b50ae1655d7f127ff01d6e2107d8dccb97f2a585cd"
    end

    on_linux do
      url "https://github.com/Clozure/ccl/releases/download/v1.12.1/linuxx86.tar.gz"
      sha256 "ec98d881abc3826b7fd5ec811f01f9bb77e4491ac4eb7f1cea5e3b26d5098052"
    end
  end

  def install
    tmpdir = Pathname.new(Dir.mktmpdir)
    tmpdir.install resource("bootstrap")

    if OS.mac?
      buildpath.install tmpdir/"dx86cl64.image"
      buildpath.install tmpdir/"darwin-x86-headers64"
      cd "lisp-kernel/darwinx8664" do
        system "make"
      end
    else
      buildpath.install tmpdir/"lx86cl64"
      buildpath.install tmpdir/"lx86cl64.image"
      buildpath.install tmpdir/"x86-headers64"
    end

    ENV["CCL_DEFAULT_DIRECTORY"] = buildpath

    if OS.mac?
      system "./dx86cl64", "-n", "-l", "lib/x8664env.lisp",
            "-e", "(ccl:xload-level-0)",
            "-e", "(ccl:compile-ccl)",
            "-e", "(quit)"
      (buildpath/"image").write('(ccl:save-application "dx86cl64.image")\n(quit)\n')
      system "cat image | ./dx86cl64 -n --image-name x86-boot64.image"
    else
      system "./lx86cl64", "-n", "-l", "lib/x8664env.lisp",
            "-e", "(ccl:rebuild-ccl :full t)",
            "-e", "(quit)"
      (buildpath/"image").write('(ccl:save-application "lx86cl64.image")\n(quit)\n')
      system "cat image | ./lx86cl64 -n --image-name x86-boot64"
    end

    prefix.install "doc/README"
    doc.install Dir["doc/*"]
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/scripts/ccl64"]
    bin.env_script_all_files(libexec/"bin", CCL_DEFAULT_DIRECTORY: libexec)
  end

  test do
    output = shell_output("#{bin}/ccl64 -n -e '(write-line (write-to-string (* 3 7)))' -e '(quit)'")
    assert_equal "21", output.strip
  end
end
