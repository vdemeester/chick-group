{
  lib,
  buildNpmPackage,
  fetchzip,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "pi-coding-agent";
  version = "0.63.0";

  src = fetchzip {
    url = "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-${finalAttrs.version}.tgz";
    hash = "sha256-vA6ZfRQbBJJQVAWXAdH19EUTdXZVTW4IrSIEACVJNcA=";
  };

  npmDepsHash = "sha256-PuwlfAsz+b+uuWCyt5rklWtPpSGF0kJk2Y3fKHJpeuc=";

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
    homepage = "https://github.com/badlogic/pi-mono";
    changelog = "https://github.com/badlogic/pi-mono/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://www.npmjs.com/package/@mariozechner/pi-coding-agent";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vdemeester ];
    mainProgram = "pi";
    platforms = lib.platforms.unix;
  };
})
