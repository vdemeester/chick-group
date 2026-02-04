_self: super: {
  abs-tui = super.callPackage ../packages/abs-tui.nix { };
  batzconverter = super.callPackage ../packages/batzconverter.nix { };
  cliphist-cleanup = super.callPackage ../packages/cliphist-cleanup.nix { };
  deptree = super.callPackage ../packages/deptree.nix { };
  gh-news = super.callPackage ../packages/gh-news.nix { };
  gh-pr = super.callPackage ../packages/gh-pr.nix { };
  gitmal = super.callPackage ../packages/gitmal.nix { };
  go-better-html-coverage = super.callPackage ../packages/go-better-html-coverage.nix { };
  jayrah = super.callPackage ../packages/jayrah.nix { };
  jira2markdown = super.callPackage ../packages/jira2markdown.nix { };
  kss = super.callPackage ../packages/kss.nix { };
  lazypr = super.callPackage ../packages/lazypr.nix { };
  nextmeeting = super.callPackage ../packages/nextmeeting.nix { };
  nixpkgs-pr-watch = super.callPackage ../packages/nixpkgs-pr-watch.nix { };
  pi-coding-agent = super.callPackage ../packages/pi-coding-agent.nix { };
  startpaac = super.callPackage ../packages/startpaac.nix { };
}
