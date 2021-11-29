class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/e2/15/5f3b25028d728b75668ad3c12aa4e1f7f6307c7f495cf3988a4f7c7ba126/pipenv-2021.11.23.tar.gz"
  sha256 "1bde859e8bbd1d21d503fd995bc0170048d6da7686ab885f074592c99a16e8f3"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pipenv"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "83d182b9daadf2883d889fe7a32ba446bc70f31ae2af4270ac76d550f7d3a07c"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "backports.entry-points-selectable" do
    url "https://files.pythonhosted.org/packages/71/16/edd003270daaab0168f7dbac6e22b055322e9ba66fb2cc951f58d1ed158b/backports.entry_points_selectable-1.1.1.tar.gz"
    sha256 "914b21a479fde881635f7af5adc7f6e38d6b274be32269070c53b698c60d5386"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/56/ed/9c876a62efda9901863e2cc8825a13a7fcbda75b4b498103a4286ab1653b/distlib-0.3.3.zip"
    sha256 "d982d0751ff6eaaab5e2ec8e691d949ee80eddf01a62eaa96ddb11531fe16b05"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/79/3f/aae4a951dc5bd2738901e053c057f4b317bf12199f09351f63a002442117/filelock-3.4.0.tar.gz"
    sha256 "93d512b32a23baf4cac44ffd72ccf70732aeff7b8050fcaf6d3ec406d954baf4"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/4b/96/d70b9462671fbeaacba4639ff866fb4e9e558580853fc5d6e698d0371ad4/platformdirs-2.4.0.tar.gz"
    sha256 "367a5e80b3d04d2428ffa76d33f124cf11e8fff2acdaa9b43d545f5c7d661ef2"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/c7/3e/b11275c99dd779e4fc87931f7c82ce93767080249bfa4d7aea7ea748800e/virtualenv-20.10.0.tar.gz"
    sha256 "576d05b46eace16a9c348085f7d0dc8ef28713a2cabaa1cf0aea41e8f12c9218"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/85/76/49120db3bb8de4073ac199a08dc7f11255af8968e1e14038aee95043fafa/virtualenv-clone-0.5.7.tar.gz"
    sha256 "418ee935c36152f8f153c79824bb93eaf6f0f7984bae31d3f48f350b9183501a"
  end

  def install
    # Using the virtualenv DSL here because the alternative of using
    # write_env_script to set a PYTHONPATH breaks things.
    # https://github.com/Homebrew/homebrew-core/pull/19060#issuecomment-338397417
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    venv.pip_install buildpath

    # `pipenv` needs to be able to find `virtualenv` on PATH. So we
    # install symlinks for those scripts in `#{libexec}/tools` and create a
    # wrapper script for `pipenv` which adds `#{libexec}/tools` to PATH.
    (libexec/"tools").install_symlink libexec/"bin/pip", libexec/"bin/virtualenv"
    env = {
      PATH: "#{libexec}/tools:$PATH",
    }
    (bin/"pipenv").write_env_script(libexec/"bin/pipenv", env)

    output = Utils.safe_popen_read(
      { "_PIPENV_COMPLETE" => "zsh_source" }, libexec/"bin/pipenv", { err: :err }
    )
    (zsh_completion/"_pipenv").write output

    output = Utils.safe_popen_read(
      { "_PIPENV_COMPLETE" => "fish_source" }, libexec/"bin/pipenv", { err: :err }
    )
    (fish_completion/"pipenv.fish").write output
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Commands", shell_output("#{bin}/pipenv")
    system "#{bin}/pipenv", "--python", Formula["python@3.10"].opt_bin/"python3"
    system "#{bin}/pipenv", "install", "requests"
    system "#{bin}/pipenv", "install", "boto3"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
