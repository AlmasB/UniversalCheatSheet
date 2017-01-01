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