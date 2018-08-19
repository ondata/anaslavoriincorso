# ANAS - Lavori in corso

L'ANAS pubblica sul suo sito la pagina “[Info Cantieri](http://www.stradeanas.it/it/le-strade/lavori-corso)” per conoscere i lavori in corso per la costruzione di nuove opere e per la manutenzione straordinaria.

> Lo stato dei lavori viene aggiornato a cadenze regolari. Le informazioni e le date riportate riguardano gli “Stati di Avanzamento Lavori” comunicati dalle imprese e gli impegni contrattuali previsti per la conclusione delle opere.

I dati sono consultabili da interfaccia web, ma scegliendo prima la regione e poi le singole strade; estrarne un quadro con i dettagli per tutte le strade gestite è laborioso e richiede tempo. E non è disponibile per il download un file di insieme.

Lo script [`anas.sh`](./anas.sh) fa il download dei dati di circa 180 strade (è il dato al 17 luglio 2018) e ne crea un unico file di insieme in due formati: CSV e JSON. Quelli presenti del repo "non saranno aggiornati".

**Nota bene**: una versione del file CSV (encoding `utf-8`, separatore `,`) viene aggiornata ogni settimana ed è disponibile a questo URL [https://query.data.world/s/slpppilpda5p2ce2xmn7a3wpdpdzsx](https://query.data.world/s/slpppilpda5p2ce2xmn7a3wpdpdzsx).

# Problematicità

## Dati numerici espressi come stringhe

Nei JSON di origine i valori numerici sono espressi in questo modo `"importo_lav_principali": "438.733,76"`. Nello script è stato inserito un filtro che nel file JSON di insieme viene modificato in `"importo_lav_principali": 438733.76` (e nel CSV di insieme da `438.733,76` a `438733.76`) (vedi #3).

## Record con data di ultimazione incompleta

Ci sono dei record in cui la data è espressa come `07/02/`, manca l'anno. Nello script è stato aggiunto un comando che estrae gli elementi con questa problematicità nel file [`problemi/stradeAnasNoAnnoUltimazione.csv`](./problemi/stradeAnasNoAnnoUltimazione.csv) (vedi [#4](#4)).

---

Grazie a [Laura Camellini](https://twitter.com/jeeltcraft) per averci messo una pulce nell'orecchio.


# Anteprima dati

## Anteprima CSV

| dal_km | al_km  | descrizione                                                                                                                                                                                                      | tipo_lavoro                           | importo_lav_principali | importo_lav_totale | data_consegna_impresa | avanzamento_lavori | ultimazione | sospesa | impresa                                                    | id    | regione | strada | 
|--------|--------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------|------------------------|--------------------|-----------------------|--------------------|-------------|---------|------------------------------------------------------------|-------|---------|--------| 
| 0,000  | 14,700 | (CUP-F77H18000410001) RA 12 Chieti- Pescara dal km. 0+000 al km. 14+800 Lavori di ripristino di funzionalita e di completamento degli impianti di illuminazione lungo l?asta principale e gli svincoli. 1? Lotto | Lavori di manutenzione straordinaria. | 438.733,76             | 506.388,76         | 09/05/2018            | 4,26               | 21/09/2018  |         | ATI STACCHIO IMPIANTI SRL-IGE IMPIA SRL-TATANGELO CIRO SRL | 14076 | ABRUZZO | RA12   | 
| 0,000  | 14,700 | (CUP-F77H18000510001) RA 12 Chieti- Pescara dal km. 0+000 al km. 14+800 Lavori di ripristino di funzionalita e di completamento degli impianti di illuminazione lungo l?asta principale e gli svincoli. 2? Lotto | Lavori di manutenzione straordinaria. | 436.022,44             | 493.727,44         | 31/05/2018            | 0,00               | 28/10/2018  |         | ATI STACCHIO IMPIANTI SRL-IGE IMPIA SRL-TATANGELO CIRO SRL | 14077 | ABRUZZO | RA12   | 


## Anteprima JSON

```json
[
  {
    "dal_km": "0,000",
    "al_km": "14,700",
    "descrizione": "(CUP-F77H18000410001) RA 12 Chieti- Pescara dal km. 0+000 al km. 14+800 Lavori di ripristino di funzionalita e di completamento degli impianti di illuminazione lungo l?asta principale e gli svincoli. 1? Lotto",
    "tipo_lavoro": "Lavori di manutenzione straordinaria.",
    "importo_lav_principali": "438.733,76",
    "importo_lav_totale": "506.388,76",
    "data_consegna_impresa": "09/05/2018",
    "avanzamento_lavori": "4,26",
    "ultimazione": "21/09/2018",
    "sospesa": "",
    "impresa": "ATI STACCHIO IMPIANTI SRL-IGE IMPIA SRL-TATANGELO CIRO SRL",
    "id": "14076",
    "regione": "ABRUZZO",
    "strada": "RA12"
  },
  {
    "dal_km": "0,000",
    "al_km": "14,700",
    "descrizione": "(CUP-F77H18000510001) RA 12 Chieti- Pescara dal km. 0+000 al km. 14+800 Lavori di ripristino di funzionalita e di completamento degli impianti di illuminazione lungo l?asta principale e gli svincoli. 2? Lotto",
    "tipo_lavoro": "Lavori di manutenzione straordinaria.",
    "importo_lav_principali": "436.022,44",
    "importo_lav_totale": "493.727,44",
    "data_consegna_impresa": "31/05/2018",
    "avanzamento_lavori": "0,00",
    "ultimazione": "28/10/2018",
    "sospesa": "",
    "impresa": "ATI STACCHIO IMPIANTI SRL-IGE IMPIA SRL-TATANGELO CIRO SRL",
    "id": "14077",
    "regione": "ABRUZZO",
    "strada": "RA12"
  }
]
```