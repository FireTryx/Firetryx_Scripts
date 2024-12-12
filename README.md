
# FireTryx Scripts

FireTryx Script est une banque de script, vous permettant, d'installer, et de gérer des logiciels tels que PaperMC, Spigot, et ma propre série de Skript pour Minecraft.




### Auteur

- [@firetryx](https://www.github.com/FireTryx)


### Futurs ajouts

- Prise en charge de Spigot
- Scripts pour plus de choix de versions pour Minecraft
- Wiki explicant comment les scripts fonctionnent
- Choix de la langue (Anglais, Allemand, ...)


# Installation

⚠ Le tutoriel n'est pas fait pour les débutants, il vous explique comment utiliser les scripts, mais ne vous explique pas comment utiliser Linux, il vous faut donc au minimum connaître les bases de Linux.
---

Tout au long de ce tutoriel, nous allons utiliser la version Paper 1.16.5 comme exemple. Il vous suffit de procéder comme dans cet exemple pour une autre version, les liens ne seront pas les mêmes ni les noms des fichiers, mais les commandes restent assez similaires.


Pour télécharger un script, veuillez vous référez à la commande ci-dessous :

```sh
wget https://raw.githubusercontent.com/FireTryx/Firetryx_Scripts/refs/heads/development/<Logiciel>/<nom du script à installer>.sh
```
Pour la version 1.16.5 du logiciel Paper
```sh
wget https://raw.githubusercontent.com/FireTryx/Firetryx_Scripts/refs/heads/development/Paper/paper-1.16.5-install.sh
```
    
## Utilisation/Exemple

Pour lancer les scripts, il est très important de suivre les étapes décrites ci-dessous, les scripts ne peuvent s'exécuter avec une seule commande.

Pour commencer, les scripts sont des fichiers exécutables, ce qui veut dire que le système va exécuter le ce=ontenu du fichier. Il est donc important de dire au système que le script est un fichier qu'il doit exécuter et que nous devons donner l'autorisation de l'exécuter. Pour ce faire, procédez comme suit :

```sh
sudo chmod +x <nom du script téléchargé>.sh
```
Où sudo nous permet d'exécuter la commande en tant que super-utilisateur et +x donne l'autorisation d'exécuter le script.

Pour la version 1.16.5 du logiciel Paper
```sh
sudo chmod +x paper-1.16.5-install.sh
```

Après avoir effectuée cette commande, pour lancer le script, exécutez la commande suivante :

```sh
sudo ./<nom du script téléchargé>.sh
```
Où sudo, qui est obligatoire pour lancer le script, permet de l'exécuter en tant que super-utilisateur, pour éviter de demander vos mots de passes de multiples fois pendant l'installation du logiciel téléchargé.

Pour la version 1.16.5 du logiciel Paper
```sh
sudo ./paper-1.16.5-install.sh
```

Veuillez prendre en compte que les scripts ne sont pas encore en version "stable", il se peut que quelques erreurs surviennent. Je vous prie donc d'être indulgeant par rapport à ce sujet.


## Captures d'Écrans

[Imgur](https://imgur.com/t6bm2Zi)

