#! /bin/bash

##packages
inst_apache() {
	apt install apache2 -y
	systemctl enable apache2
	echo "Apache OK, ip: $(hostname -I)"
}

inst_mysql() {
	apt install mysql-server-8.0 -y
	echo "MySQL OK"
}


##grp creating
grp_adm(){
	mkdir -p /adm
	groupadd GRP_ADM
	chmod 770 /adm
	chown root:GRP_ADM /adm
	echo "ADM OK"
}

grp_sec(){
	mkdir -p /sec
	groupadd GRP_SEC
	chmod 770 /sec
	chown root:GRP_SEC /sec
	echo "SEC OK"
}

grp_sal(){
	mkdir -p /sal
	groupadd GRP_SAL
	chmod 770 /sal
	chown root:GRP_SAL /sal
	echo "SAL OK"
}

grp_acc(){
	mkdir -p /acc
	groupadd GRP_ACC
	chmod 770 /acc
	chown root:GRP_ACC /acc
	echo "ACC OK"
}


##User
add_user(){
	useradd "$1" -m -G "GRP_$2" -s /bin/bash
	echo "User $1 added in the group GRP_$2 "
}



##Menus
menu_grp(){
echo "Select the directory to be created:"
select opt in "Administrative" "Security" "Sales" "Accounting" "Finish" ; do
	case $opt in
  	 "Administrative") grp_adm ;  menu_grp ;;
	 "Security") grp_sec ; menu_grp ;;
         "Sales") grp_sal ; menu_grp ;;
         "Accounting") grp_acc ; menu_grp ;;
	 "Finish") break ;;
  	 *) echo "Invalid Option" ;;
	 esac
	break
done
}


menu_app1(){
echo "Select the system to be added: "
select opt in "Apache" "MySql" "Done" ; do
	case $opt in
	"Apache") inst_apache ; menu_app1 ;;
	"MySql") inst_mysql ; menu app_1 ;;
	"Done") break ;;
	*  ) echo "Invalid option"
	esac
	break
done
}


menu_user(){
	echo "---Register user--"

	##nome do usuario
	read -p "Name:  " username
	#selecionar grupo
	echo "Group:"
   	  select grupo in "ADM" "SAL" "SEC" "ACC" "CANCEL" ;do
		case $grupo in
			 "ADM" | "SAL" | "SEC" | "ACC")
				add_user "$username" "$grupo"
				read -p "press ENTER to continue..."
				break
				;;
			"cancel")
				echo "canceled!"
				break
				;;
			* ) 	echo "Invalid Option"
		esac
	  done

}



## MAIN
while true; do
    echo ""
    echo "=== MENU ==="
    select opt in "Create Group" "Register a New User" "Install Packages" "Finish"; do
        case $opt in
            "Create Group")    menu_grp  ;;
            "Register a New User") menu_user  ;;
	    "Install Packages") menu_app1 ;;
            "Finish")           exit 0 ;;
            *)                echo "Invalid Option!" ;;
        esac
	break
    done
done

