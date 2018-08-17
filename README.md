# ANAS - Lavori in corso

L'ANAS pubblica sul suo sito la pagina “[Info Cantieri](http://www.stradeanas.it/it/le-strade/lavori-corso)” per conoscere i lavori in corso per la costruzione di nuove opere e per la manutenzione straordinaria.

> Lo stato dei lavori viene aggiornato a cadenze regolari. Le informazioni e le date riportate riguardano gli “Stati di Avanzamento Lavori” comunicati dalle imprese e gli impegni contrattuali previsti per la conclusione delle opere.

I dati sono consultabili da interfaccia web, ma scegliendo prima la regione e poi le singole strade; estrarne un quadro con i dettagli per tutte le strade gestite è laborioso e richiede tempo. E non è disponibile per il download un file di insieme.

Lo script [`anas.sh`](./anas.sh) fa il download dei dati di circa 180 strade (è il dato al 17 luglio 2018) e ne crea un unico file di insieme in due formati:

- JSON > [`stradeAnas.json`](https://rawgit.com/ondata/anaslavoriincorso/master/stradeAnas.json)
- CSV > [`stradeAnas.json`](https://rawgit.com/ondata/anaslavoriincorso/master/stradeAnas.csv)

## Anteprima CSV

| dal_km | al_km  | descrizione                                                                                                                                                                                                      | tipo_lavoro                           | importo_lav_principali | importo_lav_totale | data_consegna_impresa | avanzamento_lavori | ultimazione | sospesa | impresa                                                    | id    | regione | strada | 
|--------|--------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------|------------------------|--------------------|-----------------------|--------------------|-------------|---------|------------------------------------------------------------|-------|---------|--------| 
| 0,000  | 14,700 | (CUP-F77H18000410001) RA 12 Chieti- Pescara dal km. 0+000 al km. 14+800 Lavori di ripristino di funzionalita e di completamento degli impianti di illuminazione lungo l?asta principale e gli svincoli. 1? Lotto | Lavori di manutenzione straordinaria. | 438.733,76             | 506.388,76         | 09/05/2018            | 4,26               | 21/09/2018  |         | ATI STACCHIO IMPIANTI SRL-IGE IMPIA SRL-TATANGELO CIRO SRL | 14076 | ABRUZZO | RA12   | 
| 0,000  | 14,700 | (CUP-F77H18000510001) RA 12 Chieti- Pescara dal km. 0+000 al km. 14+800 Lavori di ripristino di funzionalita e di completamento degli impianti di illuminazione lungo l?asta principale e gli svincoli. 2? Lotto | Lavori di manutenzione straordinaria. | 436.022,44             | 493.727,44         | 31/05/2018            | 0,00               | 28/10/2018  |         | ATI STACCHIO IMPIANTI SRL-IGE IMPIA SRL-TATANGELO CIRO SRL | 14077 | ABRUZZO | RA12   | 
| 4,300  | 69,514 | SS.N.16 ADRIATICA  LAVORI DI RISANAMENTO PAVIMENTAZIONI E DISTESE GENERALI LUNGO LA SS . 16 DAL KM 4+300 AL KM. 69+514 -  STRALCIO II                                                                            | Lavori di manutenzione straordinaria. | 535.975,62             | 576.350,62         | 19/04/2018            | 95,46              | 10/07/2018  |         | ATI E.MA.PRI.CE. SPA -TRENTIN ASFAL                        | 14496 | ABRUZZO | SS16   | 

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
  },
  {
    "dal_km": "4,300",
    "al_km": "69,514",
    "descrizione": "SS.N.16 ADRIATICA\r\nLAVORI DI RISANAMENTO PAVIMENTAZIONI E DISTESE GENERALI LUNGO LA SS . 16 DAL KM 4+300 AL KM. 69+514 -  STRALCIO II ",
    "tipo_lavoro": "Lavori di manutenzione straordinaria.",
    "importo_lav_principali": "535.975,62",
    "importo_lav_totale": "576.350,62",
    "data_consegna_impresa": "19/04/2018",
    "avanzamento_lavori": "95,46",
    "ultimazione": "10/07/2018",
    "sospesa": "",
    "impresa": "ATI E.MA.PRI.CE. SPA -TRENTIN ASFAL",
    "id": "14496",
    "regione": "ABRUZZO",
    "strada": "SS16"
  }
]
```