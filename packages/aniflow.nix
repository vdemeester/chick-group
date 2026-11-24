{
  lib,
  fetchFromGitHub,
  python3Packages,
  nodejs,
}:

let
  repoMeta = lib.importJSON ../repos/aniflow-main.json;
in
python3Packages.buildPythonApplication {
  pname = "aniflow";
  inherit (repoMeta) version;
  pyproject = true;

  src = fetchFromGitHub (builtins.removeAttrs repoMeta [ "type" "version" ]);

  build-system = [ python3Packages.hatchling ];
  nativeCheckInputs = [
    nodejs
    python3Packages.pytestCheckHook
  ];
  preCheck = ''
    node --test js-test/*.test.js
  '';
  pythonImportsCheck = [ "aniflow" ];

  # Check the installed wheel, not just the source tree used by pytest.
  postInstall = ''
    $out/bin/aniflow --help > /dev/null
    package_dir="$out/${python3Packages.python.sitePackages}/aniflow"
    for dir in static vendor icons templates; do
      diff -r "src/aniflow/$dir" "$package_dir/$dir"
    done
    diff -r skills "$package_dir/skills"
  '';

  meta = {
    description = "Markdown presentations with animated diagrams and a local document reader";
    homepage = "https://github.com/chmouel/aniflow";
    license = lib.licenses.asl20;
    mainProgram = "aniflow";
    platforms = lib.platforms.unix;
  };
}
