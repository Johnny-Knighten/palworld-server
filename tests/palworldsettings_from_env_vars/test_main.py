# test_main.py

import logging
from pathlib import Path
import unittest
from unittest import mock
from unittest.mock import MagicMock, patch, mock_open
from palworldsettings_from_env_vars.main import (
    process_env_vars,
    update_ini_file,
    backup_file,
    compare_and_cleanup_configs,
    get_latest_backup_file,
)

class TestConfigFromEnvVars(unittest.TestCase):
    def setUp(self):
        self.env_patcher = patch.dict("os.environ", clear=True)
        self.env_patcher.start()
        logging.disable(logging.NOTSET)

    def tearDown(self):
        self.env_patcher.stop()
        logging.disable(logging.NOTSET)

    @patch.dict(
        "os.environ",
        {"PALWORLD_DifficultyOffset": "0.25"},
    )
    def test_process_env_vars_single_var(self):
        result = process_env_vars()
        self.assertEqual(
            result,
            {"OptionSettings":  {"DifficultyOffset": "0.25"}}),

    @patch.dict(
        "os.environ",
        {
            "PALWORLD_DifficultyOffset": "0.25",
            "PALWORLD_ServerName": "Test Server",
        },
    )
    def test_process_env_vars_two_var(self):
        result = process_env_vars()
        self.assertEqual(
            result,
            {"OptionSettings":  {"DifficultyOffset": "0.25", "ServerName": "Test Server"}}),


    @patch("builtins.open", new_callable=mock_open)
    @patch("palworldsettings_from_env_vars.main.MaintainCaseConfigParser")
    def test_update_ini_file(self, mock_config, mock_file):
        mock_config_data = {"OptionSettings":  {"DifficultyOffset": "0.25", "ServerName": "Test Server"}}
        update_ini_file(mock_config_data, "/fake/path")
        mock_file.assert_called_once_with("/fake/path/PalWorldSettings.ini", "w")
        mock_config.return_value.set.assert_called_once_with(
            '/Script/Pal.PalGameWorldSettings', "OptionSettings", "(DifficultyOffset=0.25,ServerName=Test Server)"
        )
        mock_config.return_value.write.assert_called_once()

    @patch("builtins.open", new_callable=mock_open)
    @patch("palworldsettings_from_env_vars.main.MaintainCaseConfigParser")
    def test_update_ini_files_no_data_to_write(self, mock_config, mock_file):
        mock_config_data = {}
        update_ini_file(mock_config_data, "/fake/path")
        mock_file.assert_not_called()
        mock_config.return_value.set.assert_not_called()
        mock_config.return_value.write.assert_not_called()

    @patch("palworldsettings_from_env_vars.main.os.listdir")
    @patch("palworldsettings_from_env_vars.main.os.path.join")
    @patch("palworldsettings_from_env_vars.main.shutil.move")
    @patch("palworldsettings_from_env_vars.main.Path")
    def test_backup_file(
        self, mock_path, mock_move, mock_join, mock_listdir
    ):
        mock_listdir.return_value = ["PalWorldSettings.ini"]
        mock_join.side_effect = lambda a, b: f"{a}/{b}"
        mock_path_obj = mock.Mock()
        mock_path.return_value = mock_path_obj
        mock_path_obj.exists.side_effect = [
            True,
            False,
        ]

        backup_file("/fake/path")

        mock_move.assert_called_once_with(
            "/fake/path/PalWorldSettings.ini", "/fake/path/PalWorldSettings.ini.backup1"
        )

    @patch("palworldsettings_from_env_vars.main.os.listdir")
    @patch("palworldsettings_from_env_vars.main.shutil.move")
    def test_backup_file_with_empty_directory(
        self, mock_move, mock_listdir
    ):
        mock_listdir.return_value = []

        backup_file("/fake/path")

        mock_move.never_called()

    @patch("palworldsettings_from_env_vars.main.shutil.move")
    @patch("palworldsettings_from_env_vars.main.Path")
    @patch("palworldsettings_from_env_vars.main.os.listdir")
    def test_backup_file_existing_ini_files_increment(
        self, mock_listdir, mock_path, mock_move
    ):
        mock_listdir.return_value = ["config.ini"]
        path_instance = MagicMock()
        mock_path.return_value = path_instance

        path_instance.exists.side_effect = [True, True, False]

        backup_file("/fake/path")

        mock_move.assert_called_once_with(
            "/fake/path/PalWorldSettings.ini", "/fake/path/PalWorldSettings.ini.backup2"
        )

    @patch("palworldsettings_from_env_vars.main.Path")
    def test_get_latest_backup_file_with_multiple_backups(self, mock_path):
        directory = "/fake/path"
        base_file_name = "PalWorldSettings.ini"
        mock_backup_files = [
            Path(f"{directory}/{base_file_name}.backup{i}") for i in range(1, 4)
        ]
        mock_path.return_value.glob.return_value = mock_backup_files

        latest_backup = get_latest_backup_file(f"{directory}/{base_file_name}")

        self.assertEqual(latest_backup, f"{directory}/{base_file_name}.backup3")

    @patch("palworldsettings_from_env_vars.main.Path")
    def test_get_latest_backup_file_with_single_backup(self, mock_path):
        directory = "/fake/path"
        base_file_name = "PalWorldSettings.ini"
        mock_backup_files = [Path(f"{directory}/{base_file_name}.backup")]
        mock_path.return_value.glob.return_value = mock_backup_files

        latest_backup = get_latest_backup_file(f"{directory}/{base_file_name}")

        self.assertEqual(latest_backup, f"{directory}/{base_file_name}.backup")

    @patch("palworldsettings_from_env_vars.main.shutil.move")
    @patch("palworldsettings_from_env_vars.main.Path")
    @patch("palworldsettings_from_env_vars.main.os.listdir")
    def test_backup_existing_ini_files_error(
        self, mock_listdir, mock_path, mock_move
    ):
        mock_listdir.return_value = ["PalWorldSettings.ini"]
        mock_path_obj = MagicMock()
        mock_path.return_value = mock_path_obj
        mock_path_obj.exists.return_value = False

        mock_move.side_effect = OSError("Mocked file access error")

        with self.assertLogs(level="ERROR") as log:
            backup_file("/fake/path")

        self.assertIn("Mocked file access error", log.output[0])


    @patch("palworldsettings_from_env_vars.main.get_latest_backup_file")
    @patch("palworldsettings_from_env_vars.main.filecmp.cmp")
    @patch("palworldsettings_from_env_vars.main.os.remove")
    @patch("palworldsettings_from_env_vars.main.Path")
    def test_compare_and_cleanup_configs_files_same(
        self, mock_path, mock_remove, mock_cmp, mock_get_latest_backup_file
    ):
        mock_cmp.return_value = True
        mock_path().glob.return_value = ["/fake/path/PalWorldSettings.ini"]
        mock_get_latest_backup_file.return_value = "/fake/path/PalWorldSettings.ini.backup"

        compare_and_cleanup_configs("/fake/path")

        mock_remove.assert_called_once_with("/fake/path/PalWorldSettings.ini.backup")

    @patch("palworldsettings_from_env_vars.main.get_latest_backup_file")
    @patch("palworldsettings_from_env_vars.main.filecmp.cmp")
    @patch("palworldsettings_from_env_vars.main.os.remove")
    @patch("palworldsettings_from_env_vars.main.Path")
    def test_compare_and_cleanup_configs_files_different(
        self, mock_path, mock_remove, mock_cmp, mock_get_latest_backup_file
    ):
        mock_cmp.return_value = False
        mock_path().glob.return_value = ["/fake/path/PalWorldSettings.ini"]
        mock_get_latest_backup_file.return_value = "/fake/path/PalWorldSettings.ini.backup"

        compare_and_cleanup_configs("/fake/path")

        mock_remove.not_called()


if __name__ == "__main__":
    unittest.main()
