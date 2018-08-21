#!/bin/bash

### requirements ###
# curl
# jq
# csvkit
### requirements ###

set -x

cartella="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# creo due cartelle "contenitore"
mkdir -p "$cartella"/regioni
mkdir -p "$cartella"/strade
mkdir -p "$cartella"/problemi

rm -rf "$cartella"/regioni/*
rm -rf "$cartella"/strade/*
rm -rf "$cartella"/problemi/*

# scarico i file di riepilogo delle regioni
curl -sL "http://www.stradeanas.it/sites/all/modules/anas/js/anas.app.lavori_in_corso.js" | grep -Eo '("[a-zA-Z]+":{"DB":")([a-zA-Z]+)"' | sed -r 's/("[a-zA-Z]+":\{"DB":")([a-zA-Z]+)"/\2/g' | xargs -I{} sh -c 'curl -sL http://www.stradeanas.it/it/anas/app/lavori_in_corso/lavori_regione?regione="$1" | jq . >'"$cartella"'/regioni/"$1".json' -- {}

# scarico i file di dettaglio sui lavori nelle varie strade delle regioni
cd "$cartella"/regioni
for i in *.json; do
	regione=$(echo "$i" | sed 's/\.json//g')
	echo "$regione"
	strade=$(jq <"$i" -r '.LIST_ROADS[][0]' | tr '\n' ' ')
	echo "$strade"
	for strada in $strade; do
		echo "$strada"
		echo "$regione"
		curl -sL "http://www.stradeanas.it/it/anas/app/lavori_in_corso/lavori_regione_strada?regione=$regione&cod_strada=$strada" | jq '.[] |= . + {"regione": "'"$regione"'","strada": "'"$strada"'"}' >"$cartella"/strade/"$regione"_"$strada".json
	done
done


# creo un unico file json di output
jq -s add "$cartella"/strade/*.json >"$cartella"/stradeAnas.json

# trasfomo in valori numerici, gli item che sono numeri ma valorizzati come stringhe
# ad esempio da $(438.733,76) a $(438733.76)
jq '((.[].importo_lav_principali| select(.) ) |= gsub("\\.";"") ) | ((.[].importo_lav_principali| select(.) ) |= gsub(",";".") ) | ((.[].importo_lav_principali| select(.) ) |= tonumber ) |  ((.[].importo_lav_totale| select(.) ) |= gsub("\\.";"") ) | ((.[].importo_lav_totale| select(.) ) |= gsub(",";".") ) | ((.[].importo_lav_totale| select(.) ) |= tonumber ) |  ((.[].dal_km| select(.) ) |= gsub("\\.";"") ) | ((.[].dal_km| select(.) ) |= gsub(",";".") ) | ((.[].dal_km| select(.) ) |= tonumber ) |  ((.[].al_km| select(.) ) |= gsub("\\.";"") ) | ((.[].al_km| select(.) ) |= gsub(",";".") ) | ((.[].al_km| select(.) ) |= tonumber ) |  ((.[].avanzamento_lavori| select(.) ) |= gsub(",";".") ) | ((.[].avanzamento_lavori| select(.) ) |= tonumber )' "$cartella"/stradeAnas.json >"$cartella"/stradeAnas_tmp.json && mv "$cartella"/stradeAnas_tmp.json "$cartella"/stradeAnas.json

# creo un unico file csv di output e sostituisco i "\r\n" presenti in descrizione con "|"
<"$cartella"/stradeAnas.json jq '((.[].descrizione| select(.) ) |= gsub("\r\n";"|") )' | \
jq '((.[].descrizione| select(.) ) |= gsub("\\|$";"") )' | \
in2csv -I -f json >"$cartella"/stradeAnas.csv

# dati problematici
## i record in cui la data di ultimazione è espressa in questo modo $(07/02/), ovvero manca l'anno
csvgrep -c "ultimazione" -r "^../../$" "$cartella"/stradeAnas.csv >"$cartella"/problemi/stradeAnasNoAnnoUltimazione.csv

## strade di tipo non "VARIE" con "dal km" "al km" che vanno da 0 a 0
csvsql -I --query "select * from stradeAnasIta where al_km = 0 and dal_km = 0 and strada NOT LIKE 'VARIE'" "$cartella"/stradeAnasIta.csv >"$cartella"/problemi/stradeAnasAnnotazionKmNulla.csv

# faccio l'upload su data.world
source "$cartella"/config.txt
curl "https://api.data.world/v0/uploads/ondata/anas-lavori-in-corso/files" -F file=@"$cartella"/stradeAnas.csv -H "Authorization: Bearer ${DW_API_TOKEN}"
curl "https://api.data.world/v0/uploads/ondata/anas-lavori-in-corso/files" -F file=@"$cartella"/problemi/stradeAnasAnnotazionKmNulla.csv -H "Authorization: Bearer ${DW_API_TOKEN}"
curl "https://api.data.world/v0/uploads/ondata/anas-lavori-in-corso/files" -F file=@"$cartella"/problemi/stradeAnasNoAnnoUltimazione.csv -H "Authorization: Bearer ${DW_API_TOKEN}"

<<comment1
comment1
