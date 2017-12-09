#!/bin/bash

check_err() {
	
	if [ $? -ne 0 ]; then
		echo -n $* >&2
		exit 2
	fi
}

install_depends_tools() {
	echo "================== start install_depends_tools =================="
	sudo apt-get install ctags cscope
	echo "================== end   install_depends_tools =================="
}

#config .bashrc
config_bashrc() {

	echo "================== start config bashrc ========================"
	if [ ! -f "bashrc_patch.sh" ] ;then
		echo "bashrc_patch do not exsit,Please check"
		exit 2
	else
		cat ./bashrc_patch.sh >> ~/.bashrc
	fi
	source ~/.bashrc
	echo "================== end  config bashrc ========================"
}

#install vim env
install_vim_env() {
	echo "================== start install vim env ====================="
	cd ./vim 
	check_err "vim directories do not exsit"
	./install.sh
	cd ../
	echo "================== end   install vim env ====================="
}

install_depends_tools
check_err "install_depends_tools failed"

#config_bashrc
#check_err "config .bashrc failed"

install_vim_env
check_err "install vim env failed"





