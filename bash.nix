{ lib, config, pkgs, modulesPath, ... }:

# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different of some terminals.
# For example, I see 'Bold Red' as 'orange' on my screen,
# hence the 'Green' 'BRed' 'Red' sequence I often use in my prompt.

# Normal Colors
let
  Black="\\e[0;30m";        # Black
  Red="\\e[0;31m";          # Red
  Green="\\e[0;32m";        # Green
  Yellow="\\e[0;33m";       # Yellow
  Blue="\\e[0;34m";         # Blue
  Purple="\\e[0;35m";       # Purple
  Cyan="\\e[0;36m";         # Cyan
  White="\\e[0;37m";        # White

  # Bold
  BBlack="\\e[1;30m";       # Black
  BRed="\\e[1;31m";         # Red
  BGreen="\\e[1;32m";       # Green
  BYellow="\\e[1;33m";      # Yellow
  BBlue="\\e[1;34m";        # Blue
  BPurple="\\e[1;35m";      # Purple
  BCyan="\\e[1;36m";        # Cyan
  BWhite="\\e[1;37m";       # White

  # Background
  On_Black="\\e[40m";       # Black
  On_Red="\\e[41m";         # Red
  On_Green="\\e[42m";       # Green
  On_Yellow="\\e[43m";      # Yellow
  On_Blue="\\e[44m";        # Blue
  On_Purple="\\e[45m";      # Purple
  On_Cyan="\\e[46m";        # Cyan
  On_White="\\e[47m";       # White

  NC="\\e[m";               # Color Reset

  ALERT="${BWhite}${On_Red}"; # Bold White on red background
