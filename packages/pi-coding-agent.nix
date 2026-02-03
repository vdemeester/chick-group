{
  lib,
  buildNpmPackage,
  fetchzip,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "pi-coding-agent";
  version = "0.51.2";

  src = fetchzip {
    url = "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-${finalAttrs.version}.tgz";
    hash = "sha256-/e3XAxluTeqTeK/dE5e1Q87U0P8WeXOe4s7QU09ZY/c=";
  };

  npmDepsHash = "sha256-gGXhojt6lZpEQv+cDmL+tYL6yFMIQ0f6CmXhTBvzN4k=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = ./update-pi-coding-agent.sh;

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
