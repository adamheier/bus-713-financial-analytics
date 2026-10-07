# Analyse-Ergebnisse Task 2: NVDA vs. INTC vs. Nasdaq + Investitionsprojekt

> **Arbeitsdokument** mit allen Zahlen und ihrer Interpretation — kein Abgabebestandteil. Die drei
> Submission Components bauen darauf auf: [01_video_presentation.md](01_video_presentation.md),
> [02_r_script.md](02_r_script.md), [03_executive_summary.md](03_executive_summary.md).
> Alle Zahlen aus [bus713_R-code_AdamHeier2.R](bus713_R-code_AdamHeier2.R), Rohausgabe in
> [output/run_log.txt](output/run_log.txt).

---

## 1. Datenbasis

| | |
|---|---|
| Zeitraum | Oktober 2021 – September 2026, **60 Monatsrenditen** (Standardfenster für Beta laut Modul 4.1) |
| Aktien | NVIDIA (NVDA), Intel (INTC), Monatsendkurse, `adjusted` (Dividenden und Splits bereinigt) |
| Markt | Nasdaq Composite (`^IXIC`), wie in der Aufgabenstellung gefordert |
| Risikofreier Zins | 10-jährige US-Staatsanleihe (`^TNX`), Modul-4-Formel `(yield / 100) / 12` |
| Forecast | Intel, Monatsschlusskurse (`close`), Prognose Oktober 2026 – März 2027 |
| Projekt | 500.000 $ Investition, 200.000 $ Umsatz, 100.000 $ Kosten p.a., 5 Jahre |

**Warum der 10Y-Zins aus Yahoo statt FRED:** Modul 4 nutzt die Rendite der 10-jährigen
Staatsanleihe als risikofreien Zins. FRED lehnt `tq_get(get = "economic.data")` ohne API-Key ab
(dasselbe Problem wie in Task 1); `^TNX` liefert dieselbe Größe über dieselbe Quelle wie die Kurse.

**Warum das Fenster bis September 2026 reicht:** Die Aufgabe gibt keinen Zeitraum vor. Ein
Portfoliomanager entscheidet heute — also die jüngsten fünf Jahre, und der Sechsmonats-Forecast
zeigt echt in die Zukunft.

---

## 2. Ergebnis auf einen Blick

| Kennzahl | NVIDIA | Intel | Nasdaq |
|---|---:|---:|---:|
| **Beta** | **1,93** | **1,84** | 1,00 |
| 95 %-Konfidenzintervall Beta | 1,52 – 2,34 | 1,04 – 2,64 | — |
| Alpha pro Monat (p-Wert) | **+3,06 % (p = 0,013)** | +1,27 % (p = 0,59) | — |
| R² | 0,61 | **0,27** | — |
| CAPM-erwartete Rendite (historische MRP) | 24,4 % | 23,4 % | 14,5 % |
| Realisierte Durchschnittsrendite p.a. | 61,1 % | 38,6 % | 14,5 % |
| Abstand zur SML (= Alpha p.a.) | +36,7 pp | +15,2 pp | 0 |
| **SML-Einstufung** | **über der SML → unterbewertet** | **über der SML → unterbewertet** | auf der SML |
| CAPM erwartet, vorwärtsgerichtet (5,3 % + β × 5 %) | 14,9 % | 14,5 % | 10,3 % |
| Volatilität p.a. | 50,1 % | **72,2 %** | 20,3 % |

| Eingangsgröße | Wert |
|---|---|
| Ø risikofreier Zins (10Y, Okt 2021 – Sep 2026) | 3,84 % |
| Marktrisikoprämie (historisch) | 10,65 % |
| 10Y-Zins Ende September 2026 | 5,29 % |
| Korrelation NVDA – INTC | **0,23** |
| 50/50-Portfolio: Volatilität / Beta | 48,4 % / 1,89 |
| Intel-Forecast März 2027 (Punkt / 80 % / 95 %) | 120 $ / 68 – 212 $ / 50 – 287 $ |
| **Projekt-NPV bei 10 % / IRR** | **−120.921 $ / 0 %** |
| Monte Carlo: P(NPV > 0) | **1,2 %** |

---

## 3. Beta — die CAPM-Regression (Frage 1, Teil 1)

