# UniversalCheatSheet
Contains various things that are useful for work but can be forgotten

## GPG Keys (e.g. for Maven Central via OSSRH)

```bash
gpg --gen-key

gpg --list-keys

// where XXXXXXXX is pub ..../XXXXXXXX from the --list-keys
gpg --keyserver hkp://pgp.mit.edu --send-keys XXXXXXXX
```

## Prepare for Maven Central (via OSSRH)

1. Open [Jira Ticket](https://issues.sonatype.org/secure/CreateIssue.jspa?issuetype=21&pid=10134)

Summary: lib description
Group Id: com.github.almasb
Project URL: https://github.com/AlmasB/PROJECT
SCM url: https://github.com/AlmasB/PROJECT.git

2. Prepare pom.xml (TODO: generic pom.xml)

3. Generate GPG key (if needed?)

## Maven Deploy

```bash
// -Dgpg.passphrase=XXXXXXX is not necessary if added to .m2/settings.xml as shown below
mvn clean deploy -Dgpg.passphrase=XXXXXXX
```

```
<server>
    <id>gpg.passphrase</id>
    <passphrase>XXXXXXX</passphrase>
</server>
```

## Typical 2-branch development release

1. pull request -> merge -> delete branch
2. local switch to master -> git pull
3. mvn clean deploy (if passphrase set via settings.xml)

## Test PRs locally

1. Get the PR

```
git fetch origin pull/PR_NUM/head:NEW_BRANCH_NAME
```

2. Switch to new branch

```
git checkout NEW_BRANCH_NAME
```

## Auto-deploying latest snapshot builds after successful Travis CI

1. Export your gpg keyring

```
gpg --export > all.gpg
```

2. Encrypt gpg key data using openssl (use openssl directly since travis seems broken on Windows)

```
// replace PASSWORD with pass to use for encrypting 
openssl aes-256-cbc -pass pass:PASSWORD -in all.gpg -out all.gpg.enc
```

3. Encrypt the PASSWORD using travis env vars

```
travis encrypt ENC_PASSWORD=PASSWORD --add env.global
```

4. Decrypt gpg key data on Travis

```
openssl aes-256-cbc -pass pass:$ENC_PASSWORD -in all.gpg.enc -out all.gpg -d

// quietly import gpg keyring
gpg -q --fast-import all.gpg
```

5. Add the following to travis_settings.xml, encrypting vars as needed,
where KEYNAME is the XXXXXXXX from gpg --list-keys

```
<profiles>
    <profile>
        <id>ossrh</id>
        <activation>
            <activeByDefault>true</activeByDefault>
        </activation>
        <properties>
            <gpg.executable>gpg</gpg.executable>
            <gpg.keyname>${env.GPG_KEYNAME}</gpg.keyname>
            <gpg.passphrase>${env.GPG_PASSPHRASE}</gpg.passphrase>
        </properties>
    </profile>
</profiles>
```

6. Deploy if not on master branch

```
if [ "$TRAVIS_BRANCH" != "master" ]; then mvn deploy --settings travis_settings.xml; fi
```

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

## Deploying to Heroku

First obtain Heroku account (and Heroku CLI?)

1. Create App
2. Create Github repo for that
3. Dashboard Heroku -> Deploy -> Github -> auto deploy from master

From now on pushing to that Github repo will result in auto deployment to Heroku

## Using VM as web-server

1. Install apache and start service
2. `firewall-cmd --add-service=http`
3. Using host, set network mode to NAT and port forward ip = empty, port = 8080 to ip = empty, port = 80
4. Connect using host's ip

## Bulk resize using imagemagick

```
cd images_dir/
mogrify -resize 16x12 -quality 100 -path ./new_resized *.jpg
```

## Bulk convert using imagemagick

```
for file in $PWD/*.png
    do
        filename=$(basename $file)
        magick "$file" "${filename%.png}.pdf"
    done
```

## Compile JNI .dll with Visual Studio 2019

0. `javac -h . YourNativeClass.java`
1. Open VS -> select DLL project.
2. Remove all headers (apart from pch.h) and source files.
3. Project properties -> General -> additional includes -> add `JDK/include` and `JDK/include/win32`.
4. Linker -> add any .lib files as appropriate.
5. Create a new header (.h) file and copy-paste javac-generated header file.
6. Create a new cpp (.cpp) file and implement the header.
7. Project -> Build gives a .dll file.

## Compile JNI .so with g++

0. ...
1. `g++ -c -fPIC -I ... file.cpp`
2. `g++ -shared -l ... -o libname.so`
