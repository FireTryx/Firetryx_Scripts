#!/bin/bash

# Define colors in BASH
RED='\033[1;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
LIGHT_BLUE='\033[0;36m'
NC='\033[0m' # Reset color

# Sudo/Root privileges ?
if [ "$(id -u)" != "0" ]; then
	echo -e "${RED}Veuillez exécuter ce script avec des privilèges root !${NC}" 1>&2
	exit 1
fi

sudo apt-get install fzf wget git unzip

# Java Installation function
java_installation() {
	case $1 in
		1) echo -e "Veuillez suivre ce tutoriel pour installer Java 16 -> ${YELLOW}https://www.tutorials24x7.com/java/how-to-install-java-16-on-ubuntu-2004-lts${NC}. Puis relancer le script." && exit;;
		2) sudo apt install -y openjdk-17-jdk ;;
		3) sudo apt install -y openjdk-21-jdk ;;
		4) clear && echo -e "${RED}Java n'as pas été installé, arrêt du script.${NC}" && exit ;;
		*) echo "Choix invalide. Installation de Java échouée." ;;
	esac
}

# Check a/o install Java
check_java_version() {

	java_version=$(java -version 2>&1 | grep version | awk -F '"' '{print $2}' | cut -d'.' -f1)

	if [ -z "$java_version" ]; then
		echo -e "${RED}Java n'est pas installé.${NC}"
		echo -e "Choisissez une version de Java à installer :"
		echo -e "* [1] Java 16"
		echo -e "* [2] Java 17"
		echo -e "* [3] Java 21"
		echo -e "* [4] Ne pas installer Java"
		read -p "Choisissez une option (1-4): " choix
		java_installation $choix
		check_java_version # Java function recall to check if java is installed/continue the script after installation of Java
	elif [ "$java_version" -eq 16 ]; then
		echo -e "${GREEN}Java 16 est installé. Aucun changement requis pour le script de démarrage.${NC}"
	elif [ "$java_version" -gt 16 ]; then
		echo -e "${GREEN}Une version de Java supérieure à 16 est installée.${NC}"
	else
		echo -e "${RED}Java installé est inférieur à Java 16.${NC}"
		echo -e "Voulez-vous installer une version supérieure ?"
		echo -e "* [1] Java 16"
		echo -e "* [2] Java 17"
		echo -e "* [3] Java 21"
		echo -e "* [4] Ne pas installer une version supérieure"
		read -p "Choisissez une option (1-4): " choix
		java_installation $choix
		check_java_version # Java function recall to check if java is installed/continue the script after installation of Java
	fi
}

# Select installation folder
afficher_dossiers() {

	# Clear
	clear

	# Actual folder
	echo -e "${YELLOW}Dossier actuel : $(pwd)${NC}"
	echo -e ""
	echo -e "${RED}Attention  Le dossier sélectionné sera completement vidé. Assurez-vous d'avoir sauvegarder le contenu du dossier s'il était utilisé avant.${NC}"
	echo -e ""
	
	# Content inside of the folder
	echo -e "${YELLOW}Contenu du répertoire :${NC}"

	# Files inside the folder
	options=()
	while IFS= read -r line; do
		options+=("$line")
	done < <(ls -l --time=mtime --color=auto | awk '$1 ~ /^d/ {printf "%-12s > %s\n", $6"-"$7"-"$8, $9}')

	# Navigation options
	options+=("Créer un nouveau dossier")
	options+=("Monter d'un niveau")
	options+=("Sélectionner ce dossier")
	options+=("Annuler")  # Cancel to stop the script

	# FZF
	selected_option=$(printf "%s\n" "${options[@]}" | fzf --ansi --preview "echo {}" --height 20)

	# Options
	case $selected_option in

		"Créer un nouveau dossier")
			# Create a new folder
			read -p "Entrez le nom du nouveau dossier : " new_folder
			mkdir -p "$new_folder" && echo -e "${GREEN}Dossier '$new_folder' créé.${NC}"
			cd "$new_folder"
			afficher_dossiers  # Refresh the content
			;;

		"Monter d'un niveau")
			# Monter d'un niveau
			cd ../ && echo -e "${GREEN}Monté vers : $(pwd)${NC}"
			afficher_dossiers  # Refresh the content
			;;

		"Sélectionner ce dossier")
			# Select the installation folder
			clear
			install_folder=$(pwd)
			echo -e "${GREEN}Dossier final sélectionné : $install_folder${NC}"
			;;

		"Annuler")
			# Stop the script
			echo -e "${RED}Script annulé.${NC}"
			exit 0
			;;

		*)
			# Navigate into the selected folder
			selected_folder=$(echo "$selected_option" | awk '{print $NF}')

			if [ -d "$selected_folder" ]; then
			
				cd "$selected_folder" && echo -e "${GREEN}Monté dans : $(pwd)${NC}"
				afficher_dossiers  # Refresh the content
			else
            	
				# If the foler is invalid, restart FZF
				echo -e "${RED}Dossier invalide, veuillez réessayer.${NC}"

				afficher_dossiers  # Refresh folders after error
			fi

			;;
	esac
}

