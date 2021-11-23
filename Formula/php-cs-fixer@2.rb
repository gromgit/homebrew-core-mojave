class PhpCsFixerAT2 < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v2.19.3/php-cs-fixer.phar"
  sha256 "64238c2940e273f6182abe5279fea0df3707ac3d18f30909f0ab4fb6f9018f94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "62f0ceae3aec334450704706f22b62d66dc966347a4a7c3324566e530746ffea"
  end

  keg_only :versioned_formula
  depends_on "php"

  def install
    bin.install "php-cs-fixer.phar" => "php-cs-fixer"
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php $this->foo(   'homebrew rox'   );
    EOS
    (testpath/"correct_test.php").write <<~EOS
      <?php $this->foo('homebrew rox');
    EOS

    system "#{bin}/php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
