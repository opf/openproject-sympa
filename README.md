# openproject-sympa

Sympa integration for OpenProject.

## Configuration

**Sympa command**

If you're running sympa on the same machine as OpenProject the value for the sympa command
would usually just be `sympa` (as in `/usr/bin/sympa`). You can also have sympa on a remote
machine, however.

In that case you have to give the host along with the command which will be executed via ssh:

`ssh my.sympa.com sudo -u sympa sympa`

The command will be run as the `openproject` user on the remote system (my.sympa.com).
You will have to create one if there isn't one already.
In this example we use sudo to run the command as the sympa user as that may be required for the
call to work. In that case you also have to make sure that the `openproject` user is allowed to run
that command using sudo and without a password prompt.

You can do that by adding the following content to `/etc/sudoers.d/99-openproject-sudo-sympa`:

```
openproject ALL=(ALL) NOPASSWD:/usr/bin/sympa
```
