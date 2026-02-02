_self: super: {
  abs-tui = super.callPackage ../packages/abs-tui.nix { };
  cliphist-cleanup = super.callPackage ../packages/cliphist-cleanup.nix { };
  deptree = super.callPackage ../packages/deptree.nix { };
  gh-news = super.callPackage ../packages/gh-news.nix { };
  gh-pr = super.callPackage ../packages/gh-pr.nix { };
  go-better-html-coverage = super.callPackage ../packages/go-better-html-coverage.nix { };
  kss = super.callPackage ../packages/kss.nix { };
  lazypr = super.callPackage ../packages/lazypr.nix { };
  nixpkgs-pr-watch = super.callPackage ../packages/nixpkgs-pr-watch.nix { };
  pi-coding-agent = super.callPackage ../packages/pi-coding-agent.nix { };
  startpaac = super.callPackage ../packages/startpaac.nix { };
}
