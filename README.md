# minecraft-project

2022 Minecraft server project

# How to use this?

This is a set of scripts (Bash / Terraform), resources (e.g. systemd services) and one Spigot plugin (SimpleNotepad).

0. Don't forget to clone the repo!
```bash
git clone https://github.com/Linux-Wizards/minecraft-project.git
cd minecraft-project
```

1. You can compile SimpleNotepad.
```bash
$ cd SimpleNotepad/
$ mvn install
```
The compiled .jar file will be in `target/simplenotepad-1.0-SNAPSHOT.jar`.

2. You can use the Terraform scripts to provision appropriate virtual machines in Oracle Cloud (Free Tier).
```bash
$ zip -r Terraform/ terraform.zip
```
You will upload the .zip file to Oracle Cloud. More detailed instructions are in `Terraform/README.org`.
