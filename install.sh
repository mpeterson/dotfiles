#!/bin/bash
#
# "Install" the files from the dotfiles repository by symlinking them from the # home directory.

# Show a quick help summary.
function usage {
  echo "Usage: $(basename "$0") [ --dry-run ] [ --prefix=$HOME ] [ --do-not-update ] [ --uninstall ]";
}

function update {
  echo 'UPDATING REPO >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
  $dry_run git pull
  $dry_run git submodule update --init --recursive --remote
  $dry_run git submodule foreach 'git clean -dfx'
  $dry_run git clean -dfx
  echo 'UPDATING REPO <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'
}

# Parse the command-line arguments.
is_dry_run=false;
is_uninstall=false;
do_not_update=false;
dry_run=;
target_dir="$HOME";
while (($#)); do
  case "$1" in
    --dry-run)
      is_dry_run=true;
      dry_run=echo;
      ;;
    --prefix=*)
      target_dir="${1#--prefix=}";
      ;;
    --help)
      usage;
      exit 0;
      ;;
    --do-not-update)
      do_not_update=true;
      ;;
    --uninstall)
      is_uninstall=true;
      do_not_update=true;
      ;;
    *)
      [ "$1" = '--' ] && shift;
      if (($#)); then
        # There are unexpected arguments.
        usage;
        exit 1;
      fi;
  esac;
  shift;
done;
if [ "$target_dir" = '~' ]; then
  target_dir=~;
fi;
if [[ "$target_dir" =~ ^/+$ ]]; then
  target_dir=/;
elif [[ "$target_dir" =~ ^(.*[^/]+)/+$ ]]; then
  target_dir="${BASH_REMATCH[1]}";
fi;

$is_dry_run && echo 'Dry run mode. Not actually executing anything.';
$do_not_update && echo 'Not updating dotfiles repository nor any submodule.';

$do_not_update || update;

echo 'INSTALLING >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
# Make sure the target directory is OK.
if [ -z "$target_dir" ]; then
  echo "The target directory prefix is empty.";
  exit 1;
elif [ "$target_dir" = '/' ]; then
  echo "I refuse to install into the root directory.";
  exit 1;
elif [ -d "$target_dir" ]; then
  if ! [ -w "$target_dir" ]; then
    echo "$target_dir is not a writable directory.";
    exit 1;
  fi;
elif [ -e "$target_dir" ]; then
  echo "$target_dir exists, but is not a writable directory.";
  exit 1;
elif ! $dry_run mkdir -p "$target_dir"; then
  echo "I cannot create a writable directory $target_dir";
  exit 1;
fi;

# Determine the absolute path to the source and target directories.
source_dir="$(cd "$(dirname "$0")" > /dev/null; pwd)";
$is_dry_run || target_dir="$(cd "$target_dir" > /dev/null; pwd)";

# Create the array of files to symlink.
source_files=();
ignored_files=(
  .gitignore
  .gitmodules
  install.sh
);
while read -d $'\0' file; do
  file="${file#./}";
  for ignored_file in "${ignored_files[@]}"; do
    [ "$file" = "$ignored_file" ] && continue 2;
  done;
  source_files+=("$file");
done < <(
  cd "$source_dir";
  # If Git is available, use "git ls-tree" to get a list of all files. If
  # Git is not available, resort to "find", which might yield more results
  # because of untracked files.
  git ls-tree --name-only -r -z HEAD 2> /dev/null ||
    find . -name '.git' -prune -o -type f -print0
);

# Check if any of the files already exist in the target directory, and if so,
# are not already the same as in this repository. Note that "file" can also
# mean "directory" here. Directories are compared recursively.
common_files=();
for file in "${source_files[@]}"; do
  if [ -L "$target_dir/$file" -o -e "$target_dir/$file" ]; then
    # If source and target point to the same file, it is OK to replace
    # the target.
    [ "$source_dir/$file" -ef "$target_dir/$file" ] && continue; 
    # If the contents of the two files is the same, it is OK to replace
    # the target.
    diff -rq "$source_dir/$file" "$target_dir/$file" > /dev/null 2>&1 && continue;

    # If we got this far, it means we should not overwrite the target
    # file without confirmation.
    common_files+=("$file");
  fi;
done;

# Show the files that will be overwritten.
backup_suffix=".dotfiles-$(date +'%Y%m%d-%H%M%S')";
num_conflicts=${#common_files[@]};
if [ $num_conflicts -gt 0 ]; then

  # Warn the user about potential dataloss.
  if [ $num_conflicts -eq 1 ]; then
    tput setaf 3;
    printf 'WARNING: there is a file of yours that conflicts with dotfiles.';
    tput sgr0;
    echo " Your file will be given the suffix $backup_suffix and" \
      "replaced by a symlink to dotfiles's:";
  else
    tput setaf 3;
    printf 'WARNING: there are files of yours that conflict with dotfiles.';
    tput sgr0;
    echo " Your files will be given the suffix $backup_suffix and" \
      "replaced by symlinks to dotfiles's:" ;
  fi;

  lbl_yours=" Yours:";
  lbl_dotfiles=" dotfiles:";
  if [ -t 1 ]; then
    # Colorize the output if stdout is not piped.
    lbl_yours="$(tput setaf 1)$lbl_yours";
    lbl_dotfiles="$(tput setaf 2)$lbl_dotfiles";
  fi;
  ls_labels=();
  ls_files=();
  for file in "${common_files[@]}"; do
    ls_labels+=("$lbl_yours" "$lbl_dotfiles");
    ls_files+=("$target_dir/$file" "$source_dir/$file");
  done;

  # "paste" merges lines from two files. Using process substitution, we give
  # it two files: one with a "Yours:" line and a "dotfiles:" for each file, and
  # one with the "ls" output for your target file and dotfiles's file. Use "-f"
  # to ensure that "ls" does not sort the files.
  paste -d ' ' \
    <(printf '%s\n' "${ls_labels[@]}") \
    <(ls -fdalF "${ls_files[@]}");
  tput sgr0;
  echo;

  # Make sure the user confirms his/her existing files will be renamed.
  read -p 'Would you like to continue? If so, please type "yes": ';
  case "$(tr '[:upper:]' '[:lower:]' <<< "$REPLY")" in
    'yes')
      # OK, the installation will proceed below.
      ;;
    'n'|'no')
      exit;
      ;;
    'y')
      echo 'For your own safety, you have to type "yes" in full.';
      echo 'Installation aborted.';
      exit 1;
      ;;
    *)
      [ -z "$REPLY" ] && echo;
      echo 'Invalid answer; presumed "no". Installation aborted.';
      exit 1;
  esac;
