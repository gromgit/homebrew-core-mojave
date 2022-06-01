class Jenv < Formula
  desc "Manage your Java environment"
  homepage "https://www.jenv.be/"
  url "https://github.com/jenv/jenv/archive/0.5.4.tar.gz"
  sha256 "15a78dab7310fb487d2c2cad7f69e05d5d797dc13f2d5c9e7d0bbec4ea3f2980"
  license "MIT"
  revision 1
  head "https://github.com/jenv/jenv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7e42339ed467f521dfd3dd17d78b23fd3504994915fee2b200b8d184ec5d93ea"
  end

  # Upstream ships an unnecessary export shim for fish shell, which breaks scripts
  # https://github.com/Homebrew/homebrew-core/pull/100234#issuecomment-1111862141
  patch :DATA

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/jenv"
    fish_function.install_symlink Dir[libexec/"fish/*.fish"]
  end

  def caveats
    if preferred == :fish
      <<~EOS
        To activate jenv, run the following commands:
          echo 'status --is-interactive; and source (jenv init -|psub)' >> #{shell_profile}
      EOS
    else
      <<~EOS
        To activate jenv, add the following to your #{shell_profile}:
          export PATH="$HOME/.jenv/bin:$PATH"
          eval "$(jenv init -)"
      EOS
    end
  end

  test do
    shell_output("eval \"$(#{bin}/jenv init -)\" && jenv versions")
  end
end
__END__
diff --git a/fish/export.fish b/fish/export.fish
deleted file mode 100644
index 14dbbec..0000000
--- a/fish/export.fish
+++ /dev/null
@@ -1,4 +0,0 @@
-function export
-  set arr (echo $argv|tr = \n)
-  set -gx $arr[1] $arr[2]
-end
