#! /bin/sh


######################################################################
#
# SHELLSHOCCAR.SH : A Installer of Shellshoccar Command set
#
# What is Shellshoccar command set?
# 
# It is an additional set of commands for shellscript-programming.
# It makes shellscript programming more powerful!
# All of the commands are written within the POSIX specification.
# It means that the commands and the programs using only that get
# STRONGLY COMPATIBLITY and PORTABILITY and SUSTAINABILITY!!!
#
# Usage : shellshoccar.sh [--prefix=/PATH/TO/INSTALL/DIR] <install|uninstall>
#
# Written by Rich Mikan (richmikan[at]richlab.org) at 2016/06/21
#
# This is a public-domain software. It measns that all of the people
# can use this with no restrictions at all. By the way, I am fed up
# the side effects which are broght about by the major licenses.
#
######################################################################

# ===== FUNCTIONS ====================================================

# --- FUNC: print the usage and exit ---------------------------------
print_usage_and_exit () {
  cat <<-__USAGE 1>&2
	Usage   : ${0##*/} [--prefix=/PATH/TO/INSTALL/DIR] <install|uninstall>
	Version : Tue Jun 21 15:51:53 JST 2016
__USAGE
  exit 1
}


# ===== PREPARATION ==================================================

# --- initialize -----------------------------------------------------
set -u
PATH="/usr/bin:/bin:$PATH"
IFS=$(printf ' \t\n_'); IFS=${IFS%_}
export IFS LC_ALL=C LANG=C PATH
umask 0000

# --- default values -------------------------------------------------
Dir_prefix='/usr/local/shellshoccar'
mode=''

# --- parse the arguments --------------------------------------------
while [ $# -gt 0 ]; do
  case "${1:-}" in
    --prefix=*)       Dir_prefix=$(printf '%s' "${1#--prefix=}" | tr -d '\n')
                      shift
                      ;;
    install)          mode='install'
                      shift
                      ;;
    uninstall)        mode='uninstall'
                      shift
                      ;;
    *)                print_usage_and_exit
                      ;;
  esac
done
case "$mode" in '') print_usage_and_exit;; esac


# ===== MAIN (common) ================================================

case "$Dir_prefix" in /*) :;; *) Dir_prefix="./$Dir_prefix";; esac
File_instlog="${Dir_prefix%/}/log/shellshoccar_inst.log"


# ===== MAIN (for uninstaill) ========================================

# --- start of the block ---------------------------------------------
case "$mode" in uninstall)

# --- confirm --------------------------------------------------------
[ -f "$File_instlog" ] || {
  echo "${0##*/}: No installing record! (make sure the directory)" 1>&2
  exit 1
}

# --- uninstall ------------------------------------------------------
rm -rf "$Dir_prefix" || {
  echo "${0##*/}: Failed to uninstall" 1>&2
  exit 1
}
exit 0

# --- end of the block -----------------------------------------------
;; esac


# ===== MAIN (for instaill) ==========================================

# --- start of the block ---------------------------------------------
case "$mode" in install)

# --- make target directories ----------------------------------------
mkdir -p "${Dir_prefix%/}/bin" "${Dir_prefix%/}/log" "${Dir_prefix%/}/tmp" || {
  echo "${0##*/}: Cannot make the directory of Shellshoccar" 1>&2
  exit 1
}
cd "${Dir_prefix%/}/tmp" || {
  echo "${0##*/}: Not enough permission to install this to $Dir_prefix" 1>&2
  exit 1
}
echo 1 > 'permissioncheck' 2>/dev/null || {
  echo "${0##*/}: Not enough permission to install this to $Dir_prefix" 1>&2
  exit 1
}
rm -rf *

# --- A) if git command is ready, install with it --------------------
if type git >/dev/null 2>&1; then
  # A-01) prepare
  ok=0
  ng=0
  # A-11) install "Open usp Tukubai clone"
  fSuccess=0
  while :; do
    git clone https://github.com/ShellShoccar-jpn/Open-usp-Tukubai.git || break
    mv -f Open-usp-Tukubai/COMMANDS.SH/* ../bin || break
    fSuccess=1
  break; done
  case $fSuccess in
    0) echo "${0##*/}: Failed to install \"Open usp Tukubai clone\"" 1>&2
       ng=$((ng+1));;
    *) ok=$((ok+1));;
  esac
  rm -rf "${Dir_prefix%/}/tmp/"*
  # A-12) install "misc-tools"
  fSuccess=0
  while :; do
    git clone https://github.com/ShellShoccar-jpn/misc-tools.git || break
    mv -f misc-tools/[a-z]* ../bin || break
    fSuccess=1
  break; done
  case $fSuccess in
    0) echo "${0##*/}: Failed to install \"misc-tools\"" 1>&2
       ng=$((ng+1));;
    *) ok=$((ok+1));;
  esac
  rm -rf "${Dir_prefix%/}/tmp/"*
  # A-13) install "Parsrs"
  fSuccess=0
  while :; do
    git clone https://github.com/ShellShoccar-jpn/Parsrs.git || break
    mv -f Parsrs/[a-z]*  ../bin || break
    fSuccess=1
  break; done
  case $fSuccess in
    0) echo "${0##*/}: Failed to install \"Parsrs\"" 1>&2
       ng=$((ng+1));;
    *) ok=$((ok+1));;
  esac
  rm -rf "${Dir_prefix%/}/tmp/"*
  # A-99) finish with reporting
  rm -rf "${Dir_prefix%/}/tmp"
  case $ng in
    0) s='All command sets are installed successfully'
       ret=0
       ;;
    *) s="$ng command set(s) is/are failed to install"
       ret=1
       ;;
  esac
  echo "*** $s" 1>&2
  date "+%Y/%m/%d-%H:%M:%S $s" >> "$File_instlog"
  case $ret in 0)
    cd ../bin
    echo "Finally, Add the directory \"$(pwd)\" to \$PATH" 1>&2;;
  esac
  exit $ret