ram_selection() {

	case $1 in
		1) ram_amount="1024M" ;;
		2) ram_amount="2048M" ;;
		3) ram_amount="4096M" ;;
		4) ram_amount="8192M" ;;
		5) ram_amount="16384M" ;;
		
		*) 
	        
			echo -e "${RED}Option invalide. Veuillez choisir une option entre 1 et 5.${NC}"

			return 1
		;;
	esac
    
	echo -e "${GREEN}Vous avez sélectionné ${ram_amount} de RAM.${NC}"
}

clear
echo -e "${LIGHT_BLUE}   ______ _       _______                  _____           _       _        "
echo -e "${LIGHT_BLUE}  |  ____(_)     |__   __|                / ____|         (_)     | |       "
echo -e "${LIGHT_BLUE}  | |__   _ _ __ ___| |_ __ _   ___  __  | (___   ___ _ __ _ _ __ | |_ ___  "
echo -e "${LIGHT_BLUE}  |  __| | | '__/ _ \ | '__| | | \ \/ /   \___ \ / __| '__| | '_ \| __/ __| "
echo -e "${LIGHT_BLUE}  | |    | | | |  __/ | |  | |_| |>  <    ____) | (__| |  | | |_) | |_\__ \ "
echo -e "${LIGHT_BLUE}  |_|    |_|_|  \___|_|_|   \__, /_/\_\  |_____/ \___|_|  |_| .__/ \__|___/ "
echo -e "${LIGHT_BLUE}                             __/ |                          | |             "
echo -e "${LIGHT_BLUE}                            |___/                           |_|             "
echo -e "${NC}"
echo -e ""
echo -e " ${GREEN}Bienvenue ${SUDO_USER} ! Merci de porter de l'importance à FireTryx Scripts. ${NC}"
echo -e ""
echo -e "* [1] Installer un serveur Paper 1.16.5 (Latest build: paper-1.16.5-794.jar)"
echo -e "* [2] Récupérer une base de serveur Paper 1.16.5"
echo -e "* [3] Paramétrer un serveur Paper 1.16.5"
echo -e "* [4] IP Privée & IP Publique"
echo -e "* [5] Quitter"

read -p "Choisissez une option (1-5): " input

