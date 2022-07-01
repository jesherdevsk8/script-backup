#!/usr/bin/env bash
# -----------------------------------------------------------------
# Script   : backup-gdrive.sh
# Descrição: Faz backup para gdrive
# Versão   : 0.1
# Autor    : Jesher Minelli <jesherdevsk8@gmail.com>
# Data     : ter 21 jun 2022
# Licença  : GNU/GPL v3.0
# -----------------------------------------------------------------
# Uso: ln -s /script-backup/backup-gdrive.sh /usr/local/bin/backup-gdrive
# backup-gdrive or
# Cron: 20 12 * * 2,4 backup-gdrive 1> /dev/null 2>&1
# -----------------------------------------------------------------

#-------------------------- VARIAVEIS -----------------------------
# Diretórios para fazer backups
backup_path="/home/jesher/claretiano/tickets /home/jesher/Documentos/"
external_storage="/run/user/1000/gvfs/google-drive:host=gmail.com,user=jesherdevsk8" # Destino do backup
destination_dir="/run/user/1000/gvfs/google-drive:host=gmail.com,user=jesherdevsk8/backup-lenovo" # Criar diretório
date_log="$(date)"
date_format=$(date "+%A %d-%m-%Y")
final_archive="backup-$date_format.tar.gz" # Formato do arquivo
log_file="$HOME/Documentos/script-backup/backup-gdrive.log" # Arquivo de log

#--------------------------- TESTES -------------------------------

[[ $UID -eq 0 ]] && echo "Root não!!" && exit 1

if [[ ! -d "$external_storage" ]]; then # gdrive montado?
	printf "[$date_log] Diretório não montado em: $external_storage .\n" >> $log_file
	exit 1
else 
	[[ ! -d "$destination_dir" ]] && mkdir -p "$destination_dir" # Diretório não existe? então cria
fi

#--------------------------- FUNÇÕES ------------------------------

#---------------------------- MAIN --------------------------------

if tar -cpSzf "$destination_dir/$final_archive" $backup_path &>/dev/null; then
        printf "[$date_log] BACKUP BEM SUCEDIDO.\n" >> $log_file
else
        printf "[$date_log] OUVE UM ERRO AO FAZER BACKUP...!!\n" >> $log_file
fi

find ${destination_dir}/* -mtime +3 -delete # Excluir arquivos backup com mais de três dias
