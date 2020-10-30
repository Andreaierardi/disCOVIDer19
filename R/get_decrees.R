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
    ),
    list(
      x = (as.integer(as.Date("2020-05-10")) * 86400000),
      name = "Decreto-Legge 10 Maggio 2020, n. 29",
      label = "Decreto Legge",
      description = "Misure urgenti in materia di detenzione domiciliare o differimento dell'esecuzione della pena, nonche' in materia di sostituzione della custodia cautelare in carcere con la misura degli arresti domiciliari, per motivi connessi all'emergenza sanitaria da COVID-19, di persone detenute o internate per delitti di criminalita' organizzata di tipo mafioso, terroristico e mafioso, o per delitti di associazione a delinquere legati al traffico di sostanze stupefacenti o per delitti commessi avvalendosi delle condizioni o al fine di agevolare l'associazione mafiosa, nonche' di detenuti e internati sottoposti al regime previsto dall'articolo 41-bis della legge 26 luglio 1975, n. 354, nonche', infine, in materia di colloqui con i congiunti o con altre persone cui hanno diritto i condannati, gli internati e gli imputati.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/05/10/20G00047/sg",
      status = "active",
      flag = TRUE
    ),
    list(
      x = (as.integer(as.Date("2020-05-16")) * 86400000),
      name = "Decreto-Legge 16 Maggio 2020, n. 33",
      label = "Decreto Legge",
      description = "Il Consiglio dei Ministri n. 46 ha approvato un decreto-legge che introduce ulteriori misure urgenti per fronteggiare l’emergenza epidemiologica da COVID-19. Il decreto delinea il quadro normativo nazionale all’interno del quale, dal 18 maggio al 31 luglio 2020, con appositi decreti od ordinanze, statali, regionali o comunali, potranno essere disciplinati gli spostamenti delle persone fisiche e le modalità di svolgimento delle attività economiche, produttive e sociali.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/05/16/20G00051/sg",
      status = "active",
      flag = TRUE
    ),
    list(
      x = (as.integer(as.Date("2020-05-17")) * 86400000),
      name = "DPCM 17 Maggio 2020",
      label = "Decreto Ministeriale",
      description = "Disposizioni attuative del decreto-legge 25 marzo 2020, n. 19, recante misure urgenti per fronteggiare l'emergenza epidemiologica da COVID-19, e del decreto-legge 16 maggio 2020, n. 33, recante ulteriori misure urgenti per fronteggiare l'emergenza epidemiologica da COVID-19.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/05/17/20A02717/sg",
      status = "active",
      flag = TRUE
    ),
    list(
      x = (as.integer(as.Date("2020-06-11")) * 86400000),
      name = "DPCM 11 Giugno 2020",
      label = "Decreto Ministeriale",
      description = "Il nuovo Dpcm autorizza la ripresa di ulteriori attività a partire dal 15 giugno tra cui:centri estivi per i bambini, sale giochi, sale scommesse, sale bingo, così come le attività di centri benessere, centri termali, culturali e centri sociali. Riprendono, inoltre, gli spettacoli aperti al pubblico, le sale teatrali, sale da concerto, sale cinematografiche e in altri spazi anche all'aperto ma con alcune cautele/precauzioni. Restano invece sospese tutte le attività che abbiano luogo in sale da ballo, discoteche, locali assimilati sia all'aperto che al chiuso. A partire dal 12 giugno, riprendono invece gli eventi e le competizioni sportive a porte chiuse ovvero all'aperto senza la presenza del pubblico nel rispetto dei protocolli di sicurezza emanati dalle rispettive Federazioni sportive al fine di prevenire le occasioni di contagio. A decorrere dal 25 giugno 2020 è consentito lo svolgimento anche degli sport di contatto nelle Regioni e Province Autonome che, d’intesa con il Ministero della Salute e dell’Autorità di Governo delegata in materia di sport, abbiano preventivamente accertato la compatibilità delle suddette attività con l’andamento della situazione epidemiologica nei rispettivi territori.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/06/11/20A03194/sg",
      status = "active",
      flag = TRUE
    ),
    list(
      x = (as.integer(as.Date("2020-07-14")) * 86400000),
      name = "DPCM 14 Luglio 2020",
      label = "Decreto Ministeriale",
      description = "Proroga al 31 luglio 2020 le misure del Dpcm 11 giugno 2020. Sono inoltre confermate e restano in vigore, sino a tale data, le disposizioni contenute nelle ordinanze del Ministro della salute 30 giugno 2020 e 9 luglio 2020.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/07/14/20A03814/sg",
      status = "active",
      flag = TRUE
    ),
    list(
      x = (as.integer(as.Date("2020-07-30")) * 86400000),
      name = "Decreto-Legge del 30 Luglio 2020",
      label = "Decreto Legge",
      description = "Introduzione di misure urgenti connesse con la scadenza della dichiarazione di emergenza epidemiologica da COVID-19 deliberata il 31 gennaio 2020.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/07/30/20G00112/sg",
      status = "active",
      flag = TRUE
    ),
    list(
      x = (as.integer(as.Date("2020-08-07")) * 86400000),
      name = "DPCM 7 Agosto 2020",
      label = "Decreto Ministeriale",
      description = "Il Consiglio dei Ministri ha approvato un decreto-legge che introduce misure urgenti per il sostegno e il rilancio dell’economia. Con il decreto, il Governo ha stanziato ulteriori 25 miliardi di euro, da utilizzare per proseguire e rafforzare l’azione di ripresa dalle conseguenze negative dell’epidemia da COVID-19 e sostenere lavoratori, famiglie e imprese, con particolare riguardo alle aree svantaggiate del Paese. Inoltre, con il Dpcm firmato dal Presidente Conte vengono prorogate, fino al 7 settembre 2020, le misure precauzionali minime per contrastare e contenere il diffondersi del virus Covid-19.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/08/08/20A04399/sg",
      status = "active",
      flag = TRUE
    ),
    list(
      x = (as.integer(as.Date("2020-08-14")) * 86400000),
      name = "Decreto Legge 14 Agosto 2020",
      label = "Decreto Legge",
      description = "Misure urgenti per il sostegno e il rilancio dell'economia.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/08/14/20G00122/sg",
      status = "active",
      flag = TRUE
    ),
    list(
      x = (as.integer(as.Date("2020-09-07")) * 86400000),
      name = "DPCM 7 Settembre 2020",
      label = "Decreto Ministeriale",
      description = "Ulteriori disposizioni attuative del decreto-legge 25 marzo 2020, n. 19, recante misure urgenti per fronteggiare l'emergenza epidemiologica da COVID-19, e del decreto-legge 16 maggio 2020, n. 33, recante ulteriori misure urgenti per fronteggiare l'emergenza epidemiologica da COVID-19.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/09/07/20A04814/sg",
      status = "active",
      flag = TRUE
    ),
    list(
      x = (as.integer(as.Date("2020-09-08")) * 86400000),
      name = "Decreto Legge 8 Settembre 2020",
      label = "Decreto Legge",
      description = "Disposizioni urgenti per far fronte a indifferibili esigenze finanziarie e di sostegno per l'avvio dell'anno scolastico, connesse all'emergenza epidemiologica da COVID-19.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/09/08/20G00134/sg",
      status = "active",
      flag = TRUE
    ),
    list(
      x = (as.integer(as.Date("2020-09-11")) * 86400000),
      name = "Decreto Legge 11 Settembre 2020",
      label = "Decreto Legge",
      description = "Disposizioni urgenti per la pulizia e la disinfezione dei locali adibiti a seggio elettorale e per il regolare svolgimento dei servizi educativi e scolastici gestiti dai comuni.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/09/12/20G00140/sg",
      status = "active",
      flag = TRUE
    ),
    list(
      x = (as.integer(as.Date("2020-10-07")) * 86400000),
      name = "Decreto Legge 7 Ottobre 2020",
      label = "Decreto Legge",
      description = "Misure urgenti connesse con la proroga della dichiarazione dello stato di emergenza epidemiologica da COVID-19 e per la continuità operativa del sistema di allerta COVID, nonché attuazione della direttiva (UE) 2020/739 del 3 giugno 2020.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/10/07/20G00144/sg",
      status = "active",
      flag = TRUE
    ),
    list(
      x = (as.integer(as.Date("2020-10-13")) * 86400000),
      name = "DPCM 13 Ottobre 2020",
      label = "Decreto Ministeriale",
      description = "Ulteriori disposizioni attuative del decreto-legge 25 marzo 2020, n. 19, convertito, con modificazioni, dalla legge 25 maggio 2020, n. 35, recante «Misure urgenti per fronteggiare l'emergenza epidemiologica da COVID-19», e del decreto-legge 16 maggio 2020, n. 33, convertito, con modificazioni, dalla legge 14 luglio 2020, n. 74, recante 'Ulteriori misure urgenti per fronteggiare l'emergenza epidemiologica da COVID-19'.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/10/13/20A05563/sg",
      status = "active",
      flag = TRUE
    ),
    list(
      x = (as.integer(as.Date("2020-10-18")) * 86400000),
      name = "DPCM 18 Ottobre 2020",
      label = "Decreto Ministeriale",
      description = "Ulteriori disposizioni attuative del decreto-legge 25 marzo 2020, n. 19, convertito, con modificazioni, dalla legge 25 maggio 2020, n. 35, recante «Misure urgenti per fronteggiare l'emergenza epidemiologica da COVID-19», e del decreto-legge 16 maggio 2020, n. 33, convertito, con modificazioni, dalla legge 14 luglio 2020, n. 74, recante 'Ulteriori misure urgenti per fronteggiare l'emergenza epidemiologica da COVID-19'.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/10/18/20A05727/sg",
      status = "active",
      flag = TRUE
    ),
    list(
      x = (as.integer(as.Date("2020-10-20")) * 86400000),
      name = "Decreto Legge 20 Ottobre 2020",
      label = "Decreto Legge",
      description = "Disposizioni urgenti in materia di riscossione esattoriale.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/10/20/20G00149/sg",
      status = "active",
      flag = TRUE
    ),
    list(
      x = (as.integer(as.Date("2020-10-24")) * 86400000),
      name = "DPCM 24 Ottobre 2020",
      label = "Decreto Ministeriale",
      description = "Ulteriori disposizioni attuative del decreto-legge 25 marzo 2020, n. 19, convertito, con modificazioni, dalla legge 25 maggio 2020, n. 35, recante «Misure urgenti per fronteggiare l'emergenza epidemiologica da COVID-19», e del decreto-legge 16 maggio 2020, n. 33, convertito, con modificazioni, dalla legge 14 luglio 2020, n. 74, recante 'Ulteriori misure urgenti per fronteggiare l'emergenza epidemiologica da COVID-19'.",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/10/25/20A05861/sg",
      status = "active",
      flag = TRUE
    ),
    list(
      x = (as.integer(as.Date("2020-10-28")) * 86400000),
      name = "Decreto Legge 28 Ottobre 2020",
      label = "Decreto Legge",
      description = "Ulteriori misure urgenti in materia di tutela della salute, sostegno ai lavoratori e alle imprese, giustizia e sicurezza, connesse all'emergenza epidemiologica da Covid-19. ",
      link = "https://www.gazzettaufficiale.it/eli/id/2020/10/28/20G00166/sg",
      status = "active",
      flag = TRUE
    )
  )
  return(decrees)
}
