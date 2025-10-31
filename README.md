# Ansible solution to secure and prepare bare Debian 11 hosts for custom app
## Install and configure prerequisites

1. Create ssh key pair for remote app user:

        ssh-keygen -t ed25519 -b 4096 -C "<appuser>@<appname>"

    Use real values for `<appuser>` and `<appname>`. Being prompted use file name like `id_ed25519_<appname>_<appuser>`.

2. Use ssh-agent and add your key this way:

        ssh-add $HOME/.ssh/id_ed25519_<appname>_<appuser>

3. Add new host config to `$HOME/.ssh/config` this way:

        Host apphost
            HostName <host_ip>
            Port <ssh_alternative_port>
            User <appuser>
            IdentitiesOnly yes
            IdentityFile ~/.ssh/id_ed25519_<appname>_<appuser>

4. Install `ansible`, `sshpass` and `openssl`

5. Generate new password hashes for `<root_password_hash>` and `<app_user_password_hash>`

        openssl passwd -6

6. Edit `hosts.yml` to set respective values values like that:

        all:
            vars:
                app_user: "appuser"
                root_password_hash: "<new_root_password_hash_value>"
                app_user_password_hash: "<app_user_password_hash_value>"
                app_user_public_key: "{{ lookup('file', '~/.ssh/id_ed25519_<appname>_<appuser>.pub') }}"
                ssh_alternative_port: <new_ssh_port_number>

            hosts:
                new_host1: &new_host_vars
                    ansible_host: <host_ip>
                    ansible_port: 22
                    ansible_ssh_user: root


Congratulations! You are in a position to initialise any amount of Debian 11 hosts for your app. See comments in `hosts.yml` to add more hosts.

## Initialize and prepare remote hosts

For brand new just installed hosts run it this way. You will be asked for initial remote root password:

    ansible-playbook debian11_prepare_host.yml --ask-pass

For already prepared host you can change playbook file and run it over again this way. You will be asked for remote `<appuser>` password:

    ansible-playbook debian11_prepare_host.yml --ask-become-pass -e "ansible_port=<ssh_alternative_port> ansible_ssh_user=<appuser>"
