#' Builds the decrees list
#' 
#' @export
get_decrees <- function() {
  decrees <- list(
    list(
      x = (as.integer(as.Date("2020-01-30")) * 86400000),
      name = 'Ordinanza del Ministro della salute del 30 gennaio 2020 <img src="checkMark.png" alt="Check mark" height="42" width="42">',
      label = "Ordinanza del Ministro della salute",
      description = "Misure profilattiche contro il nuovo Coronavirus (2019 - nCoV)",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/02/01/20A00738/sg",
      status = "active"
    ),
    list(
      x = (as.integer(as.Date("2020-01-31")) * 86400000),
      name = "Delibera del Consiglio dei Ministri del 31 gennaio 2020",
      label = "Delibera del Consiglio dei Ministri",
      description = "Dichiarazione dello stato di emergenza in conseguenza del rischio sanitario connesso all'insorgenza di patologie derivanti da agenti virali trasmissibili.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/02/01/20A00737/sg",
      status = "active"
    ),
    list(
      x = (as.integer(as.Date("2020-02-23")) * 86400000),
      name = "DPCM 23 Febbraio 2020",
      label = '<p><a href="https://www.gazzettaufficiale.it/eli/id/2020/02/23/20A01228/sg" rel="noopener noreferrer" target="_blank">Decreto ministeriale</a></p>',
      description = "Misure urgenti in materia di contenimento e gestione dell'emergenza epidemiologica da COVID-2019.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/02/23/20A01228/sg",
      status = "active"
    ),
    list(
      x = (as.integer(as.Date("2020-02-25")) * 86400000),
      name = "DPCM 25 Febbraio 2020",
      label = "Decreto ministeriale",
      description = "Nuove misure in materia di svolgimento delle manifestazioni sportive di ogni ordine e disciplina, di organizzazione delle attività scolastiche e della formazione superiore, di prevenzione sanitaria presso gli Istituti penitenziari, di regolazione delle modalità di accesso agli esami di guida, di organizzazione delle attività culturali e per il turismo.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/02/25/20A01278/sg",
      status = "active"
    ),
    list(
      x = (as.integer(as.Date("2020-02-28")) * 86400000),
      name = "Decreto-legge 28 Febbraio 2020",
      label = "Decreto-legge",
      description = "Misure di potenziamento del Servizio sanitario nazionale, della protezione civile e della sicurezza, nonché di sostegno al mondo del lavoro pubblico e privato ed a favore delle famiglie e delle imprese; disposizioni in materia di giustizia, di trasporti, per i settori agricolo e sportivo, dello spettacolo e della cultura, della scuola e dell'università; la sospensione degli obblighi di versamento per tributi e contributi, di altri adempimenti e incentivi fiscali.",
      link = "http://www.governo.it/node/14225",
      status = "active"
    ),
    list(
      x = (as.integer(as.Date("2020-03-01")) * 86400000),
      name = "DPCM 1 Marzo 2020",
      label = "Decreto ministeriale",
      description = "Ulteriori misure volte a disciplinare in modo unitario il quadro degli interventi e a garantire uniformita'. su tutto il territorio nazionale all’attuazione dei programmi di profilassi.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/03/01/20A01381/sg",
      status = "inactive"
    ),
    list(
      x = (as.integer(as.Date("2020-03-02")) * 86400000),
      name = "DPCM 2 Marzo 2020",
      label = "Decreto ministeriale",
      description = "Misure urgenti di sostegno per famiglie, lavoratori e imprese connesse all'emergenza epidemiologica da COVID-19.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/03/02/20G00026/sg",
      status = "active"
    ),
    list(
      x = (as.integer(as.Date("2020-03-04")) * 86400000),
      name = "DPCM 4 Marzo 2020",
      label = "Decreto ministeriale",
      description = "Ulteriori disposizioni attuative del decreto-legge 23 febbraio 2020, n. 6, recante misure urgenti in materia di contenimento e gestione dell'emergenza epidemiologica da COVID-19, applicabili sull'intero territorio nazionale.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/03/01/20A01381/sg",
      status = "inactive"
    ),
    list(
      x = (as.integer(as.Date("2020-03-08")) * 86400000),
      name = "DPCM 8 Marzo 2020",
      label = "Decreto ministeriale",
      description = "In riferimento al Dpcm 8 marzo 2020, il Ministro dell'interno ha emanato la Direttiva n. 14606 del 08/03/2020 destinata ai Prefetti per l’attuazione dei controlli nelle aree a contenimento rafforzato",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/03/08/20A01522/sg",
      status = "active"
    ),
    list(
      x = (as.integer(as.Date("2020-03-09")) * 86400000),
      name = "Decreto-legge del 9 Marzo 2020, n. 14",
      label = "Decreto-legge",
      description = "Disposizioni urgenti per il potenziamento del Servizio sanitario nazionale in relazione all'emergenza COVID-19.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/03/09/20G00030/sg",
      status = "active"
    ),
    list(
      x = (as.integer(as.Date("2020-03-09")) * 86400000),
      name = "DPCM 9 Marzo 2020",
      label = "Decreto ministeriale",
      description = "Estese le misure di cui all'art. 1 del Dpcm 8 marzo 2020 a tutto il territorio nazionale. &Egrave; inoltre vietata ogni forma di assembramento di persone in luoghi pubblici o aperti al pubblico. In ultimo, è modificata la lettera d dell'art.1 del Dpcm 8 marzo 2020 relativa agli eventi e manifestazioni sportive. Tali disposizioni producono effetto dalla data del 10 marzo 2020 e sono efficaci fino al 3 aprile 2020.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/03/09/20A01558/sg",
      status = "active"
    ),
    list(
      x = (as.integer(as.Date("2020-03-11")) * 86400000),
      name = "DPCM 11 Marzo 2020",
      label = "Decreto ministeriale",
      description = "Chiusura di tutte le attivit? commerciali, di vendita al dettaglio, ad eccezione dei negozi di generi alimentari, di prima necessit?, delle farmacie e delle parafarmacie. Le disposizioni hanno effetto dal 12 marzo 2020 e sono efficaci fino al 25 marzo 2020. Con l'entrata in vigore del decreto cessano di produrre effetti, ove incompatibili, le misure di cui al  Dpcm 8 marzo 2020 e Dpcm 9 marzo 2020.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/03/11/20A01605/sg",
      status = "active"
    ),
    list(
      x = (as.integer(as.Date("2020-03-17")) * 86400000),
      name = "Decreto-legge 17 marzo 2020 n. 18  #CuraItalia",
      label = "Decreto-legge",
      description = "Misure di potenziamento del servizio sanitario nazionale e di sostegno economico per famiglie, lavoratori e imprese.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/03/17/20G00034/sg",
      status = "active"
    ),
    list(
      x = (as.integer(as.Date("2020-03-20")) * 86400000),
      name = "Ordinanza del Ministro della Salute 20 marzo 2020",
      label = "Ordinanza del Ministro della Salute",
      description = "Nuove restrizioni in tutta Italia, che hanno validit? fino al 25 marzo. In particolare, chiusura di parchi e ville.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/03/20/20A01797/sg",
      status = "active"
    ),
    list(
      x = (as.integer(as.Date("2020-03-22")) * 86400000),
      name = "DPCM 22 Marzo 2020",
      label = "Decreto ministeriale",
      description = "Il provvedimento prevede la chiusura attivit? produttive non essenziali o strategiche. Aperti alimentari, farmacie, negozi di generi di prima necessit? e i servizi essenziali. Inoltre vieta a tutte le persone fisiche di trasferirsi o spostarsi con mezzi di trasporto pubblici o privati in comune diverso da quello in cui si trovano, salvo che per comprovate esigenze lavorative, di assoluta urgenza ovvero per motivi di salute. Le disposizioni producono effetto dalla data del 23 marzo 2020 e sono efficaci fino al 3 aprile 2020.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/03/22/20A01807/sg",
      status = "active",
      flag = TRUE
    ),
    list(
      x = (as.integer(as.Date("2020-03-25")) * 86400000),
      name = "Decreto del Ministro dello Sviluppo economico 25 marzo 2020",
      label = "Decreto del Ministro dello Sviluppo economico",
      description = "Alle imprese che non erano state sospese dal DPCM 22 marzo 2020 e che, per effetto del presente decreto, dovranno sospendere la propria attivit?, &egrave; stata consentita la possibilit? di ultimare le attivit? necessarie alla sospensione, inclusa la spedizione della merce in giacenza, fino alla data del 28 marzo 2020.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/03/26/20A01877/sg",
      status = "active",
      flag = FALSE
    ),
    list(
      x = (as.integer(as.Date("2020-03-25")) * 86400000),
      name = "Decreto-legge 25 marzo 2020, n. 19",
      label = "Decreto-legge",
      description = " Il decreto prevede che, al fine di contenere e contrastare i rischi sanitari e il diffondersi del contagio, possano essere adottate, su specifiche parti del territorio nazionale o sulla totalit? di esso, per periodi predeterminati, ciascuno di durata non superiore a trenta giorni, reiterabili e modificabili anche pi? volte fino al termine dello stato di emergenza, fissato al 31 luglio 2020 dalla delibera assunta dal Consiglio dei Ministri del 31 gennaio 2020, una o pi? tra le misure previste dal decreto stesso. L'applicazione delle misure potr? essere modulata in aumento ovvero in diminuzione secondo l'andamento epidemiologico del predetto virus, una o pi? tra le misure previste dal decreto stesso, secondo criteri di adeguatezza specifica e principi di proporzionalit? al rischio effettivamente presente.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/03/25/20G00035/sg",
      status = "active",
      flag = FALSE
    ),
    list(
      x = (as.integer(as.Date("2020-04-01")) * 86400000),
      name = "DPCM 1 Aprile 2020",
      label = "Decreto ministeriale",
      description = "Il decreto proroga al 13 aprile 2020 l'efficacia delle disposizioni dei Dpcm dell'8, 9, 11 e 22 marzo 2020, nonch? di quelle previste dall'ordinanza del Ministro della salute del 20 marzo 2020 e dall'ordinanza del 28 marzo 2020 adottata dal Ministro della salute di concerto con il Ministro delle infrastrutture e dei trasporti ancora efficaci alla data del 3 aprile.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/04/02/20A01976/sg",
      status = "active",
      flag = FALSE
    ),
    list(
      x = (as.integer(as.Date("2020-04-10")) * 86400000),
      name = "DPCM 10 Aprile 2020",
      label = "Decreto ministeriale",
      description = "Istituzione del Comitato di esperti in materia economica e sociale. Il Comitato, guidato da Vittorio Colao e composto da esperti in materia economica e sociale, avr? il compito, di concerto con il Comitato tecnico-scientifico, di elaborare le misure necessarie per una ripresa graduale nei diversi settori delle attivit? sociali, economiche e produttive, anche attraverso l'individuazione di nuovi modelli organizzativi e relazionali, che tengano conto delle esigenze di contenimento e prevenzione dell'emergenza.",
      link = "http://www.governo.it/sites/new.governo.it/files/documenti/documenti/Notizie-allegati/covid-19/DPCM_comitato_txt_20200410.pdf",
      status = "active",
      flag = FALSE
    ),
    list(
      x = (as.integer(as.Date("2020-04-10")) * 86400000),
      name = "DPCM 10 Aprile 2020",
      label = "Decreto ministeriale",
      description = "vengono prorogate fino al 3 maggio le misure restrittive sin qui adottate per il contenimento dell'emergenza epidemiologica da Covid-19. Con il nuovo Dpcm, a partire dal 14 aprile, sar? per? permessa l'apertura delle cartolerie, delle librerie e dei negozi di vestiti per bambini e neonati e vengono inserite tra le attivit? produttive consentite la silvicoltura e l'industria del legno. A partire dal 14 aprile, data di efficacia del Dpcm 10 aprile 2020, cessano di produrre effetti i dpcm dell'8, 9, 11 e 22 marzo e del  1 aprile 2020.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/04/11/20A02179/sg",
      status = "active",
      flag = FALSE
    ),
    list(
      x = (as.integer(as.Date("2020-04-26")) * 86400000),
      name = "DPCM 26 Aprile 2020",
      label = "Decreto Ministeriale",
      description = "Il Presidente Conte ha annunciato in conferenza stampa le misure per il contenimento dell'emergenza Covid-19 nella cosiddetta 'fase due'. Tra le novità introdotte dal nuovo Dpcm, le cui misure saranno in vigore a partire dal 4 maggio e per le successive due settimane: la riapertuta delle attività manifatturiere, di costruzioni, di intermediazione immobiliare e il commercio all’ingrosso; è consentita la ristorazione con asporto fermo restando l’obbligo di rispettare la distanza di sicurezza interpersonale di almeno un metro, il divieto di consumare i prodotti all’interno dei locali e il divieto di sostare nelle immediate vicinanze degli stessi.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/04/27/20A02352/sg",
      status = "active",
      flag = TRUE
    )
  )
  return(decrees)
}
