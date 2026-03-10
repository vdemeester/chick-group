{
  lib,
  buildNpmPackage,
  fetchzip,
  jq,
}:

buildNpmPackage (finalAttrs: {
  pname = "pi-acp";
  version = "0.0.22";

  src = fetchzip {
    url = "https://registry.npmjs.org/pi-acp/-/pi-acp-${finalAttrs.version}.tgz";
    hash = "sha256-2Sa0mUUzBtt4ehnb78uHx4p5COf89ZZ8tilQ06z7BJM=";
  };

  npmDepsHash = "sha256-rY2oGaSZ5wjS5MuhfHdPC2h8g7bpDRJw54jweviSn1I=";

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
