#!/usr/bin/env bash

# Torne o script executavel em qualquer lugar
# sudo ln -s ~/Documentos/backup.sh /usr/local/bin/backup

# ADICIONAR NO CRON
# execute como root - crontab -e
# 0 9 * * * /usr/local/sbin/backup.sh
# Visite o site: https://crontab.guru/

# --- VARIÁVEIS

backup_path="/home/jesher/claretiano/tickets" # Diretório de backup

backup_path2="/home/jesher/Documentos"

external_storage="/media/jesher/Ventoy" # Dispositivo externo de destino

create="/media/jesher/Ventoy/backups" # Diretório para ser criado dentro do dispositivo externo

date_log="$(date)"

date_format=$(date "+%A %d-%m-%Y")

final_archive="backup-$date_format.tar.gz" # Formato do arquivo

final_archive2="claretiano_documentos-$date_format.tar.gz"

log_file="/var/log/daily-backup.log" # Arquivo de log

# tail -f /var/log/daily-backup.log ou less +F /var/log/daily-backup.log | para monitorar o arquvo de log

# --- TESTES

if ! mountpoint -q -- $external_storage; then # Pendrive plugado na máquina?
	printf "[$date_log] DEVICE NOT MOUNTED in: $external_storage CHECK IT.\n" >> $log_file
	exit 1
else 
	mkdir -p ${create} #fazer validação parar quando já criado, não fazer nada
fi

# --- EXECUÇÃO

if tar -cpSzf "$create/$final_archive" "$backup_path" &>/dev/null; then
	printf "[$date_log] BACKUP SUCCESS.\n" >> $log_file
else
	printf "[$date_log] BACKUP ERROR...!!\n" >> $log_file
fi

# Execução do backup_path2
if tar -cpSzf "$create/$final_archive2" "$backup_path2" &>/dev/null; then
	printf "[$date_log] BACKUP SUCCESS - DIRETÓRIO DOCUMENTOS PC DO TRAMPO.\n" >> $log_file
else
	printf "[$date_log] BACKUP ERROR - DIRETÓRIO DOCUMENTOS PC DO TRAMPO.\n" >> $log_file
fi

#find ${external_storage}*.gz -mtime +3 -delete # Excluir arquivos com mais de dez dias
# Arrumar aqui para deletar somente arquivos de backup.tar.gz
