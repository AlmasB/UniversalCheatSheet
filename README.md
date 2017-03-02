# UniversalCheatSheet
Contains various things that are useful for work but can be forgotten

## GPG Keys

```bash
gpg --gen-key

gpg --list-keys

gpg --keyserver hkp://pgp.mit.edu --send-keys XXXXXXXX
```

## Maven Deploy

```bash
mvn clean deploy -Dgpg.passphrase=XXXXXXX
```

## Typical 2-branch development release

1. pull request -> merge -> delete branch
2. local switch to master -> git pull
3. mvn clean deploy (if passphrase set via settings.xml)

## Installing own git server (partially taken from [here](https://blog.jixee.me/how-to-migrate-from-github-to-a-self-hosted-repository/))

On client:

```bash
ssh-keygen -t rsa
```

This generates `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`

On server (this is the git server):

```bash
sudo -i
apt-get install git
useradd -d /git -s /usr/bin/git-shell git
mkdir -p /git/git-shell-commands
mkdir -p /git/.ssh/
```

Now copy contents from `~/.ssh/id_rsa.pub` to `/git/.ssh/authorized_keys`.
Then create a repo in `/git/`, e.g. `mkdir TestRepo.git`.
Set permissions:

```bash
chown -R git.git /git
chmod -R g=,o= /git
```

The `TestRepo` repo is now clonable (replace `IP_ADDRESS` with appropriate ip):

```bash
git clone ssh://git@IP_ADDRESS:/git/TestRepo.git
```