Methode wie in `capm.r` aus Modul 4 und Workshop 4, Aufgabe 2: monatliche Überschussrendite der
Aktie auf die Überschussrendite des Nasdaq regressiert, `lm(nvda_excess ~ nasdaq_excess)`.

**NVIDIA — Beta 1,93, R² 0,61.** Bewegt sich der Nasdaq um 1 %, bewegt sich NVIDIA im Schnitt um
1,9 %. Der Markt erklärt 61 % der Monatsbewegungen. Das Alpha von 3,06 % pro Monat ist mit
p = 0,013 **statistisch signifikant** — NVIDIA hat über fünf Jahre deutlich mehr verdient, als sein
Marktrisiko erklärt. Das ist der KI-Boom in einer Zahl.

**Intel — Beta 1,84, R² 0,27.** Ähnliches Beta, aber der Markt erklärt nur 27 % der Bewegungen;
73 % sind firmenspezifisch (Fertigung, Turnaround, Nachrichten). Das Alpha von 1,27 % pro Monat
ist mit p = 0,59 **nicht von null unterscheidbar**.

**Die Grafik** `01_capm_regression.png` zeigt den Unterschied auf einen Blick: Bei NVIDIA liegen
die Punkte eng um die Linie, bei Intel streuen sie breit — und ein einzelner Punkt oben rechts
(April 2026: Intel +114 %, Nasdaq +15 %) zieht die Linie nach oben.

---

## 4. CAPM-Erwartungsrendite und SML (Frage 1, Teil 2)

**Inputs** (Kursdefinition aus Modul 4.1: Marktrisikoprämie = durchschnittliche historische
Überschussrendite des Marktes):

- risikofreier Zins = Durchschnitt des 10Y-Zinses über die 60 Monate = 3,84 %
- Marktrisikoprämie = Nasdaq-Durchschnittsrendite 14,49 % − 3,84 % = **10,65 %**

**CAPM:** NVIDIA 3,84 % + 1,93 × 10,65 % = **24,4 %**; Intel 3,84 % + 1,84 × 10,65 % = **23,4 %**.

**SML-Test** (Workshop 4, Aufgabe 16): realisierte Durchschnittsrendite gegen CAPM-Erwartung.

| | CAPM verlangt | realisiert | Position |
|---|---:|---:|---|
| NVIDIA | 24,4 % | 61,1 % | 36,7 pp über der SML → unterbewertet |
| Intel | 23,4 % | 38,6 % | 15,2 pp über der SML → unterbewertet |

Beide liegen über der Linie. Laut Modul 4.3 heißt das: Die Aktie bietet mehr Rendite, als ihr Beta
rechtfertigt — ihr Preis ist relativ zur CAPM-Vorhersage zu niedrig.

**Methodischer Pluspunkt:** Weil Regression und SML auf denselben 60 Monaten beruhen, liegt der
Nasdaq exakt auf der Linie, und der Abstand jeder Aktie zur SML ist **genau ihr annualisiertes
Regressions-Alpha** (NVIDIA: 3,06 % × 12 = 36,7 %). Regression und SML erzählen dieselbe
Geschichte — und die Signifikanz des Alphas sagt, wie sehr man der SML-Einstufung trauen darf.

**Die eigentliche Erkenntnis:** Beide Aktien liegen über der SML, aber nur bei NVIDIA ist das
statistisch belastbar. Intels Position beruht im Wesentlichen auf einem einzigen Monat.

**Vorwärtsgerichtete Variante:** Die historische Prämie von 10,65 % stammt aus fünf
außergewöhnlich starken Jahren. Mit dem heutigen 10Y-Zins (5,29 %) und einer langfristigen Prämie
von 5 % verlangt das CAPM nur rund **15 %** für beide Aktien. Die „erwartete Rendite" hängt also
stark an der Annahme zur Marktrisikoprämie.

---

## 5. CAPM-Limitationen und Vertrauen in die Ergebnisse (Frage 1, Teil 3)

Theorie aus Modul 4.4 (Fama/French 2004): Wäre das CAPM korrekt, müsste Alpha null sein. In der
Praxis variiert Alpha mit Größe, Bewertung (Value) und Momentum — ein einziger Faktor reicht nicht.

**Die eigenen Daten liefern fünf konkrete Belege:**

