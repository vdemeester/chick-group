{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "nextmeeting";
  version = "3.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "nextmeeting";
    rev = version;
    hash = "sha256-jIFH6IjqFwgpGjgp3xQws32jJVQZCZXScY7dDs0Wyic=";
  };

  nativeBuildInputs = [ python3.pkgs.hatchling ];

  propagatedBuildInputs = [
    python3.pkgs.python-dateutil
    python3.pkgs.caldav
  ];

  pythonImportsCheck = [ "nextmeeting" ];

  # Tests require gcalcli setup
  doCheck = false;

  meta = {
    description = "Show your Google Calendar next meeting in waybar/polybar";
    homepage = "https://github.com/chmouel/nextmeeting";
    license = lib.licenses.asl20;
    mainProgram = "nextmeeting";
  };
}
