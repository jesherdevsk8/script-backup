#!/usr/bin/env bash
# -----------------------------------------------------------------
# Script   : backup-onedrive
# Descrição: Faz backup para pasta onde fica montado o onedrive
# Versão   : 0.1
# Autor    : Jesher Minelli <jesherdevsk8@gmail.com>
# Data     : ter 21 jun 2022
# Licença  : GNU/GPL v3.0
# -----------------------------------------------------------------
# Uso: backup-onedrive
# Depende: onedriver
# https://software.opensuse.org/download.html?project=home%3Ajstaf&package=onedriver
# -----------------------------------------------------------------

#-------------------------- VARIAVEIS -----------------------------

backup_path="/home/jesher/claretiano/tickets" # Diretório para backup
backup_path2="/home/jesher/Documentos"
external_storage="/home/jesher/onedrive" # Local de destino backup
destination="/home/jesher/onedrive/backups" # Criar diretório
date_log="$(date)"
date_format=$(date "+%A %d-%m-%Y")
final_archive="backup-$date_format.tar.gz" # Formato do arquivo
final_archive2="claretiano_documentos-$date_format.tar.xz"
log_file="$HOME/Documentos/script-backup/backup-onedrive.log" # Arquivo de log

#--------------------------- TESTES -------------------------------

[[ $UID = '0' ]] && echo "Root não....!!!" && exit 1

if ! mountpoint -q -- $external_storage; then # Diretório Montado?
	printf "[$date_log] Diretório não montado em: $external_storage .\n" >> $log_file
	exit 1
else
  [[ ! -d "$destination" ]] && mkdir -p "$destination"
fi

#--------------------------- FUNÇÕES ------------------------------

#---------------------------- MAIN --------------------------------

if tar -cpSzf "$destination/$final_archive" "$backup_path" &>/dev/null; then
  printf "[$date_log] BACKUP BEM SUCEDIDO.\n" >> $log_file
else
  printf "[$date_log] OUVE UM ERRO AO FAZER BACKUP...!!\n" >> $log_file
fi

# Execução do backup_path2
if tar -cpSzf "$destination/$final_archive2" "$backup_path2" &>/dev/null; then
  printf "[$date_log] BACKUP BEM SUCEDIDO - DIRETÓRIO DOCUMENTOS.\n" >> $log_file
else
  printf "[$date_log] BACKUP COM ERRO - DIRETÓRIO DOCUMENTOS.\n" >> $log_file
fi

find ${destination}/*.gz -mtime +3 -delete # Excluir arquivos tar.xz com mais de cinco dias