| Limitation | Beleg aus der Analyse | Konsequenz |
|---|---|---|
| Beta ist ungenau geschätzt | Intels 95 %-Intervall reicht von 1,04 bis 2,64 | Intel kann marktähnlich oder extrem marktsensitiv sein — die Daten erlauben beides |
| Beta ist instabil | Intels Beta ohne 2026: **1,11**; mit 2026: **1,84** | Neun Monate verändern die Risikoeinschätzung um zwei Drittel |
| Ausreißer dominieren | April 2026: Intel +114 % | Ein einziger Monat treibt Intels Beta und Alpha |
| Ein Faktor erklärt wenig | Intels R² = 0,27 | 73 % des Intel-Risikos liegen außerhalb des Modells |
| Inputs sind Annahmen | Historische MRP 10,65 % vs. langfristig ~5 % | CAPM-Erwartung schwankt zwischen ~15 % und ~24 % |

Dazu zwei konzeptionelle Punkte:

- **Marktproxy:** Der Nasdaq ist technologielastig und nicht das „Marktportfolio" der Theorie.
  NVIDIA ist selbst eines der größten Gewichte im Index — ein Teil von NVIDIAs hohem R² entsteht
  dadurch, dass NVIDIA den Index mitbewegt.
- **Vergangenheit ≠ Zukunft:** Ein historisches Alpha ist kein Kaufsignal. NVIDIAs Alpha spiegelt
  die KI-Nachfrage der letzten Jahre; dass es sich wiederholt, sagt das CAPM nicht.

**Vertrauensurteil:** Mittleres Vertrauen in NVIDIAs Ergebnisse (präzises Beta, hohes R²,
signifikantes Alpha), **geringes Vertrauen in Intels** (breites Intervall, instabiles Beta, nicht
signifikantes Alpha, ein Monat dominiert). Die SML-Einstufung ist ein Hinweis, keine
Bewertungsaussage.

---

## 6. Korrelation und Diversifikation (Frage 1, Teil 4)

**Korrelation NVIDIA – Intel: 0,23** — überraschend niedrig für zwei Halbleiterhersteller. Beide
reagieren auf den Markt, aber ihre firmenspezifischen Geschichten (KI-Gewinner vs. Turnaround)
laufen weitgehend unabhängig.

| | Volatilität p.a. | Beta |
|---|---:|---:|
| NVIDIA | 50,1 % | 1,93 |
| Intel | 72,2 % | 1,84 |
| **50/50-Portfolio** | **48,4 %** | **1,89** |
| Nasdaq | 20,3 % | 1,00 |

**Was das zeigt:**

1. **Diversifikation wirkt beim Gesamtrisiko.** Das Portfolio ist *weniger* volatil als NVIDIA
   allein (48,4 % < 50,1 %), obwohl Intel die deutlich riskantere Aktie ist. Gegenüber dem
   gewichteten Durchschnitt der beiden (61,1 %) fallen 13 Prozentpunkte Volatilität weg. Das ist
   die Lehrbuchwirkung niedriger Korrelation.
2. **Diversifikation wirkt nicht beim Marktrisiko.** Das Portfolio-Beta bleibt bei 1,89 — fast
   doppelt so marktsensitiv wie der Index. Zwei High-Beta-Aktien zu kombinieren entfernt
   firmenspezifisches Risiko, nicht das systematische.
3. **Im Absoluten bleibt es riskant:** 48 % Volatilität sind das 2,4-Fache des Nasdaq.

**Antwort auf „meaningful diversification?":** Ja beim firmenspezifischen Risiko, nein beim
Marktrisiko. Die Kombination ist eine diversifizierte, aber gehebelte Wette auf den Nasdaq.

---

## 7. Sechs-Monats-Forecast Intel (Frage 1, Teil 5)

**Warum Intel:** Nach einer Verdreifachung 2026 (44 $ Ende März → 120 $ Ende September) ist die
naheliegende Frage eines Portfoliomanagers: Wohin jetzt?

