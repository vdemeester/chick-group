{
  lib,
  fetchFromGitHub,
  jira2markdown,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "jayrah";
  version = "0.1.0";

  pyproject = true;

  disabled = python3.pkgs.pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "jayrah";
    rev = finalAttrs.version;
    hash = "sha256-repl0vWZ8BSd+ZIfQBYQvCfYB0cewoGqUcM4+cclwEw=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'py-modules = ["jayrah"]' 'packages = { find = { include = ["jayrah*"] } }'
  '';

  propagatedBuildInputs = with python3.pkgs; [
    click
    fastapi
    mcp
    pyyaml
    rich
    textual
    textual-dev
    uvicorn
    jira2markdown
  ];

  pythonImportsCheck = [
    "jayrah"
  ];

  doCheck = false;

  meta = {
    description = "CLI and TUI for working with Jira from the terminal";
    homepage = "https://github.com/chmouel/jayrah";
    license = lib.licenses.asl20;
    mainProgram = "jayrah";
  };
})
