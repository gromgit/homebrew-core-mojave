- [ ] Have you followed the [guidelines for contributing](https://github.com/Homebrew/homebrew-core/blob/HEAD/CONTRIBUTING.md)?
- [ ] Have you ensured that your commits follow the [commit style guide](https://docs.brew.sh/Formula-Cookbook#commit)?
- [ ] Have you checked that there aren't other open [pull requests](https://github.com/Homebrew/homebrew-core/pulls) for the same formula update/change?
- [ ] Have you built your formula locally with `brew install --build-from-source <formula>`, where `<formula>` is the name of the formula you're submitting?
- [ ] Is your test running fine `brew test <formula>`, where `<formula>` is the name of the formula you're submitting?
- [ ] Does your build pass `brew audit --strict <formula>` (after doing `brew install --build-from-source <formula>`)? If this is a new formula, does it pass `brew audit --new <formula>`?

-----