**Methodenvergleich auf einem Hold-out** (Modul 6.5: „always evaluate accuracy on a hold-out
period"; Workshop 6, Aufgabe 12 vergleicht genau ETS gegen linearen Trend). Training bis März
2026, Test April – September 2026:

| Methode | RMSE | MAPE |
|---|---:|---:|
| ETS (log-Preise) | 66,5 | 58,0 % |
| Linearer Trend | 83,2 | 74,3 % |

ETS gewinnt — aber beide liegen massiv daneben, weil Intel im Testzeitraum um 170 % stieg.

**Gewähltes Modell: ETS auf Log-Preisen** (`ets(intc_price, lambda = 0)`):

- ETS ist das vielseitigste Verfahren der Vorlesung und wählt seine Variante selbst.
- Log-Preise, weil Kursänderungen proportional sind (Modul 1) und die Prognose nie negativ wird.
  Ohne Log-Transformation fällt die untere 95 %-Grenze nach sechs Monaten auf **−8,56 $** —
  offensichtlich sinnlos (Vortest, nicht im Skript).
- **Das Modell wählt ETS(A,N,N) mit Glättungsparameter = 1.** Es kommt selbst zu dem Schluss,
  dass der beste Prognosewert für den nächsten Monat der aktuelle Kurs ist — ein Random Walk,
  genau wie in Modul 2 für nicht-stationäre Kurse beschrieben.

**Warum nicht der lineare Trend:** Er prognostiziert **57 $ im Oktober 2026 bis 59 $ im März
2027** — die Hälfte des heutigen Kurses —, weil er den Abwärtstrend 2021–2025 fortschreibt, der
sich längst umgekehrt hat.
Genau die Gefahr, vor der Workshop 6 warnt: Eine Gerade durch einen nicht-stationären Kurs
extrapoliert die Vergangenheit.

**Die Prognose:**

| Monat | Punkt | 80 %-Intervall | 95 %-Intervall |
|---|---:|---:|---:|
| Oktober 2026 | 120 $ | 95 – 152 $ | 84 – 171 $ |
| März 2027 | 120 $ | **68 – 212 $** | 50 – 287 $ |

**Zuverlässigkeit — kritische Bewertung:**

- Die Punktprognose ist flach: Das Modell erkennt keine verlässliche Richtung.
- Die Unsicherheit ist enorm: Nach sechs Monaten reicht das 80 %-Intervall von −43 % bis +77 %.
- Auf dem Hold-out lag der Fehler bei 58 % — mehr als die Hälfte des Kurses.
- Ergänzend getestet (nicht im Skript): Über vier verschiedene Sechsmonatsfenster gewinnt mal ETS,
  mal der Trend — je nachdem, in welche Richtung der Markt zufällig lief. Kein Verfahren schlägt
  den Random Walk systematisch.

**Was das für den Portfoliomanager heißt:** Der Forecast ist keine Grundlage für eine
Richtungswette. Sein Wert liegt im Intervall: Er beziffert, wie weit Intel in sechs Monaten
plausibel fallen kann (auf ~68 $ im 80 %-Szenario). Daraus folgt eine Positionsgrößen- und
Absicherungsentscheidung, keine Kaufentscheidung — und das führt direkt zum Hedging.

---

## 8. Hedging: Protective Put auf Intel (Frage 1, Teil 6)

Workshop 5 ist ausdrücklich ohne R — dieser Teil ist Diskussion, gestützt auf Zahlen aus dem
Skript.

**Instrument:** Kauf von Put-Optionen auf Intel (Protective Put).

**Mechanik am Beispiel:** 100 Intel-Aktien zu 120 $; Kauf eines Put-Kontrakts (100 Aktien) mit
Strike 100 $ und Laufzeit sechs Monate (passend zum Forecast-Horizont).

| Intel im März 2027 | Aktie | Put-Auszahlung | Ergebnis vor Prämie |
|---|---:|---:|---:|
| 68 $ (untere 80 %-Grenze) | −5.223 $ | +3.200 $ | −2.023 $ |
| 100 $ | −2.023 $ | 0 $ | −2.023 $ |
| 160 $ | +3.977 $ | 0 $ | +3.977 $ |

Der Verlust ist bei 2.023 $ + Prämie gedeckelt, egal wie tief Intel fällt; nach oben bleibt der
Gewinn vollständig erhalten (abzüglich Prämie). Workshop 5, Aufgabe 4 und 5 beschreiben genau
diese Asymmetrie.

**Warum Optionen statt Futures — direkt aus Frage 1 abgeleitet:**

- Einzelaktien-Futures werden in den USA nicht mehr gehandelt. Ein Futures-Hedge müsste über
  Nasdaq-Index-Futures laufen, mit Beta 1,84 skaliert.
- **Intels R² liegt bei 0,27** — 73 % seines Risikos sind firmenspezifisch. Ein Index-Hedge würde
  den Großteil des Intel-Risikos gar nicht abdecken (Basisrisiko).
- Futures erfordern Margin und tägliches Marking-to-Market (Workshop 5, Aufgabe 2) und nehmen auch
  die Aufwärtschance weg.

**Vorteile des Puts:** maximaler Verlust bekannt und begrenzt; Aufwärtspotenzial bleibt; keine
Margin Calls; hedgt genau Intel, nicht den Index.

**Grenzen — ehrlich bewertet:**

- **Kosten:** Bei 72 % Volatilität sind Puts teuer; sechs Monate Schutz kosten einen
  zweistelligen Prozentsatz des Aktienkurses. Die Prämie ist ein sicherer Verlust, wenn Intel
  nicht fällt.
- **Laufzeit:** Der Schutz endet nach sechs Monaten; Verlängern (Rollen) kostet erneut Prämie.
- **Restverlust:** Zwischen 120 $ und dem Strike von 100 $ bleibt der Verlust ungeschützt.
- **Abmilderung:** Ein Collar (zusätzlich einen Call verkaufen) senkt die Kosten, deckelt aber das
  Aufwärtspotenzial.

---

## 9. Projekt: NPV und IRR im Base Case (Frage 2, Teil 1)

Cashflows: −500.000 $ heute, dann fünfmal +100.000 $ (200.000 $ Umsatz − 100.000 $ Kosten).

| Kennzahl | Wert | Bedeutung |
|---|---:|---|
| **NPV bei 10 %** | **−120.921 $** | Das Projekt vernichtet in heutigen Dollar 121.000 $ Wert |
| **IRR** | **0 %** | Das Projekt gibt genau das eingesetzte Geld zurück — ohne Verzinsung |

**Die Falle in der Aufgabe:** 5 × 100.000 $ = 500.000 $. Das Projekt zahlt nominal genau die
Investition zurück. Jeder positive Diskontsatz macht den NPV negativ:

| Diskontsatz | 0 % | 5 % | 8 % | 10 % | 12 % |
|---|---:|---:|---:|---:|---:|
| NPV | 0 $ | −67.052 $ | −100.729 $ | −120.921 $ | −139.522 $ |

**Warum 10 %:** typische Mindestrendite eines Unternehmens und der Satz des Vorlesungsbeispiels in
Modul 6.2 — vor allem aber **entscheidungsirrelevant**, weil der NPV bei jedem positiven Satz
negativ ist.

**Break-even** (was müsste sich ändern, damit NPV = 0 bei 10 %?):

- Umsatz **231.899 $ statt 200.000 $** — 16 % mehr, in jedem der fünf Jahre
- oder Investition **höchstens 379.079 $ statt 500.000 $** — 24 % weniger

---

## 10. Unsicherheit: Monte-Carlo-Simulation (Frage 2, Teil 2)

**Warum Monte Carlo** (Begründung für die Aufgabenstellung):

- Die Aufgabe sagt ausdrücklich, dass eine einzelne NPV-Zahl „false precision" erzeugt, wenn die
  Cashflows unsicher sind. Szenarioanalyse (Modul 6.3) liefert drei Punkte, Monte Carlo die ganze
  Verteilung und damit eine **Wahrscheinlichkeit**, dass das Projekt Wert schafft.
- Umsatz und Kosten sind unabhängige Unsicherheitsquellen; Monte Carlo variiert beide gleichzeitig
  in jedem Jahr — Sensitivitätsanalyse könnte nur eine Variable auf einmal bewegen.
- Struktur wie in Workshop 6, Aufgabe 5.

**Annahmen:** Umsatz normalverteilt um 200.000 $ mit 15 % Standardabweichung, Kosten um 100.000 $
mit 10 %. Umsatz ist unsicherer, weil Nachfrage und Preise vom Markt bestimmt werden, Kosten dagegen
weitgehend vom Unternehmen. 10.000 Läufe, `set.seed(713)` für Reproduzierbarkeit.

**Ergebnis:**

| | Wert |
|---|---:|
| Mittlerer NPV | −121.476 $ |
| 5 %-Perzentil (schlechtes Szenario) | −210.529 $ |
| 95 %-Perzentil (gutes Szenario) | **−32.026 $** |
| **Wahrscheinlichkeit NPV > 0** | **1,2 %** |

**Interpretation:** Selbst die besten 5 % der simulierten Zukünfte verlieren Geld. Die Unsicherheit
rettet das Projekt nicht — sie macht nur sichtbar, wie viel noch schlechter es laufen kann. Für die
Aufgabenstellung heißt das: Hier ist der Base Case bereits eindeutig, und die Simulation zeigt, dass
er kein Grenzfall ist.

**Limitation der Simulation:** Die Jahre werden unabhängig gezogen; gute und schlechte Jahre gleichen
sich teilweise aus. Ist die Nachfrage dauerhaft niedriger als geplant, wird die Verteilung breiter —
die Abwärtsrisiken also größer, nicht kleiner. Die Ablehnung bleibt davon unberührt.

---

## 11. Kernbotschaften und Empfehlung

**Frage 1:**

1. **Beide Aktien verstärken den Markt um fast das Doppelte** (Beta 1,9 / 1,8).
2. **Beide liegen über der SML — aber nur NVIDIA belastbar.** NVIDIAs Alpha ist signifikant, Intels
   nicht; Intels Zahlen hängen an einem einzigen Monat.
3. **Gemeinsam halten senkt das Gesamtrisiko, nicht das Marktrisiko** (Korrelation 0,23,
   Portfolio-Beta 1,89).
4. **Intels Kurs ist auf sechs Monate nicht prognostizierbar** — die ehrliche Prognose ist „heutiger
   Kurs, ± die Hälfte".

**Empfehlung an den Portfoliomanager:** Beide Aktien sind als Satellitenposition vertretbar, wenn
man bewusst gehebelte Nasdaq-Exposition will — zusammen besser als einzeln. NVIDIA höher gewichten
(belastbarere Kennzahlen), Intel kleiner halten und mit Puts gegen einen Rückschlag nach der Rally
absichern. Die Positionsgröße muss das Beta von ~1,9 einpreisen: Ein Marktrückgang von 10 %
bedeutet im Erwartungswert rund −19 % für die Position.

**Frage 2:** **Projekt zu den aktuellen Konditionen ablehnen.** NPV −121.000 $, IRR 0 %, und in
98,8 % der simulierten Zukünfte vernichtet es Wert. Neu prüfen nur, wenn die Investition unter
~380.000 $ fällt, der Umsatz verlässlich 16 % höher liegt oder das Projekt eine Realoption
(Erweiterung, Abbruch) enthält, die mehr als 121.000 $ wert ist (Modul 6.2).

---

## 12. Limitationen der gesamten Analyse

| Limitation | Auswirkung |
|---|---|
| 60 Monate inkl. eines Extremjahres | Intels Kennzahlen hängen stark an 2026; ein anderes Fenster ergibt ein anderes Beta |
| Historische Marktrisikoprämie | 10,65 % sind außergewöhnlich hoch; vorwärtsgerichtet ~15 % statt ~24 % CAPM-Erwartung |
| Nasdaq als Marktproxy | Technologielastig, NVIDIA ist selbst großes Indexgewicht |
| Ein-Faktor-Modell | Größe, Value, Momentum (Fama/French) nicht berücksichtigt |
| Forecast auf 60 Monatswerten | Kurze Historie, ein Hold-out-Fenster, Random-Walk-Verhalten |
| Put-Prämie nicht berechnet | Keine Optionspreisdaten; Kosten nur qualitativ bewertet |
| Projekt ohne Steuern, Restwert, Inflation | Alle drei würden den NPV verändern; ein Restwert ist der wahrscheinlichste Hebel |
| Monte Carlo mit unabhängigen Jahren | Unterschätzt das Risiko dauerhaft schwacher Nachfrage |

---

## 13. Formaler Hinweis zur Abgabe

Die Aufgabenbeschreibung (AT2-PDF, „AI-Supported Learning Statement") verlangt: *„You must
acknowledge the use of AI in your submission."* Ein kurzer Hinweis gehört also in die Abgabe —
z. B. als Fußnote in der Executive Summary oder als Kommentar im Skriptkopf.
