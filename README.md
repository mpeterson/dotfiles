# Dotfiles

The management system was taken from the [elegant solution](https://www.atlassian.com/git/tutorials/dotfiles) that [Nicola Paolucci](https://twitter.com/durdn) published with modifications to my taste.

## Install

`curl -Lks https://raw.githubusercontent.com/mpeterson/dotfiles/master/bootstrap-dotfiles.sh | /bin/bash`

## Usage

This will install all dotfiles to your home directory, making backups as appropriate in `.dotfiles-backup`.

From here forward there is the alias `dotfiles` which is a very special `git` alias, as explained on the Atlassian site. The idea is basically to use `dotfiles` as if using `git`. 
