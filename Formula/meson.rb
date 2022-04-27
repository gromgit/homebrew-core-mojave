class Meson < Formula
  include Language::Python::Virtualenv

  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.62.1/meson-0.62.1.tar.gz"
  sha256 "a0f5caa1e70da12d5e63aa6a9504273759b891af36c8d87de381a4ed1380e845"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/meson"
    sha256 cellar: :any_skip_relocation, mojave: "51d2506f660c0b8248663e197dd42d20b407df1af29878a4b4da329bd7edef4f"
  end

  depends_on "ninja"
  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
    bash_completion.install "data/shell-completions/bash/meson"
    zsh_completion.install "data/shell-completions/zsh/_meson"
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system bin/"meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end
