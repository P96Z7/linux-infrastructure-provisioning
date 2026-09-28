# User, Group, and Service Administration

An interactive Bash script for creating department directories and groups, registering users, and installing Apache and MySQL.

## Features

- Create department directories and their corresponding groups.
- Create users with a home directory, the Bash shell, and membership in a department group.
- Install Apache and enable it to start at boot.
- Install the `mysql-server-8.0` package.

## Requirements

- A Linux system with Bash, the `apt` package manager, and `systemd`.
- Administrator privileges (`root` or `sudo`).
- Access to the configured package repositories.
- The `apache2` and `mysql-server-8.0` packages must be available in those repositories. MySQL availability depends on your distribution and version.

## Preparation

Save the code as `script.sh` (the filename used in the examples).

If you copied the code from a Markdown-formatted message:

- Remove backslashes used to escape characters, such as those in `inst\_apache`, `GRP\_ADM`, `\#`, and `\*`.
- Remove the opening and closing Markdown code fences (lines containing triple backticks).
- Make sure the first line is `#!/bin/bash`, with no characters before `#!`.

Check the syntax without running the script:

```bash
bash -n script.sh
```

This check does not detect operational issues such as unavailable packages, missing groups, or insufficient permissions.

## Running the Script

Update the package list and run the script:

```bash
sudo apt update
sudo bash script.sh
```

The script modifies system users, groups, directories, and services. Run it in an environment you administer.

## Main Menu

Enter the number corresponding to an option and press Enter.

| Option | Action |
| --- | --- |
| `Create Group` | Opens the directory and group creation menu. |
| `Register a New User` | Prompts for a username and department group. |
| `Install Packages` | Opens the Apache and MySQL installation menu. |
| `Finish` | Exits the script. |

### Creating Directories and Groups

| Department | Directory | Group | Ownership | Permissions |
| --- | --- | --- | --- | --- |
| Administrative | `/adm` | `GRP_ADM` | `root:GRP_ADM` | `770` |
| Security | `/sec` | `GRP_SEC` | `root:GRP_SEC` | `770` |
| Sales | `/sal` | `GRP_SAL` | `root:GRP_SAL` | `770` |
| Accounting | `/acc` | `GRP_ACC` | `root:GRP_ACC` | `770` |

Permissions of `770` grant the owner and group members read, write, and directory traversal access. These mode bits grant no permissions to other users.

In the current version, this submenu returns to the main menu after one selection, including an invalid selection. The `Finish` option also returns to the main menu.

### Registering Users

1. Create the department group using `Create Group`.
2. Select `Register a New User`.
3. Enter the login name.
4. Select `ADM`, `SAL`, `SEC`, or `ACC`.
5. Press Enter to return to the main menu.

The `CANCEL` option cancels registration. The creation command uses `useradd -m`, sets `/bin/bash` as the shell, and adds the user to the selected group as a supplementary group.

The script reports whether `useradd` succeeded or failed. It does not set a password. To set a password after creating the user, run the following command, replacing `username` with the new login name:

```bash
sudo passwd username
```

### Installing Packages

| Option | Behavior |
| --- | --- |
| `Apache` | Runs `apt install apache2 -y`, enables the service at boot, and displays the addresses returned by `hostname -I`. |
| `MySql` | Runs `apt install mysql-server-8.0 -y`. |
| `Done` | Returns to the main menu. |

After one selection, this submenu returns to the main menu. The `-y` option automatically confirms installation prompts from `apt`.

`systemctl enable apache2` configures startup at boot but does not itself start the service. To start Apache immediately, if needed:

```bash
sudo systemctl start apache2
```

## Current Limitations

- The installation and department creation functions display success messages without checking every command's result. Review any errors shown in the terminal.
- `mkdir -p` accepts existing directories, but `groupadd` reports an error if a group already exists. Even after that error, the subsequent permission and ownership commands still run.
- Existing department directories have their permissions and ownership changed by `chmod` and `chown` if those commands succeed. These changes are not recursive.
- User registration fails if the selected group does not exist or the user cannot be created, for example, because the login name already exists.
- The script does not perform its own username validation or check administrator privileges at startup.
- The script does not configure databases, MySQL users, Apache sites, or firewall rules.
- Permissions of `770` do not guarantee that new files inherit the directory's group. The script does not configure the setgid bit or default ACLs.
- To keep the group and package submenus open until `Finish` or `Done` is selected, remove the `break` immediately after `esac` in `menu_grp` and `menu_app1`.

## Verification

Check the department directories (directories that have not been created will produce an error):

```bash
ls -ld /adm /sec /sal /acc
```

Check a user's group memberships, replacing the example username:

```bash
id username
```

Check the services after installation:

```bash
systemctl status apache2
systemctl status mysql
```
