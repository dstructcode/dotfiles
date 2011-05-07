# .zshrc - zsh configuration file
#
# Randy Morris (rson451@gmail.com)
# Jason Dana (sheut.ka@gmail.com)
#
# CREATED:  a long time ago
# MODIFIED: 2011-05-07 13:10

# simple settings {{{
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
autoload -U compinit && compinit
autoload -U colors && colors
setopt nobeep nohistbeep nolistbeep

#}}}

# environ vars {{{
export PATH=$PATH:~/bin
export BC_ENV_ARGS=~/.bcrc
export EDITOR=/usr/bin/vim
LS_COLORS='rs=0:di=00;34:ln=00;36:mh=00:pi=40;33:so=00;35:do=00;35:bd=40;33;00:cd=40;33;00:or=40;31;00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.tlz=00;31:*.txz=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.dz=00;31:*.gz=00;31:*.lz=00;31:*.xz=00;31:*.bz2=00;31:*.bz=00;31:*.tbz=00;31:*.tbz2=00;31:*.tz=00;31:*.deb=00;31:*.rpm=00;31:*.jar=00;31:*.rar=00;31:*.ace=00;31:*.zoo=00;31:*.cpio=00;31:*.7z=00;31:*.rz=00;31:*.jpg=00;35:*.jpeg=00;35:*.gif=00;35:*.bmp=00;35:*.pbm=00;35:*.pgm=00;35:*.ppm=00;35:*.tga=00;35:*.xbm=00;35:*.xpm=00;35:*.tif=00;35:*.tiff=00;35:*.png=00;35:*.svg=00;35:*.svgz=00;35:*.mng=00;35:*.pcx=00;35:*.mov=00;35:*.mpg=00;35:*.mpeg=00;35:*.m2v=00;35:*.mkv=00;35:*.ogm=00;35:*.mp4=00;35:*.m4v=00;35:*.mp4v=00;35:*.vob=00;35:*.qt=00;35:*.nuv=00;35:*.wmv=00;35:*.asf=00;35:*.rm=00;35:*.rmvb=00;35:*.flc=00;35:*.avi=00;35:*.fli=00;35:*.flv=00;35:*.gl=00;35:*.dl=00;35:*.xcf=00;35:*.xwd=00;35:*.yuv=00;35:*.cgm=00;35:*.emf=00;35:*.axv=00;35:*.anx=00;35:*.ogv=00;35:*.ogx=00;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS
#}}}

# aliases {{{
alias ls='ls --color=auto'
alias tree='tree -L 1 -C'
alias :q='exit'
alias sudo='command sudo '
alias shop='shop --pad 12'
alias gmutt='mutt -F $HOME/.muttrc.personal'
alias gitt='git ls-files -toc'
alias .f='cd ~/.config/dotfiles/'
alias pyc='find . -name "*.pyc" -delete; ls'
alias tmux='tmux -2'

$(which pacman-color &> /dev/null ) && alias pacman='pacman-color'
#}}}

# functions {{{

atop(){ #{{{
    SHOW=10
    DELAY=3;

    if [ $1 ]; then
        SHOW=$1
        if [ $2 ]; then
            DELAY=$2
        fi
    fi
    watch -n $DELAY "free; echo; uptime; echo; ps aux  --sort=-%cpu | head -n $(($SHOW+1)); echo; who"
}
#}}}

todo(){ #{{{
  todo_file=$HOME/.todo
  if [ -z $1 ]; then
    awk '{ i += 1; print i": "$0 }' $todo_file
    return
  fi

  case $1 in
    add|a|-a)
      echo $2 >> $todo_file
    ;;
    del|d|-d)
      if [ -z $2 ]; then
        read -q "reply?clear entire todo list? [y|N] "
        [ $reply = 'y' ] || return
      fi
      sed -i "$2d" $todo_file
    ;;
    search|s|-s)
      grep -ni --color=never $2 $todo_file | sed -e 's/:/: /'
    ;;
  esac
}
#}}}

set-title(){ #{{{
    builtin echo -ne "\ek$*\e\\"
}
#}}}

preexec(){ #{{{
    #if [[ -n $STY ]]; then
    if [[ $TERM =~ "screen" ]]; then
        TITLE=${$(echo $3 | sed -r 's/^command sudo ([^ ]*) .*/\1/;tx;s/^([^ ]*) +.*/\1/;s/^([^ ]*)$/\1/;:x;q')/#*\/}
        set-title $TITLE
    fi
}
#}}}

precmd(){ #{{{
    set-prompt
    if [[ $TERM =~ "screen" ]]; then
        TITLE=${0/#*\/}
        set-title $TITLE
    fi
}
#}}}

chpwd(){ #{{{
    set-prompt
    ls
}
#}}}

set-prompt(){ #{{{
    git-prompt
    PS1="%{$fg_no_bold[white]%}%~ $GIT_PROMPT%(?.%{$fg_no_bold[blue]%}:%{$fg_bold[blue]%}:%{$fg_bold[cyan]%}:.%{$fg_no_bold[magenta]%}:%{$fg_bold[red]%}:%{$fg_bold[magenta]%}:)%{$reset_color%} "
    RPROMPT="%(?.%{$fg_bold[cyan]%}:%{$fg_bold[blue]%}:%{$fg_no_bold[blue]%}:.%{$fg_bold[magenta]%}:%{$fg_bold[red]%}:%{$fg_no_bold[magenta]%}:) %{$fg_no_bold[white]%}%n@%m%{$reset_color%}"
} #}}}

git-prompt(){ #{{{
    if [ -d .git ]; then
        git_ref=$(git symbolic-ref HEAD 2>/dev/null)
        git_branch=${git_ref#refs/heads/}
        git_upstream=''

        # only do this if it's easy
        git_revs=($(git rev-list --count --left-right "@{upstream}"...HEAD 2>/dev/null))
        if [ $? -eq 0 ]; then
            [[ $git_revs[2] != "0" ]] && git_upstream+=":+$git_revs[2]"
            [[ $git_revs[1] != "0" ]] && git_upstream+=":-$git_revs[1]"
        fi
        GIT_PROMPT="(${git_branch}${git_upstream}) "
    else
        unset GIT_PROMPT
    fi
}
#}}}

#}}}

# make special keys work as expected {{{
bindkey "\e[1~" beginning-of-line
bindkey "\e[2~" quoted-insert
bindkey "\e[3~" up-history
bindkey "\e[4~" delete-char
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
bindkey "\eOd" backward-word
bindkey "\eOc" forward-word
bindkey "\e[A" history-search-backward
bindkey "\e[B" history-search-forward
#}}}

# convenience keys {{{
bindkey "^J" push-line
bindkey '^R' history-incremental-search-backward
#}}}

set-prompt

# launch X if logged into TTY1
if [[ $TTY == /dev/tty1 ]]; then
    exec /usr/bin/xinit
fi

# vim:foldlevel=0
