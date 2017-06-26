# Enable ssh-agent for ssh keys
if [ -f ~/.agent.env ]; then
    . ~/.agent.env >/dev/null
    if ps x | grep -v grep | grep $SSH_AGENT_PID ; then
       echo "ssh-agent added"
    else
        #echo "Stale agent file found. Spawning new agent..."
        eval `ssh-agent |tee ~/.agent.env`
    fi
else
    #echo "Starting ssh-agent..."
    eval `ssh-agent |tee ~/.agent.env`
    ssh-add ~/.ssh/id_rsa
fi

stty -ixon

##common command {{{
alias aroot='adb root'
alias remount='adb remount'
alias ashell='adb shell'
alias fboot='fastboot reboot'
alias fmode='adb reboot-bootloader'
alias catkmsg='adb shell cat /proc/kmsg'
alias mkubt='make -j8 bootloader'
alias mkchipram='make chipram'
alias mkbtimage='make bootimage'
alias mksysimage='make -j8 systemimage'
alias c="clear"
alias ..="cd .."
alias ...="cd ../../"
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"
alias catmeminfo='adb shell cat proc/meminfo'
alias watchmeminfo='watch -n 1 adb shell cat proc/meminfo'
alias catvmalloc='adb shell cat proc/vmallocinfo'
alias catbuddyinfo='adb shell cat proc/buddyinfo'
alias catslabinfo='adb shell cat proc/slabinfo'
alias catadj='adb shell cat /sys/module/lowmemorykiller/parameters/adj'
alias catminfree='adb shell cat /sys/module/lowmemorykiller/parameters/minfree'
alias catmailmem='adb shell cat /sys/kernel/debug/mali0/gpu_memory'
alias catmemreseved='adb shell cat /sys/kernel/debug/memblock/reserved'
alias catpageusage='adb shell cat /d/page_recorder/Usage_rank'
##}}}

#git command alias {{{
alias gs='git status .'
alias gc='git checkout'
alias gco='git commit'
alias gd='git diff'
alias gl='git log .'
alias ga='git add'
alias gp='git push'
alias gpl='git pull'
##}}}

alias mygrep="find .|xargs grep --color -ri -n "$1""

alias  statistics_modify="awk -F '/' '{print $2}' $1|uniq -c"

update_gcc_version() {

	sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 20
	sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.6 20
	sudo update-alternatives --config gcc
	sudo update-alternatives --config g++
}

update_gcc_version_4_8() {

	sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 20
	sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 20
	sudo update-alternatives --config gcc
	sudo update-alternatives --config g++
}
check_modfiy() {

		modify_file_buffer=$(tempfile)
		timestamps=$(date +%y%m%d%H%M)
		modify_file_list=$(pwd)/modify_file_list$timestamps
		modify_info_list=$(pwd)/modify_info_list$timestamps

		git log  --pretty=format:'%H %ae' .| grep -F '@spreadtrum.com' | while read commit author 
	do
		echo -n .
		git show $commit | grep '^+++ b' | sed 's/+++ b//' | while read file
	do
		echo $file >> $modify_file_buffer
		echo -e "$commit\t$author\t$file" >> $modify_info_list
	done
done

echo done!

sort $modify_file_buffer | uniq > $modify_file_list 

}

check_intel_modfiy() {
		modify_file_buffer=$(tempfile)
		timestamps=$(date +%y%m%d%H%M)
		modify_file_list=$(pwd)/modify_file_list$timestamps
		modify_info_list=$(pwd)/modify_info_list$timestamps

		git log  --pretty=format:'%H %ae' .| grep -F '@intel.com' | while read commit author 
	do
		echo -n .
		git show $commit | grep '^+++ b' | sed 's/+++ b//' | while read file
	do
		echo $file >> $modify_file_buffer
		echo -e "$commit\t$author\t$file" >> $modify_info_list
	done
done

echo done!

sort $modify_file_buffer | uniq > $modify_file_list 

}

function cgrep() {
	find . -type  f  \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' \) -print0 | xargs -0 grep --color -n "$@"

}

