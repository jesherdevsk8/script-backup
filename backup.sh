#!/usr/bin/env bash

# Torne o script executavel em qualquer lugar
# sudo ln -s ~/Documentos/backup.sh /usr/local/bin/backup

# ADICIONAR NO CRON
# execute como root - crontab -e
# 0 9 * * * /usr/local/sbin/backup.sh
# Visite o site: https://crontab.guru/
# -----------------------------------------------------------------

#-------------------------- VARIAVEIS -----------------------------
# Diretórios para fazer backups
backup_path="/home/jesher/claretiano/tickets /home/jesher/Documentos/"
external_storage="/media/jesher/JESHER" # Dispositivo externo de destino
destination="/media/jesher/JESHER/backups" # Diretório para ser criado dentro do dispositivo externo
date_log="$(date)"
date_format=$(date "+%A %d-%m-%Y")
final_archive="backup-$date_format.tar.gz" # Formato do arquivo
log_file="/var/log/daily-backup.log" # Arquivo de log
# Monitorar o arquvo de log
# tail -f /var/log/daily-backup.log ou less +F /var/log/daily-backup.log

#--------------------------- TESTES -------------------------------

if ! mountpoint -q -- $external_storage; then # Pendrive plugado na máquina?
	[[ "$?" = '0' ]] && echo "[INFO] - DEVICE NOT MOUNTED, CHECK LOG in /var/log/daily-backup.log"
	printf "[$date_log] DEVICE NOT MOUNTED in: $external_storage CHECK IT.\n" >> $log_file
	exit 1
	
else 
	[[ ! -d "$destination" ]] && mkdir -p "$destination"
fi

#--------------------------- FUNÇÕES ------------------------------

#---------------------------- MAIN --------------------------------

if tar -cpSzf "$destination/$final_archive" $backup_path &>/dev/null; then
	printf "[$date_log] BACKUP SUCCESS.\n" >> $log_file
else
	printf "[$date_log] BACKUP ERROR...!!\n" >> $log_file
fi

find ${destination}/*.gz -mtime +3 -delete # Excluir arquivos tar.gz com mais de três dias
