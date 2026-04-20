{
  lib,
  buildNpmPackage,
  fetchzip,
  jq,
}:

buildNpmPackage (finalAttrs: {
  pname = "pi-acp";
  version = "0.0.26";

  src = fetchzip {
    url = "https://registry.npmjs.org/pi-acp/-/pi-acp-${finalAttrs.version}.tgz";
    hash = "sha256-37n4i+JY8I63xdXIL+BCFPohWYgugeW4ASB06y/+tjI=";
  };

  npmDepsHash = "sha256-7DhOBEPwhX2brxz24rqcfYw6Scw9g/yAUPXr0zo0j+A=";

  postPatch = ''
    cp ${./pi-acp-package-lock.json} package-lock.json
    # Remove lifecycle scripts that try to rebuild from source (dist/ is pre-built)
    ${lib.getExe jq} 'del(.scripts.prepack, .scripts.prepublishOnly, .scripts.build)' package.json > package.json.tmp
    mv package.json.tmp package.json
  '';

  dontNpmBuild = true;

  # pi-acp doesn't support --version, skip version check
  doInstallCheck = false;

  meta = {
    description = "ACP adapter for pi coding agent";
    homepage = "https://github.com/svkozak/pi-acp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vdemeester ];
    mainProgram = "pi-acp";
    platforms = lib.platforms.unix;
  };
})