case $input in

	1)
		clear
		echo -e "${GREEN}Installation de Paper 1.16.5 ...${NC}"

		# Verification and installation of Java
		check_java_version

		# Show folders function call
		afficher_dossiers


		# Installation of Paper 1.16.5 Build 794
		echo -e "${GREEN}Téléchargement de Paper 1.16.5 Build 794 dans '$install_folder' ...${NC}"
		cd $install_folder

		sudo rm -r *

		wget -O paper-1.16.5-794.jar https://papermc.io/api/v2/projects/paper/versions/1.16.5/builds/794/downloads/paper-1.16.5-794.jar

		# eula.txt bypass
		echo -e "eula=true" >> eula.txt

		# RAM selection
		clear
		echo -e "${LIGHT_BLUE}Veuillez sélectionner une quantité de RAM à allouer au serveur.${NC}"
		echo -e "* [1] 1Go"
		echo -e "* [2] 2Go"
		echo -e "* [3] 4Go"
		echo -e "* [4] 8Go"
		echo -e "* [5] 16Go"
		read -p "Choisissez une option (1-5): " ram
		ram_selection $ram

		if [ "$java_version" -eq 16 ]; then
			echo -e "${GREEN}Création du fichier de démarrage.${NC}"
			echo -e "java -Xms512M -Xmx${ram_amount} -jar paper-1.16.5-794.jar nogui" >> start.sh
		else [ "$java_version" -gt 16 ]
			echo -e "${GREEN}Création du fichier de démarrage.${NC}"
			echo -e "java -Xms512M -Xmx${ram_amount} -DPaper.IgnoreJavaVersion=true -jar paper-1.16.5-794.jar nogui" >> start.sh
		fi

		# Finish installation
		clear
		echo -e "${GREEN}Finalisation de l'installation ...${NC}"

		# Make file executable
		chmod +x start.sh

		# Change permissions 
		if [ -n "$SUDO_USER" ]; then
			chown -R "$SUDO_USER:$SUDO_USER" . # Set user owner to the user who executed the script
		else
			echo -e "${RED}Erreur : Impossible de récupérer l'utilisateur ayant lancé le script.${NC}"
			exit 1
		fi

		# Affichage final
		clear
		echo -e "${GREEN}Vous avez sélectionné ${ram_amount} de RAM.${NC}"
		echo -e "${LIGHT_BLUE}Votre serveur est maintenant créé ! Pour le lancer, effectuez cette commande dans le dossier du serveur:${NC}"
		echo -e ""
		echo -e "  ${GREEN}./start.sh ${NC}"
		echo -e ""
		echo -e "${LIGHT_BLUE}Pour récupérer votre IP locale et publique, exécutez à nouveau le script, et choisissez l'option 4.${NC}"
		echo -e "${YELLOW}Avertissement ! N'installez pas deux fois Paper 1.16.5 dans le même dossier, cela pourrait engendrer quelques erreurs.${NC}"
		echo -e ""
		echo -e "${LIGHT_BLUE}Merci d'avoir utilisé le script d'installation de serveur Paper 1.16.5 de FireTryx !${NC}"
		echo -e ""

		exit
		;;

	2)
		# Clear the screen
		clear

		# Select installation folder
		afficher_dossiers

		cd $install_folder
		sudo rm -r *


		# Get the Paper 1.16.5 base
		download_url="https://media.githubusercontent.com/media/FireTryx/Firetryx_Scripts/refs/heads/development/Paper/Base_serveurs/1.16.5/1.16.5.zip?download=true"

		# Télécharger le fichier ZIP généré par DownGit
		output_file="server_base-firetryx_script-1.16.5.zip"
		echo -e "${GREEN}Téléchargement en cours...${NC}"
		wget -O "$output_file" "$download_url"

		# Extraire le fichier ZIP
		read -p "Voulez-vous extraire le fichier ZIP ? (oui/non) : " extract
		
		if [[ "$extract" == "oui" ]]; then
			unzip "$output_file"
			echo -e "${GREEN}Fichiers extraits dans le dossier.${NC}"
		fi

		# Change permissions 
		if [ -n "$SUDO_USER" ]; then
			chown -R "$SUDO_USER:$SUDO_USER" . # Set user owner to the user who executed the script
		else
			echo -e "${RED}Erreur : Impossible de récupérer l'utilisateur ayant lancé le script.${NC}"
			exit 1
		fi
		
		;;

	3)
		# Clear the screen
		clear

		# Select folder where Paper is installed
		afficher_dossiers

		# Change options
		echo -e "${GREEN}Modifications des options de configuration Paper dans '$install_folder' ...${NC}"
		cd $install_folder

		# Options

		# spigot.yml
		read -p "Serveur sur un proxy BungeeCord (oui/non) : " bungeecord
		if [[ "$bungeecord" == "oui" ]]; then
			sed -i "s/^\s*bungeecord: .*/  bungeecord: true/" spigot.yml
		elif [[ "$bungeecord" == "non" ]]; then
			sed -i "s/^\s*bungeecord: .*/  bungeecord: false/" spigot.yml
		fi

		# bukkit.yml
		clear
		echo -e "${GREEN}Modifications des options de configuration Bukkit dans '$install_folder' ...${NC}"
		cd $install_folder

		# Options
		read -p "Autoriser l'END (oui/non) : " allow_end
		if [[ "$allow_end" == "oui" ]]; then
			sed -i "s/^\s*allow-end: .*/allow-end: true/" bukkit.yml
		elif [[ "$allow_end" == "non" ]]; then
			sed -i "s/^\s*allow-end: .*/allow-end: false/" bukkit.yml
		fi

		# server.properties
		clear
		echo -e "${GREEN}Modifications des options de préférence Paper dans '$install_folder' ...${NC}"

		read -p "Serveur Crack/relié Proxy (online-mode) (oui/non) : " online_mode
		if [[ "$online_mode" == "oui" ]]; then
			sed -i "s/^online-mode=.*/online-mode=false/" server.properties
		elif [[ "$online_mode" == "non" ]]; then
			sed -i "s/^online-mode=.*/online-mode=true/" server.properties
		fi

		echo -e ""
		read -p "Autoriser le NETHER (allow-nether) (oui/non) : " nether
		if [[ "$nether" == "oui" ]]; then
			sed -i "s/^allow-nether=.*/allow-nether=true/" server.properties
		elif [[ "$nether" == "non" ]]; then
			sed -i "s/^allow-nether=.*/allow-nether=false/" server.properties
		fi

		echo -e ""
		read -p "PvP (pvp) (oui/non) : " pvp
		if [[ "$pvp" == "oui" ]]; then
			sed -i "s/^pvp=.*/pvp=true/" server.properties
		elif [[ "$pvp" == "non" ]]; then
			sed -i "s/^pvp=.*/pvp=false/" server.properties
		fi

		echo -e ""
		read -p "Port du serveur (25565) : " server_port
		if [[ -z "$server_port" ]]; then
			server_port=25565
		fi
		sed -i "s/^server-port=[0-9]*/server-port=$server_port/" server.properties

		echo -e ""
		read -p "Joueurs Maximum (20) : " max_players
		if [[ -z "$max_players" ]]; then
			max_players=20
		fi
		sed -i "s/^max-players=[0-9]*/max-players=$max_players/" server.properties

		echo -e ""
		read -p "URL du resource-pack (laisser vide pour ne pas en utiliser) : " resource_pack_url

		if [[ -z "$resource_pack_url" ]]; then
			sed -i "/^resource-pack:/d" server.properties
			sed -i "/^resource-pack-sha1:/d" server.properties
		else
			sed -i "s/^resource-pack=.*/resource-pack=$resource_pack_url/" server.properties
			if ! grep -q "^resource-pack=" server.properties; then
				echo "resource-pack=$resource_pack_url" >> server.properties
			fi

			read -p "SHA1 du resource-pack (laisser vide si vous n'en avez pas) : " resource_pack_sha1

			if [[ -n "$resource_pack_sha1" ]]; then
				sed -i "s/^resource-pack-sha1=.*/resource-pack-sha1=$resource_pack_sha1/" server.properties
				if ! grep -q "^resource-pack-sha1=" server.properties; then
					echo "resource-pack-sha1=$resource_pack_sha1" >> server.properties
				fi
			else
				sed -i "/^resource-pack-sha1:/d" server.properties
			fi
		fi

		# Clear
		clear

		echo -e "${GREEN}Les modifications ont été apportés aux fichiers de configuration.${NC}"
		echo -e ""
		echo -e "${LIGHT_BLUE}Merci d'avoir utilisé le script d'installation de serveur Paper 1.16.5 de FireTryx !${NC}"
		echo -e ""
		
		exit
		;;

	4)
		# Clear the screen
		clear

		# Get the private IP
		private_ip=$(hostname -I | awk '{print $1}')

		# Get the public IP
		public_ip=$(curl -4 -s https://ifconfig.me/)

		echo -e "${LIGHT_BLUE}Voici vos adresses IP.${NC}"
		echo -e ""
		echo -e "  IP Privée : ${GREEN}${private_ip}${NC}"
		echo -e "  IP Publique : ${GREEN}${public_ip}${NC}"
		echo -e ""
		echo -e "${LIGHT_BLUE}Merci d'avoir utilisé le script d'installation de serveur Paper 1.16.5 de FireTryx !${NC}"
		echo -e ""

		exit
		;;

	5)
		clear
		echo -e "${GREEN}Merci d'avoir utilisé le script !${NC}"
		exit
		;;
	*)
		echo -e "${RED}Option invalide, veuillez réessayer !${NC}"
		;;
esac