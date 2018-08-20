[![goodtables.io](https://goodtables.io/badge/github/ondata/anaslavoriincorso.svg)](https://goodtables.io/github/ondata/anaslavoriincorso)

<!-- TOC -->

- [ANAS - Lavori in corso](#anas---lavori-in-corso)
- [Problematicità](#problematicit%C3%A0)
  - [Licenza non definita, quindi dati non utilizzabili](#licenza-non-definita-quindi-dati-non-utilizzabili)
  - [Dati sul posizionamento dei cantieri](#dati-sul-posizionamento-dei-cantieri)
  - [Dati numerici espressi come stringhe](#dati-numerici-espressi-come-stringhe)
  - [Record con data di ultimazione incompleta](#record-con-data-di-ultimazione-incompleta)
- [Anteprima dati](#anteprima-dati)
  - [Anteprima CSV d'esempio](#anteprima-csv-desempio)
  - [Anteprima JSON d'esempio](#anteprima-json-desempio)
- [Linear Referencing](#linear-referencing)
  - [Import dataset ANAS](#import-dataset-anas)
  - [Estrazione tratte](#estrazione-tratte)

<!-- /TOC -->

# ANAS - Lavori in corso

L'ANAS pubblica sul suo sito la pagina “[Info Cantieri](http://www.stradeanas.it/it/le-strade/lavori-corso)” per conoscere i lavori in corso per la costruzione di nuove opere e per la manutenzione straordinaria.

> Lo stato dei lavori viene aggiornato a cadenze regolari. Le informazioni e le date riportate riguardano gli “Stati di Avanzamento Lavori” comunicati dalle imprese e gli impegni contrattuali previsti per la conclusione delle opere.

I dati sono consultabili da interfaccia web, ma scegliendo prima la regione e poi le singole strade; estrarne un quadro con i dettagli per tutte le strade gestite è laborioso e richiede tempo. E non è disponibile per il download un file di insieme.

Lo script [`anas.sh`](./anas.sh) fa il download dei dati di circa 180 strade (è il dato al 17 luglio 2018) e ne crea un unico file di insieme in due formati: CSV e JSON. Quelli presenti del repo "non saranno aggiornati".

**Nota bene**: una versione del file CSV (encoding `utf-8`, separatore `,`) viene aggiornata ogni settimana ed è disponibile a questo URL [https://query.data.world/s/slpppilpda5p2ce2xmn7a3wpdpdzsx](https://query.data.world/s/slpppilpda5p2ce2xmn7a3wpdpdzsx).

[![](./risorse/charts.png)](https://datastudio.google.com/embed/reporting/17n4Casew-9cMbFE5PD5aqZg0jnsephjA/page/qy0W)

Il _Jupyter Notebook_ [anas.ipynb](./linearrefencing/anas.ipynb) trasforma le annotazioni kilometriche in archi e li salva in formato GeoPackage e GeoJSON.

# Problematicità

## Licenza non definita, quindi dati non utilizzabili

ANAS è una S.p.A. quindi - salvo non specificato diversamente - **tutti i diritti sui dati che pubblica sono riservati**.<br>
C'è da chiedere di associare a questi dati una licenza che ne consenta il riuso.

## Dati sul posizionamento dei cantieri

I dati sul posizionamento dei lavori, sono espressi in termini di kilometraggio dei punti di inizio e fine lavori lungo la "strada" interessata. Si sa ad esempio che un lavoro con un certo `id` interessa la SS113, dal km 3.2 al km 8.

ANAS in queste pagine **non rende disponibile per il download la rete stradale** (meglio dire il "grafo") su cui sono basate queste annotazioni geografiche. Quindi l'utente può avere **solo un quadro generico e a spanne sul "dove"**.<br>
Per fortuna Gianni Vitrano (grazie) ci ha [segnalato](https://github.com/ondata/anaslavoriincorso/issues/7) che sul sito del Ministero dei Trasporti esiste il dataset opendata del grafo stradale del 2015 [http://dati.mit.gov.it/catalog/dataset/grafo-stradale-anas](http://dati.mit.gov.it/catalog/dataset/grafo-stradale-anas). Aprendolo si evince come sia predisposto per applicare le funzioni di [_linear referencing_](https://www.wikiwand.com/en/Linear_referencing), con cui è possibile trasformare le annotazione chilometriche nei tratti geometrici corrispondenti.

Le problematicità correlate sono le seguenti:

- il grafo è aggiornato al 2015;
- non è detto che sia lo stesso usato da ANAS per creare l'anagrafica dei lavori in corso pubblicato sul loro sito;
- diverse centinaia di lavori sono associati alla tratta stradale denominata "VARIE". Questi non sono trasformabili in modo automatico in geometrie.

## Dati numerici espressi come stringhe

Nei JSON di origine i valori numerici sono espressi in questo modo `"importo_lav_principali": "438.733,76"`. Nello script è stato inserito un filtro che nel file JSON di insieme viene modificato in `"importo_lav_principali": 438733.76` (e nel CSV di insieme da `438.733,76` a `438733.76`) (vedi [#3](https://github.com/ondata/anaslavoriincorso/issues/3)).

## Record con data di ultimazione incompleta

Ci sono dei record in cui la data è espressa come `07/02/`, manca l'anno. Nello script è stato aggiunto un comando che estrae gli elementi con questa problematicità nel file [`problemi/stradeAnasNoAnnoUltimazione.csv`](./problemi/stradeAnasNoAnnoUltimazione.csv) (vedi [#4](https://github.com/ondata/anaslavoriincorso/issues/4)).

---

Grazie a [Laura Camellini](https://twitter.com/jeeltcraft) per averci messo una pulce nell'orecchio.


# Anteprima dati

## Anteprima CSV d'esempio

| dal_km | al_km  | descrizione                                                                                                                                                                                                      | tipo_lavoro                           | importo_lav_principali | importo_lav_totale | data_consegna_impresa | avanzamento_lavori | ultimazione | sospesa | impresa                                                    | id    | regione | strada | 
|--------|--------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------|------------------------|--------------------|-----------------------|--------------------|-------------|---------|------------------------------------------------------------|-------|---------|--------| 
| 0  | 14.7 | (CUP-F77H18000410001) RA 12 Chieti- Pescara dal km. 0+000 al km. 14+800 Lavori di ripristino di funzionalita e di completamento degli impianti di illuminazione lungo l?asta principale e gli svincoli. 1? Lotto | Lavori di manutenzione straordinaria. | 438733.76             | 506388.76         | 09/05/2018            | 4.26               | 21/09/2018  |         | ATI STACCHIO IMPIANTI SRL-IGE IMPIA SRL-TATANGELO CIRO SRL | 14076 | ABRUZZO | RA12   | 
| 0  | 14.7 | (CUP-F77H18000510001) RA 12 Chieti- Pescara dal km. 0+000 al km. 14+800 Lavori di ripristino di funzionalita e di completamento degli impianti di illuminazione lungo l?asta principale e gli svincoli. 2? Lotto | Lavori di manutenzione straordinaria. | 436022.44             | 493727.44         | 31/05/2018            | 0.00               | 28/10/2018  |         | ATI STACCHIO IMPIANTI SRL-IGE IMPIA SRL-TATANGELO CIRO SRL | 14077 | ABRUZZO | RA12   | 


## Anteprima JSON d'esempio

```json
[
  {
    "dal_km": 0,
    "al_km": 14.7,
    "descrizione": "(CUP-F77H18000410001) RA 12 Chieti- Pescara dal km. 0+000 al km. 14+800 Lavori di ripristino di funzionalita e di completamento degli impianti di illuminazione lungo l?asta principale e gli svincoli. 1? Lotto",
    "tipo_lavoro": "Lavori di manutenzione straordinaria.",
    "importo_lav_principali": 438733.76,
    "importo_lav_totale": 506388.76,
    "data_consegna_impresa": "09/05/2018",
    "avanzamento_lavori": 4.26,
    "ultimazione": "21/09/2018",
    "sospesa": "",
    "impresa": "ATI STACCHIO IMPIANTI SRL-IGE IMPIA SRL-TATANGELO CIRO SRL",
    "id": "14076",
    "regione": "ABRUZZO",
    "strada": "RA12"
  },
  {
    "dal_km": 0,
    "al_km": 14.7,
    "descrizione": "(CUP-F77H18000510001) RA 12 Chieti- Pescara dal km. 0+000 al km. 14+800 Lavori di ripristino di funzionalita e di completamento degli impianti di illuminazione lungo l?asta principale e gli svincoli. 2? Lotto",
    "tipo_lavoro": "Lavori di manutenzione straordinaria.",
    "importo_lav_principali": 436022.44,
    "importo_lav_totale": 493727.44,
    "data_consegna_impresa": "31/05/2018",
    "avanzamento_lavori": 0,
    "ultimazione": "28/10/2018",
    "sospesa": "",
    "impresa": "ATI STACCHIO IMPIANTI SRL-IGE IMPIA SRL-TATANGELO CIRO SRL",
    "id": "14077",
    "regione": "ABRUZZO",
    "strada": "RA12"
  }
]
```

# Linear Referencing

Sitografia

- [PostGIS](https://postgis.net/docs/reference.html#Linear_Referencing)
- [GRASS GIS](https://grass.osgeo.org/grass74/manuals/lrs.html)
- [Spatialite](https://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#p14b) (cercare `LocateBetweenMeasures`)
- [una introduzione di Boundless](http://workshops.boundlessgeo.com/postgis-intro/linear_referencing.html)

## Import dataset ANAS

Il dataset di ANAS è `MULTILINESTRINGZM`: contiene al suo interno le informazioni chilometriche progressive. In import è necessario specificarlo altrimenti vanno perse. Il comando di base è:

    ogr2ogr -overwrite -lco LAUNDER=No -f PostgreSQL PG:"dbname=test_andy host=localhost port=5432 user=postgres password=password" "grafo_Anas.shp" -nln "anaszm" -nlt "MULTILINESTRINGZM"

## Estrazione tratte

La _query_ di base per trasformare un'annotazione chilometrica in una geometria è:

```sql
select ST_CollectionExtract(ST_LocateBetween(wkb_geometry,18000,50000),2) from anaszm where "COD_STRA" like 'SS113'
```

Note:

- la funzione [`ST_LocateBetween`](https://postgis.net/docs/ST_LocateBetween.html) è la funzione principale. Richiede la geometria a cui essere applicata, la distanza da cui partire (che abbiamo trasformato in metri, perché è l'unità di misura del grafo ANAS), la distanza a cui finisce la tratta;
- l'output `ST_LocateBetween` è una _geometry collection_. Per estrarre da questa soltanto i segmenti viene usata la funzione [`ST_CollectionExtract`](https://postgis.net/docs/ST_CollectionExtract.html);
- la _query_ è applicata, come esempio, alla sola strada `SS113`.
