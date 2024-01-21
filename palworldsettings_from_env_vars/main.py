import filecmp
import os
import logging
from argparse import ArgumentParser
from configparser import RawConfigParser
from pathlib import Path
import shutil
import sys
from typing import Dict

# Configure logging

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)


class MaintainCaseConfigParser(RawConfigParser):
    def optionxform(self, optionstr):
        return optionstr


def process_env_vars() -> Dict[str, Dict[str, Dict[str, str]]]:
    config_files: Dict[str, Dict[str, Dict[str, str]]] = {"OptionSettings": {}}
    for key, value in os.environ.items():
        if not key.startswith("PALWORLD_"):
            continue
        tokens = key.split("_")

        if len(tokens) < 2:
            logging.warning(f"Invalid config environment variable: {key}")
            continue
        var_name = "_".join(tokens[1:])

        config_files["OptionSettings"][var_name] = value
    return config_files


def update_ini_file(
    config_data: Dict[str, Dict[str, Dict[str, str]]], path: str
) -> None:
    config_parser = MaintainCaseConfigParser(strict=False)
    file_path = os.path.join(path, "PalWorldSettings.ini")

    config_parser.read(file_path)
    config_parser.add_section("/Script/Pal.PalGameWorldSettings")

    logging.info(f"Updating {file_path} with {config_data}")

    try:
        config_parser.set(
            "/Script/Pal.PalGameWorldSettings",
            "OptionSettings",
            "("
            + ",".join(
                [
                    f"{key}={value}"
                    for key, value in config_data["OptionSettings"].items()
                ]
            )
            + ")",
        )

        with open(file_path, "w") as config_file:
            config_parser.write(config_file, space_around_delimiters=False)
    except Exception as e:
        logging.error(f"Error updating file PalWorldSettings.ini: {e}")


def backup_file(config_path: str) -> None:
    file_path = os.path.join(config_path, "PalWorldSettings.ini")
    backup_path = os.path.join(config_path, "PalWorldSettings.ini.backup")

    counter = 1
    while Path(backup_path).exists():
        backup_path = os.path.join(config_path, f"PalWorldSettings.ini.backup{counter}")
        counter += 1
    try:
        logging.info(f"Creating backup of {file_path} to {backup_path}")
        shutil.move(file_path, backup_path)
    except Exception as e:
        logging.error(f"Error creating backup of PalWorldSettings.ini: {e}")


def get_latest_backup_file(base_file_path: str):
    base_file_name = os.path.basename(base_file_path)
    directory = os.path.dirname(base_file_path)
    backup_files = sorted(
        Path(directory).glob(f"{base_file_name}.backup*"), reverse=True
    )
    return str(backup_files[0]) if backup_files else ""


def compare_and_cleanup_configs(path: str):
    latest_backup = get_latest_backup_file(f"{path}/PalWorldSettings.ini")

    if not latest_backup:
        logging.info(f"No backups exist for: {path}/PalWorldSettings.ini")
        return
    if Path(latest_backup).exists() and filecmp.cmp(
        f"{path}/PalWorldSettings.ini", latest_backup, shallow=False
    ):
        os.remove(latest_backup)
        logging.info(f"New config matches old, backup removed: {latest_backup}")
    else:
        logging.info(f"Configuration changed, latest backup retained: {latest_backup}")


def main():
    parser = ArgumentParser(
        description="Update PalWorldSettings.ini based on environment variables."
    )
    parser.add_argument(
        "--config-path",
        dest="config_path",
        type=str,
        help="Path to directory containing PalWorldSettings.ini.",
        default="/palworld/server/Pal/Saved/Config/LinuxServer",
    )
    args = parser.parse_args()

    if not Path(os.path.join(args.config_path)).exists():
        logging.error(f"Given File Path Does Not Exist: {args.config_path}")
        sys.exit(1)
    backup_file(args.config_path)
    config_data = process_env_vars()
    update_ini_file(config_data, args.config_path)
    compare_and_cleanup_configs(args.config_path)


if __name__ == "__main__":
    main()