in
{
  environment.etc."inputrc".text = lib.mkForce (
    builtins.readFile "${modulesPath}/programs/bash/inputrc" + ''
      set completion-ignore-case on
    ''
  );

  environment.systemPackages = with pkgs; [
    fortune
  ];

  programs.bash = {
    completion.enable = true;


    #-------------------------------------------------------------
    # Shell Prompt
    #-------------------------------------------------------------

    # Current Format: [TIME USER@HOST PWD] >
    # TIME:
    #    Green     == machine load is low
    #    Orange    == machine load is medium
    #    Red       == machine load is high
    #    ALERT     == machine load is very high
    # USER:
    #    Cyan      == normal user
    #    Orange    == SU to user
    #    Red       == root
    # HOST:
    #    Cyan      == local session
    #    Green     == secured remote connection (via ssh)
    #    Red       == unsecured remote connection
    # PWD:
    #    Green     == more than 10% free disk space
    #    Orange    == less than 10% free disk space
    #    ALERT     == less than 5% free disk space
    #    Red       == current user does not have write privileges
    #    Cyan      == current filesystem is size zero (like /proc)
    # >:
    #    White     == no background or suspended jobs in this shell
    #    Cyan      == at least one background job in this shell
    #    Orange    == at least one suspended job in this shell
    #
    #    Command is added to the history file each time you hit enter,
    #    so it's available to all shells (using 'history -a').
    promptInit = ''
      # Test connection type:
      if [ -n "''${SSH_CONNECTION}" ]; then
          CNX="${Green}"        # Connected on remote machine, via ssh (good).
      elif [[ "''${DISPLAY%%:0*}" != "" ]]; then
          CNX="${ALERT}"        # Connected on remote machine, not via ssh (bad).
      else
          CNX="${BCyan}"        # Connected on local machine.
      fi

      # Test user type:
      export USER_ACTUAL=$(id -u -n)
      if [[ ''${USER_ACTUAL} == "root" ]]; then
          SU="${Red}"           # User is root.
      elif [[ ''${USER_ACTUAL} != $LOGNAME ]]; then
          SU="${BRed}"          # User is not login user.
      else
          SU="${BCyan}"         # User is normal (well ... most of us are).
      fi

      NCPU=$(grep -c 'processor' /proc/cpuinfo)    # Number of CPUs
      SLOAD=$(( 100*''${NCPU} ))        # Small load
      MLOAD=$(( 200*''${NCPU} ))        # Medium load
      XLOAD=$(( 400*''${NCPU} ))        # Xlarge load

      # Returns system load as percentage, i.e., '40' rather than '0.40)'.
      function load()
      {
          local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')
          # System load of the current host.
          echo $((10#$SYSLOAD))       # Convert to decimal.
      }

      # Returns a color indicating system load.
      function load_color()
      {
          local SYSLOAD=$(load)
          if [ ''${SYSLOAD} -gt ''${XLOAD} ]; then
              echo -en "${ALERT}"
          elif [ ''${SYSLOAD} -gt ''${MLOAD} ]; then
              echo -en "${Red}"
          elif [ ''${SYSLOAD} -gt ''${SLOAD} ]; then
              echo -en "${BRed}"
          else
              echo -en "${Green}"
          fi
      }

      # Returns a color according to free disk space in $PWD.
      function disk_color()
      {
          if [ ! -w "''${PWD}" ] ; then
              echo -en "${Red}"
              # No 'write' privilege in the current directory.
          elif [ -s "''${PWD}" ] ; then
              local used=$(command df -P "$PWD" |
                         awk 'END {print $5} {sub(/%/,"")}')
              if [ ''${used} -gt 95 ]; then
                  echo -en "${ALERT}"           # Disk almost full (>95%).
              elif [ ''${used} -gt 90 ]; then
                  echo -en "${BRed}"            # Free disk space almost gone.
              else
                  echo -en "${Green}"           # Free disk space is ok.
              fi
          else
              echo -en "${Cyan}"
              # Current directory is size '0' (like /proc, /sys etc).
          fi
      }

      # Returns a color according to running/suspended jobs.
      function job_color()
      {
          if [ $(jobs -s | wc -l) -gt "0" ]; then
              echo -en "${BRed}"
          elif [ $(jobs -r | wc -l) -gt "0" ] ; then
              echo -en "${BCyan}"
          fi
      }

      # Adds some text in the terminal frame (if applicable).

      # Now we construct the prompt.
      PROMPT_COMMAND="history -a"
      case ''${TERM} in
        *term* | rxvt | linux)
              PS1="\[\$(load_color)\][\A\[${NC}\] "
              # Time of day (with load info):
              PS1="\[\$(load_color)\][\A\[${NC}\] "
              # User@Host (with connection type info):
              PS1=''${PS1}"\[''${SU}\]\u\[${NC}\]@\[''${CNX}\]\h\[${NC}\] "
              # PWD (with 'disk space' info):
              PS1=''${PS1}"\[\$(disk_color)\]\w]\[${NC}\] "
              # Prompt (with 'job' info):
              PS1=''${PS1}"\[\$(job_color)\]\n>\[${NC}\] "
              ;;
          *)
              PS1="(\A \u@\h \w)\n > " # --> PS1="(\A \u@\h \w) > "
                                       # --> Shows full pathname of current dir.
              ;;
      esac



      export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
      export HISTIGNORE="&:bg:fg:ll:h"
      export HISTTIMEFORMAT="$(echo -e "${BCyan}")[%d/%m %H:%M:%S]$(echo -e "${NC}") "
      export HISTCONTROL=ignoredups
      export HOSTFILE=$HOME/.hosts    # Put a list of remote hosts in ~/.hosts
    '';

    interactiveShellInit = ''
      #-------------------------------------------------------------
      # Some settings
      #-------------------------------------------------------------
      ulimit -S -c 0      # Don't want coredumps.
      set -o notify
      set -o noclobber
      set -o ignoreeof

      # Enable options:
      shopt -s dotglob
      shopt -s cdspell
      shopt -s cdable_vars
      shopt -s checkhash
      shopt -s checkwinsize
      shopt -s sourcepath
      shopt -s no_empty_cmd_completion
      shopt -s cmdhist
      shopt -s histappend histreedit histverify
      shopt -s extglob       # Necessary for programmable completion.

      # Disable options:
      shopt -u mailwarn
      unset MAILCHECK        # Don't want my shell to warn me of incoming mail.

      #-------------------------------------------------------------
      # Greeting + motd
      #-------------------------------------------------------------

      echo -e "${BCyan}This is BASH ${BRed}''${BASH_VERSION%.*}${BCyan}\
      - DISPLAY on ${BRed}$DISPLAY${NC}\n"
      date
      #if ! [ -z $(command -v fortune) ]; then
          fortune -s           # Makes our day a bit more fun.... :-)
      #fi

      function _exit()              # Function to run upon exit of shell.
      {
          echo -e "${BRed}Hasta la vista, baby${NC}"
      }
      trap _exit EXIT


      #-------------------------------------------------------------
      # Tailoring 'less'
      #-------------------------------------------------------------

      export PAGER=less
      export LESSCHARSET='latin1'
      export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
                      # Use this if lesspipe.sh exists.
      export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \
      :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'

      # LESS man page colors (makes Man pages more readable).
      export LESS_TERMCAP_mb=$'\E[01;31m'
      export LESS_TERMCAP_md=$'\E[01;31m'
      export LESS_TERMCAP_me=$'\E[0m'
      export LESS_TERMCAP_se=$'\E[0m'
      export LESS_TERMCAP_so=$'\E[01;44;33m'
      export LESS_TERMCAP_ue=$'\E[0m'
      export LESS_TERMCAP_us=$'\E[01;32m'

      #-------------------------------------------------------------
      # File & strings related functions:
      #-------------------------------------------------------------

      function swap()
      { # Swap 2 filenames around, if they exist (from Uzi's bashrc).
          local TMPFILE=tmp.$$

          [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
          [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
          [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

          mv "$1" $TMPFILE
          mv "$2" "$1"
          mv $TMPFILE "$2"
      }

      function extract()      # Handy Extract Program
      {
          if [ -f $1 ] ; then
              case $1 in
                  *.tar.bz2)   tar xvjf $1     ;;
                  *.tar.gz)    tar xvzf $1     ;;
                  *.bz2)       bunzip2 $1      ;;
                  *.rar)       unrar x $1      ;;
                  *.gz)        gunzip $1       ;;
                  *.tar)       tar xvf $1      ;;
                  *.tbz2)      tar xvjf $1     ;;
                  *.tgz)       tar xvzf $1     ;;
                  *.zip)       unzip $1        ;;
                  *.Z)         uncompress $1   ;;
                  *.7z)        7z x $1         ;;
                  *)           echo "'$1' cannot be extracted via >extract<" ;;
              esac
          else
              echo "'$1' is not a valid file!"
          fi
      }

      # Creates an archive (*.tar.gz) from given directory.
      function maketar() { tar cvzf "''${1%%/}.tar.gz"  "''${1%%/}/"; }

      # Create a ZIP archive of a file or folder.
      function makezip() { zip -r "''${1%%/}.zip" "$1" ; }

      # Make your directories and files access rights sane.
      function sanitize() { chmod -R u=rwX,g=rX,o= "$@" ;}


      #-------------------------------------------------------------
      # Process/system related functions:
      #-------------------------------------------------------------

      function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
      function pp() { my_ps f | awk '!/awk/ && $0~var' var=''${1:-".*"} ; }

      function killps()   # kill by process name
      {
          local pid pname sig="-TERM"   # default signal
          if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
              echo "Usage: killps [-SIGNAL] pattern"
              return;
          fi
          if [ $# = 2 ]; then sig=$1 ; fi
          for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat=''${!#} )
          do
              pname=$(my_ps | awk '$1~var { print $5 }' var=$pid )
              if ask "Kill process $pid <$pname> with signal $sig?"
                  then kill $sig $pid
              fi
          done
      }

      function mydf()         # Pretty-print of 'df' output.
      {                       # Inspired by 'dfc' utility.
          for fs ; do

              if [ ! -d $fs ]
              then
                echo -e $fs" :No such file or directory" ; continue
              fi

              local info=( $(command df -P $fs | awk 'END{ print $2,$3,$5 }') )
              local free=( $(command df -Pkh $fs | awk 'END{ print $4 }') )
              local nbstars=$(( 20 * ''${info[1]} / ''${info[0]} ))
              local out="["
              for ((j=0;j<20;j++)); do
                  if [ ''${j} -lt ''${nbstars} ]; then
                     out=$out"*"
                  else
                     out=$out"-"
                  fi
              done
              out=''${info[2]}" "$out"] ("$free" free on "$fs")"
              echo -e $out
          done
      }

      function ii()   # Get current host related info.
      {
          echo -e "\nYou are logged on ${BRed}$HOST"
          echo -e "\n${BRed}Additionnal information:$NC " ; uname -a
          echo -e "\n${BRed}Users logged on:$NC " ; w -hs |
                   cut -d " " -f1 | sort | uniq
          echo -e "\n${BRed}Current date :$NC " ; date
          echo -e "\n${BRed}Machine stats :$NC " ; uptime
          echo -e "\n${BRed}Memory stats :$NC " ; free
          echo -e "\n${BRed}Diskspace :$NC " ; mydf / $HOME
          echo -e "\n${BRed}Local IP Address :$NC" ; my_ip
          echo -e "\n${BRed}Open connections :$NC "; netstat -pan --inet;
          echo
      }

      #-------------------------------------------------------------
      # Misc utilities:
      #-------------------------------------------------------------

      function repeat()       # Repeat n times command.
      {
          local i max
          max=$1; shift;
          for ((i=1; i <= max ; i++)); do  # --> C-like syntax
              eval "$@";
          done
      }


      function ask()          # See 'killps' for example of use.
      {
          echo -n "$@" '[y/n] ' ; read ans
          case "$ans" in
              y*|Y*) return 0 ;;
              *) return 1 ;;
          esac
      }

      function corename()   # Get name of app that created a corefile.
      {
          for file ; do
              echo -n $file : ; gdb --core=$file --batch | head -1
          done
      }

      function element_in()   # Return true if element is in array
      {
          local matchitem=$1
          local list="''${@:2}"
          local item

          for item in $list
          do
              if [ "$matchitem" == "$item" ]; then
                  return 0
              fi
          done
          return 1
      }

      # This is a slightly modified version of the script found at
      #    https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Ensuring_that_the_groups_are_valid
      # It adds a tab to make the output prettier and sorts the output per-group
      function show_iommu()
      {
        shopt -s nullglob;
        for d in /sys/kernel/iommu_groups/*/devices/*;
        do
            n="''${d#*/iommu_groups/*}";
            n="''${n%%/*}";
            printf 'IOMMU Group %s \t' "$n";
            lspci -nns "''${d##*/}";
        done | sort -h -k 3
      }
    '';

    shellAliases = {
      debug="set -o nounset; set -o xtrace";

      #-------------------
      # Personnal Aliases
      #-------------------
      e="emacsclient";
      E="SUDO_EDITOR=\"emacsclient -a emacs\" sudoedit";
      emacsrescue="pkill -SIGUSR2 emacs"; # After this, do M-x toggle-debug-on-quit

      rm="rm -i";
      cp="cp -i";
      mv="mv -i";
      # -> Prevents accidentally clobbering files.
      mkdir="mkdir -p";

      h="history";
      j="jobs -l";
      which="type -a";
      ".."="cd ..";

      # Pretty-print of some PATH variables:
      path=''echo -e ''${PATH//:/\\n}"'';
      libpath=''echo -e ''${LD_LIBRARY_PATH//:/\\n}'';

      du="du -kh";    # Makes a more readable output.
      df="df -kTh";

      #-------------------------------------------------------------
      # The "ls" family (this assumes you use a recent GNU ls).
      #-------------------------------------------------------------
      # Add colors for filetype and  human-readable sizes by default on "ls":
      ls="ls -h --color";
      lx="ls -lXB";         #  Sort by extension.
      lk="ls -lSr";         #  Sort by size, biggest last.
      lt="ls -ltr";         #  Sort by date, most recent last.
      lc="ls -ltcr";        #  Sort by/show change time,most recent last.
      lu="ls -ltur";        #  Sort by/show access time,most recent last.

      # The ubiquitous "ll": directories first, with alphanumeric sorting:
      ll="ls -lv --group-directories-first";
      lm="ll |more";        #  Pipe through "more"
      lr="ll -R";           #  Recursive ls.
      la="ll -A";           #  Show hidden files.
      tree="tree -Csuh";    #  Nice alternative to "recursive ls" ...
    };
  };
}
