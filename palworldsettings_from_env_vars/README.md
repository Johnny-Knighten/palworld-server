# palworldsettings_from_env_vars

This script is used the generate the `PalWorldSettings.ini` config file from environment variables. More specifically it takes all environment variables prefixed with `PALWORLD_` and places them inside the `/Script/Pal.PalGameWorldSettings` section of `PalWorldSettings.ini` and saves them under the `OptionSettings` variable as comma separated values.

The developers of Palworld decided to shove all server settings into a single variable that are comma separated files. It makes zero sense they are already using a ini file, but it is what it is. This script is forked from the one contained in my [`Ark Surival Ascended Docker Container`](https://github.com/Johnny-Knighten/ark-sa-server).

## Usage

```
usage: main.py [-h] [--config-path CONFIG_DIRECTORY]

Update PalWorldSettings.ini based on environment variables.

options:
  -h, --help            show this help message and exit
  --config-path CONFIG_DIRECTORY
                        Path to store created ini files.
```

## Environment Variable Format

```bash
PALWORLD_<variable>=<value>.
```
* `PALWORLD`
  * All variables used by the script must have the `PALWORLD_` prefix. 
* `<variable>`
  * The name of the variable to create in the config file.
* `<value>`
  * The value to set the variable to.

## File Backups

When a `PALWORLD_` variable is changed between executions, the script will create a backup copy of the current config file then generate a new one. The backup will be stored in the same directory as the config file with the same name and the `.backup#` extension. The `#` will be incremented for each backup created, and the highest number reflects the newest backup.

If you introduce `PALWORLD_` vars and eventually remove all of them, the current configs will have a backup made, but no new config will be generated. 

## Example Execution

### Example 1

```bash
export PALWORLD_ServerName="Palworld Server"
python3 main.py --config-path $(pwd)
```

Creates

```ini
#PalWorldSettings.ini
[/Script/Pal.PalGameWorldSettings]
OptionSettings=(ServerName="Palworld Server")
```

### Example 2

```bash
export PALWORLD_ServerName="Palworld Server"
export PALWORLD_ServerPlayerMaxNum=16
python3 main.py --config-path $(pwd)
```

Creates
  
```ini
#PalWorldSettings.ini
[/Script/Pal.PalGameWorldSettings]
OptionSettings=(ServerName="Palworld Server",ServerPlayerMaxNum=16)
```

## Unittest Execution

To execute the unit tests associated with this script, run the following command from the project's root directory:

```bash
python3 -m unittest tests/palworldsettings_from_env_vars/test_main.py -v
```