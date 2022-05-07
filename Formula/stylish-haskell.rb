class StylishHaskell < Formula
  desc "Haskell code prettifier"
  homepage "https://github.com/haskell/stylish-haskell"
  url "https://github.com/haskell/stylish-haskell/archive/v0.14.2.0.tar.gz"
  sha256 "e70081f863a406f0f048799d9fb2e6d92ad486bf9d5364609902155bfd2c3ea8"
  license "BSD-3-Clause"
  head "https://github.com/haskell/stylish-haskell.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stylish-haskell"
    sha256 cellar: :any_skip_relocation, mojave: "653cae18c91b7c447213fb6f7d3a839af5851106dbef096356af0a3de81c5529"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~EOS
      {-# LANGUAGE ViewPatterns, TemplateHaskell #-}
      {-# LANGUAGE GeneralizedNewtypeDeriving,
                  ViewPatterns,
          ScopedTypeVariables #-}

      module Bad where

      import Control.Applicative ((<$>))
      import System.Directory (doesFileExist)

      import qualified Data.Map as M
      import      Data.Map    ((!), keys, Map)
    EOS
    expected = <<~EOS
      {-# LANGUAGE GeneralizedNewtypeDeriving #-}
      {-# LANGUAGE ScopedTypeVariables        #-}
      {-# LANGUAGE TemplateHaskell            #-}

      module Bad where

      import           Control.Applicative ((<$>))
      import           System.Directory    (doesFileExist)

      import           Data.Map            (Map, keys, (!))
      import qualified Data.Map            as M
    EOS
    assert_equal expected, shell_output("#{bin}/stylish-haskell test.hs")
  end
end
