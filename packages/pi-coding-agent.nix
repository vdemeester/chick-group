{
  lib,
  buildNpmPackage,
  fetchzip,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "pi-coding-agent";
  version = "0.75.1";

  src = fetchzip {
    url = "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-${finalAttrs.version}.tgz";
    hash = "sha256-uo54EiH1Og5pc1aY9zpp85ZI1ybqZujYiy22fkWrGR8=";
  };

  npmDepsHash = "sha256-iFSS21rF3p+I9mx/6eNi8KrzPtKxIcN/X1hN3Wd8IyE=";

  postPatch = ''
    cp ${./pi-coding-agent-package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # nix-update handles npm packages automatically with --generate-lockfile
  # No custom updateScript needed

  meta = {
    description = "Minimal terminal coding agent that adapts to your workflows";
    homepage = "https://github.com/earendil-works/pi";
    changelog = "https://github.com/earendil-works/pi/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://www.npmjs.com/package/@earendil-works/pi-coding-agent";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vdemeester ];
    mainProgram = "pi";
    platforms = lib.platforms.unix;
  };
})