function jgrep()
{
    find .  -type f -name "*\.java" -print0 | xargs -0 grep --color -n "$@"
}

function mgrep()
{
    find .  -type f -name "*.mk" -print0 | xargs -0 grep --color -n "$@"
}

function sgrep()
{
    find .  -type f -name "*.S" -print0 | xargs -0 grep --color -n "$@"
}

function rcgrep()
{
    find .  -type f -name "*\.rc" -print0 | xargs -0 grep --color -n "$@"
}
function kgrep()
{
    find .  -type f -name "*\Kconfig" -print0 | xargs -0 grep --color -n "$@"
}

check_all_modfiy() {
	for i in `ls -l | awk '/^d/{print $9}'`; do cd $i ; check_all_modfiy ; cd .. ; done
}

decompress() {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2) tar xjvf $1 ;;
		*.tar.gz) tar xvzf $1 ;;
	*.bz2) bunzip2 $1 ;;
*.rar) unrar ev $1 ;;
	*.gz) gunzip $1 ;;
*.tar) tar xvf $1 ;;
	*.tbz2) tar xvjf $1 ;;
*.tgz) tar xvzf $1 ;;
	*.zip) unzip $1 ;;
*.Z) uncompress $1 ;;
	*.7z) 7z xv $1 ;;
*.tar.xz) xz -dv $1;; 
*) echo "'$1' cannot be extracted via decompress()" ;;
	esac
else
	echo "'$1' is not a valid file"
fi

	}


export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
#export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/
export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH
export CLASSPATH=$CLASSPATH:.:$JAVA_HOME/lib:$JAVA_HOME/jre/lib

unset PROJ_INFO_MEMU_CHOICES
function sprd_add_proj_info()
{
	local new_proj_info=$1
    local c
    for c in ${PROJ_INFO_MEMU_CHOICES[@]} ; do
        if [ "$new_proj_info" = "$c" ] ; then
            return
        fi
    done
    PROJ_INFO_MEMU_CHOICES=(${PROJ_INFO_MEMU_CHOICES[@]} $new_proj_info)

}

sprd_add_proj_info sprdroid7.0_trunk_k44_pike2_zebu_dev
sprd_add_proj_info sprdroid7.0_trunk_k44
sprd_add_proj_info sprdroid7.0_trunk_k310

function sprd_print_proj_info_menu()
{
    echo
    echo "You're repo sync one of the following project ..."
    echo
    echo "Please choice one project to repo sync"

    local i=1
    local choice
    for choice in ${PROJ_INFO_MEMU_CHOICES[@]}
    do
        echo "     $i. $choice"
        i=$(($i+1))
    done

    echo
}

function sprd_start_repo_sync_proj()
{
	local answer
	local num_threads

    if [ "$1" ] ; then
        answer=$1
    else
       sprd_print_proj_info_menu 
        echo -n "Which would you choice like? [sprdroid6.0_trunk] "
        read answer
	fi

	local selection=

    if [ -z "$answer" ]
    then
       echo -n "You must choice one project to repo sync from PROJ_INFO_MENU_CHOICES"
	   return 1
    elif (echo -n $answer | grep -q -e "^[0-9][0-9]*$")
    then
        if [ $answer -le ${#PROJ_INFO_MEMU_CHOICES[@]} ]
        then
            selection=${PROJ_INFO_MEMU_CHOICES[$(($answer-1))]}
        fi
    elif (echo -n $answer | grep -q -e "^[^\-][^\-]*-[^\-][^\-]*$")
    then
        selection=$answer
    fi

    if [ -z "$selection" ]
    then
        echo
        echo "Invalid selection project info: $answer"
        return 1
	fi

	echo  "**************** Statr repo init the project warehouse *********************"
	repo init -u gitadmin@gitmirror.spreadtrum.com:android/platform/manifest.git -b $selection
	echo  "**************** End repo init the project warehouse   *********************"

	echo  "**************** Start repo sync all project           *********************"
	repo sync -j4 -d -c 
	echo  "**************** End repo sync all project             *********************"

}
