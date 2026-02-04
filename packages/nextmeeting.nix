{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "nextmeeting";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "nextmeeting";
    rev = version;
    hash = "sha256-lw1orSZ6Wbr9u5kr6t7B70AbWNeESnD0M+NjBg9tT5g=";
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