fi;

# Rename the conflicting files.
for file in "${common_files[@]}"; do
  $dry_run mv "$target_dir/$file" "$target_dir/$file$backup_suffix";
done;

# Determine the relative source directory for the symlinks.
IFS=/ read -a source_dir_parts <<< "$source_dir";
IFS=/ read -a target_dir_parts <<< "$target_dir";
num_common_directories=0;
for ((i = 1; i < ${#target_dir_parts[@]}; i++)); do
  if [ "${target_dir_parts[$i]}" != "${source_dir_parts[$i]}" ]; then
    break;
  fi;
  let num_common_directories++;
done;

if [ $num_common_directories -eq 0 ]; then
  relative_source_dir="$source_dir";
else
  relative_source_dir_parts=();
  for ((i = 0; i < ${#target_dir_parts[@]} - 1 - num_common_directories; i++)); do
    relative_source_dir_parts+=('..');
  done;
  for ((i = num_common_directories + 1; i < ${#source_dir_parts[@]}; i++)); do
    relative_source_dir_parts+=("${source_dir_parts[$i]}");
  done;
  printf -v relative_source_dir '%s/' "${relative_source_dir_parts[@]}";
  relative_source_dir="${relative_source_dir%/}";
fi;

# Install dotfiles by symlinking the files from the dotfiles repository.
has_created_links=false;
has_uninstalled=false;
for file in "${source_files[@]}"; do
  target="$target_dir/$file";
  target_container_dir="$(dirname "$target")";
  if ! [ -d "$target_container_dir" ]; then
    $dry_run mkdir -p "$target_container_dir" || continue;
  fi;

  # Determine the target for our symlinks, relative to the installation
  # directory if possible. (So "/home/janmoesen/.bashrc" links to
  # "src/dotfiles/.bashrc" rather than "/home/janmoesen/src/dotfiles/.bashrc" when
  # installing from "/home/janmoesen/src/dotfiles".)
  relative_source="$relative_source_dir";
  if [ "${relative_source:0:1}" != '/' ] && [[ "$file" =~ / ]]; then
    # If the file is not in the repository's root, we need to go up
    # additional levels for the relative path.
    IFS=/ read -a file_dir_parts <<< "$(dirname "$file")";
    for ((i = 0; i < ${#file_dir_parts[@]}; i++)); do
      relative_source="../$relative_source";
    done;
  fi;
  relative_source="$relative_source/$file";
  if [ ! -L "$target" -a $is_uninstall = false ]; then
    $dry_run ln -vs "$relative_source" "$target";
    has_created_links=true;
  elif [ -L "$target" -a $is_uninstall = true ]; then
    $dry_run rm -vrf "$target";
    [ "$target_container_dir" = "$HOME" -a -d "$target_container_dir" ] || $dry_run rm -fd "$target_container_dir";
    has_uninstalled=true;
  fi;
done;
echo 'INSTALLING <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'
$is_uninstall || $has_created_links || echo "All of dotfiles' files were symlinked already.";
$is_uninstall && $has_uninstalled && echo "All of dotfiles' files' symlinks were removed.";
echo 'Done.';