fi

# --- B) if unzip and (curl || wget) commands are ready, install with them
while type unzip >/dev/null 2>&1; do
  # B-01) prepare
  ok=0
  ng=0
  type curl >/dev/null 2>&1 || type wget >/dev/null 2>&1 || break
  # B-11) install "Open usp Tukubai clone"
  fSuccess=0
  while :; do
    s='https://github.com/ShellShoccar-jpn/Open-usp-Tukubai/archive/master.zip'
    if type curl >/dev/null 2>&1; then
      curl -f -L "$s" > dlfile.zip
    else
      wget -O -  "$s" > dlfile.zip
    fi
    case $? in [!0]*) break;; esac
    unzip dlfile.zip || break
    chmod +x Open-usp-Tukubai-master/COMMANDS.SH/*
    mv -f Open-usp-Tukubai-master/COMMANDS.SH/* ../bin || break
    fSuccess=1
  break; done
  case $fSuccess in
    0) echo "${0##*/}: Failed to install \"Open usp Tukubai clone\"" 1>&2
       ng=$((ng+1));;
    *) ok=$((ok+1));;
  esac
  rm -rf "${Dir_prefix%/}/tmp/"*
  # B-12) install "misc-tools"
  fSuccess=0
  while :; do
    s='https://github.com/ShellShoccar-jpn/misc-tools/archive/master.zip'
    if type curl >/dev/null 2>&1; then
      curl -f -L "$s" > dlfile.zip
    else
      wget -O -  "$s" > dlfile.zip
    fi
    case $? in [!0]*) break;; esac
    unzip dlfile.zip || break
    chmod +x misc-tools-master/COMMANDS.SH/*
    mv -f misc-tools-master/* ../bin || break
    fSuccess=1
  break; done
  case $fSuccess in
    0) echo "${0##*/}: Failed to install \"misc-tools\"" 1>&2
       ng=$((ng+1));;
    *) ok=$((ok+1));;
  esac
  rm -rf "${Dir_prefix%/}/tmp/"*
  # B-13) install "Parsrs"
  fSuccess=0
  while :; do
    s='https://github.com/ShellShoccar-jpn/Parsrs/archive/master.zip'
    if type curl >/dev/null 2>&1; then
      curl -f -L "$s" > dlfile.zip
    else
      wget -O -  "$s" > dlfile.zip
    fi
    case $? in [!0]*) break;; esac
    unzip dlfile.zip || break
    chmod +x Parsrs-master/COMMANDS.SH/*
    mv -f Parsrs-master/* ../bin || break
    fSuccess=1
  break; done
  case $fSuccess in
    0) echo "${0##*/}: Failed to install \"Parsrs\"" 1>&2
       ng=$((ng+1));;
    *) ok=$((ok+1));;
  esac
  rm -rf "${Dir_prefix%/}/tmp/"*
  # A-99) finish with reporting
  rm -rf "${Dir_prefix%/}/tmp"
  case $ng in
    0) s='All command sets are installed successfully'
       ret=0
       ;;
    *) s="$ng command set(s) is/are failed to install"
       ret=1
       ;;
  esac
  echo "*** $s" 1>&2
  date "+%Y/%m/%d-%H:%M:%S $s" >> "$File_instlog"
  case $ret in 0)
    cd ../bin
    echo "Finally, Add the directory \"$(pwd)\" to \$PATH" 1>&2;;
  esac
  exit $ret
break; done

# --- C) Show error message when could not install -------------------
cat <<-__ERRORMESSAGE 1>&2
  *** To install this, it is required the following commands
  
  (A) "git" command, otherwise
  (B) "unzip" command and either "curl" or "wget" command
__ERRORMESSAGE
exit 1

# --- end of the block -----------------------------------------------
;; esac
