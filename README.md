**UPDATE 2022-Feb-25**: Apologies, I forgot that Homebrew hardcodes a "master" branch for `homebrew/core`, so I've had to rename the original `main` branch accordingly. Please repeat the above steps to reinstall my tap.

---

# Experimental support for Homebrew Core on Mojave

This repo mirrors the main Homebrew core repo as much as possible, only making concessions to stuff that can no longer be built under Mojave. I'll provide bottles to the best of my ability, as they're expired from the main Homebrew core repo.

## How do I install these formulae?

From a **working** Homebrew installation, you first need to change the GitHub remote for the core repo:
```
# Stop `brew` from complaining about the unusual repo URL
export HOMEBREW_CORE_GIT_REMOTE=https://github.com/gromgit/homebrew-core-mojave
rm -fr $(brew --repo homebrew/core)
brew tap homebrew/core https://github.com/gromgit/homebrew-core-mojave
```
Then just `brew install <formula>` as usual.

You should also add `export HOMEBREW_CORE_GIT_REMOTE=https://github.com/gromgit/homebrew-core-mojave` to your shell's startup file, otherwise `brew doctor` will warn you:
```
Warning: Suspicious https://github.com/Homebrew/homebrew-core git origin remote found.
```

## Why is XYZ not the latest version?

Any or all of the following:

1. I don't have a Github-scale infrastructure to build Mojave bottles, and since there are easily a few dozen new Homebrew releases each day, it may take a while for me to catch up.
2. The latest XYZ may not be available on Mojave--this will be noted in the Caveats section of `brew info XYZ`. For instance, `swift` is permanently stuck at v5.2.5, because later versions require a newer version of Xcode that's not available for Mojave.

## Hey, something's not working right.

If you find any problems, please [open an issue here](https://github.com/gromgit/homebrew-core-mojave/issues/new/choose). Do **NOT** file an issue in the main Homebrew core repo, they have nothing to do with this.

## It's just not my cup of tea. How do I revert to the original Homebrew core?

```
unset HOMEBREW_CORE_GIT_REMOTE
rm -fr $(brew --repo homebrew/core)
brew tap homebrew/core
```
