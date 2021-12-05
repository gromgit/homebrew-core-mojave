require "language/node"

class AtomistCli < Formula
  desc "Unified command-line tool for interacting with Atomist services"
  homepage "https://github.com/atomist/cli#readme"
  url "https://registry.npmjs.org/@atomist/cli/-/cli-1.8.0.tgz"
  sha256 "64bcc7484fa2f1b7172984c278ae928450149fb02b750f79454b1a6683d17f62"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/atomist-cli"
    rebuild 2
    sha256 mojave: "0332dd8aaf87ce6fc54605939809ab1834d1c2c9cc21d987276200eda8843498"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink libexec.glob("bin/*")
    bash_completion.install libexec/"lib/node_modules/@atomist/cli/assets/bash_completion/atomist"

    term_size_vendor_dir = libexec/"lib/node_modules/@atomist/cli/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    assert_predicate bin/"atomist", :exist?
    assert_predicate bin/"atomist", :executable?
    assert_predicate bin/"@atomist", :exist?
    assert_predicate bin/"@atomist", :executable?

    run_output = shell_output("#{bin}/atomist 2>&1", 1)
    assert_match "Not enough non-option arguments", run_output
    assert_match "Specify --help for available options", run_output

    version_output = shell_output("#{bin}/atomist --version")
    assert_match "@atomist/cli", version_output
    assert_match "@atomist/sdm ", version_output
    assert_match "@atomist/sdm-core", version_output
    assert_match "@atomist/sdm-local", version_output

    skill_output = shell_output("#{bin}/atomist show skills")
    assert_match(/\d+ commands are available from \d+ connected SDMs/, skill_output)
  end
end
