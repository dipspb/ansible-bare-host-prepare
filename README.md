# Ansible solution to secure and prepare bare Debian 11 hosts for custom app
## Install and configure prerequisites

1. Create ssh key pair for remote app user:

        ssh-keygen -t ed25519 -b 4096 -C "<appuser>@<appname>"

    Use real values for `<appuser>` and `<appname>`. Being prompted use file name like `id_ed25519_<appname>_<appuser>`.

2. Use ssh-agent and add your key this way:

        ssh-add $HOME/.ssh/id_ed25519_<appname>_<appuser>

3. Add new host config to `$HOME/.ssh/config` this way:

        Host <app_host_alias>
            HostName <host_ip>
            Port <ssh_alternative_port>
            User <appuser>
            IdentitiesOnly yes
            IdentityFile ~/.ssh/id_ed25519_<appname>_<appuser>

4. Install `ansible`, `sshpass` and `openssl`

5. Generate new password hashes for `<root_password_hash>` and `<app_user_password_hash>`

        openssl passwd -6

6. Copy `hosts-example.yml` file to `hosts.yml`. Edit `hosts.yml` file to set respective values values like that:

        all:
            vars:
                app_user: "appuser"
                root_password_hash: "<new_root_password_hash_value>"
                app_user_password_hash: "<app_user_password_hash_value>"
                app_user_public_key: "{{ lookup('file', '~/.ssh/id_ed25519_<appname>_<appuser>.pub') }}"
                ssh_alternative_port: <new_ssh_port_number>

            hosts:
                new_host1: &new_host_vars
                    ansible_host: <app_host_alias>
                    ansible_port: 22
                    ansible_ssh_user: root


Congratulations! You are in a position to initialise any amount of Debian 11 hosts for your app. See comments in `hosts.yml` to add more hosts.

## Initialize and prepare remote hosts

### Prepare brand new hosts
For brand new just installed hosts run it this way. You will be asked for initial remote root password:

    ansible-playbook debian11_prepare_host.yml --ask-pass

In case it wil fail with following error message: `"Using a SSH password instead of a key is not possible because Host Key checking is enabled and sshpass does not support this.  Please add this host's fingerprint to your known_hosts file to manage this host."` you wil need to run following command first to set remote ssh host as known:

    ssh -p 22 <app_host_alias>

Then being asked just type `yes` and press `<Enter>`. It is enough and you don't need to provide any real password. Just exit it with `<Ctrl-C>`.

### Update already prepared hosts
For already prepared host you can change playbook file and run it over again this way. You will be asked for remote `<appuser>` password:

    ansible-playbook debian11_prepare_host.yml --ask-become-pass -e "ansible_port=<ssh_alternative_port> ansible_ssh_user=<appuser>"
