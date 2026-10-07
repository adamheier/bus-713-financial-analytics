# Submission Component 2 — R Script

> **Abgabedatei:** [bus713_R-code_AdamHeier2.R](bus713_R-code_AdamHeier2.R) — 297 Zeilen, davon
> **145 Codezeilen**, der Rest Kommentare. Läuft in etwa 6 Sekunden fehlerfrei durch und erzeugt
> vier Grafiken in `output/`. Dieses Dokument erklärt Aufbau und Entscheidungen — die
> Begründungen sind genau das, was im Video als „why" erklärt werden soll.

## Ausführen

In RStudio öffnen und `Source` (Strg+Shift+S), oder im Terminal:

```bash
Rscript bus713_R-code_AdamHeier2.R
```

**Pakete:** `tidyquant`, `tidyverse`, `forecast`, `FinCal` — Installationszeile auskommentiert in
Zeile 23. `FinCal` ist das Paket aus Modul 6.2 für `npv()` und `irr()`.

**Daten:** Alles kommt zur Laufzeit von Yahoo Finance, keine lokalen Dateien, kein API-Key.

---

## Aufbau

| Abschnitt | Zeilen | Inhalt | Modul |
|---|---|---|---|
| Setup | 23–30 | Pakete, Output-Ordner | — |
| **1** Daten | 38–72 | Monatsendkurse NVDA, INTC, Nasdaq, 10Y-Zins; Renditen und Überschussrenditen | 4.1 |
| **2** Beta | 76–106 | Zwei CAPM-Regressionen, Scatterplot | 4.1 |
| **3** CAPM + SML | 110–158 | Erwartete vs. realisierte Rendite, Alpha, Einstufung, SML-Grafik | 4.3 |
| **4** Zuverlässigkeit | 162–174 | Konfidenzintervalle für Beta, Intel-Beta ohne 2026 | 4.4 |
| **5** Korrelation | 178–193 | Korrelation, 50/50-Portfolio gegen Einzelaktien | 3.2 |
| **6** Forecast | 197–235 | Hold-out-Vergleich ETS gegen Trend, Sechs-Monats-Prognose Intel, Grafik | 6.5 |
| **7** NPV / IRR | 243–264 | Base Case, NPV bei mehreren Zinssätzen, Break-even-Punkte | 6.2 |
| **8** Monte Carlo | 268–297 | 10.000 simulierte Projektverläufe, Wahrscheinlichkeit NPV > 0, Histogramm | 6.3 / Workshop 6 |

Frage 1 umfasst Abschnitt 1–6, Frage 2 Abschnitt 7–8. Die Reihenfolge folgt der Aufgabenstellung:
Beta → CAPM/SML → Limitationen → Korrelation → Forecast. Hedging ist bewusst ohne Code, weil
Workshop 5 ausdrücklich „No R" ist — ein Kommentar in Zeile 233–235 verweist auf die Kennzahlen,
auf die sich die Diskussion stützt.

---

## Entscheidungen, die im Video erklärt werden sollten

### 1. 60 Monate, Oktober 2021 – September 2026 (Zeile 44–45)

Modul 4.1 beschreibt fünf Jahre Monatsdaten als übliche Praxis für die Beta-Schätzung. Das Fenster
endet im September 2026, weil ein Portfoliomanager heute entscheidet — und damit der Forecast echt
in die Zukunft reicht (Oktober 2026 – März 2027).

### 2. 10-jährige Staatsanleihe über `^TNX` als risikofreier Zins (Zeile 41–45, 62)

Modul 4.1: *„The risk-free rate is typically taken to be the yield on a long-term (10 years)
government bond."* Die Umrechnung `(tbill_10 / 100) / 12` ist exakt die Formel aus `capm.r`. Der
Zins kommt von Yahoo statt FRED, weil FRED ohne API-Key ablehnt — so liegt alles in einer Quelle,
und das Skript ist auf jedem Rechner reproduzierbar.

### 3. Überschussrenditen und `lm()` wie in `capm.r` (Zeile 56–84)

Die Tabelle `capm_data` hat bewusst dasselbe Layout wie im Modul: eine Zeile pro Monat, Spalten für
Kurse, Renditen und Überschussrenditen. Die Regression `lm(nvda_excess ~ nasdaq_excess)` ist
wörtlich die Modulmethode. Bereinigte Kurse (`adjusted`), weil Renditen Dividenden enthalten müssen.

### 4. Eigener Abschnitt für die Zuverlässigkeit (Zeile 162–174)

Drei Zeilen, die die Frage „how much confidence should an investor place in your findings?" mit
Daten beantworten statt mit Theorie: Intels Beta-Intervall reicht von 1,04 bis 2,64, und ohne 2026
fällt sein Beta von 1,84 auf 1,11. Der Abschnitt steht bewusst **nach** der SML — in der Reihenfolge
der Aufgabenstellung und passend zum chronologischen Durchgang im Video.

### 5. Marktrisikoprämie aus denselben 60 Monaten (Zeile 113–137)

Modul 4.1 definiert die Marktrisikoprämie als durchschnittliche historische Überschussrendite des
Marktes. Weil Regression und SML auf demselben Zeitraum beruhen, liegt der Nasdaq exakt auf der
Linie, und der Abstand einer Aktie zur SML ist **genau ihr annualisiertes Regressions-Alpha**. Die
Spalte `capm_forward` zeigt zusätzlich, was das CAPM mit heutigem Zins und einer langfristigen
Prämie von 5 % verlangen würde — eine Zeile, die die Abhängigkeit von dieser Annahme sichtbar macht.

### 6. Volatilität und Beta im Portfoliovergleich (Zeile 181–193)

Die Frage „meaningful diversification?" braucht zwei Maße: Volatilität zeigt, ob das Gesamtrisiko
sinkt (ja), Beta zeigt, ob das Marktrisiko sinkt (nein). Ein 50/50-Portfolio aus den Renditereihen
macht beides in vier Zeilen sichtbar.

### 7. Hold-out vor der Prognose (Zeile 206–214)

Modul 6.5: *„When comparing models, always evaluate accuracy on a hold-out period."* Die letzten
sechs Monate — gleiche Länge wie der Forecast — werden zurückgehalten. Verglichen werden genau die
zwei Verfahren aus Workshop 6, Aufgabe 12: ETS und linearer Trend.

### 8. ETS auf Log-Preisen (Zeile 216–219)

`lambda = 0` modelliert Log-Preise: Kursänderungen sind proportional (Modul 1, Log-Renditen), und
das Prognoseintervall kann nicht unter null fallen. Das Modell wählt selbst ETS(A,N,N) mit einem
Glättungsparameter von 1 — also: Der beste Prognosewert ist der aktuelle Kurs. Das ist der Random
Walk aus Modul 2, von den Daten bestätigt statt vorausgesetzt.

### 9. NPV bei mehreren Zinssätzen und Break-even (Zeile 258–264)

Die `sapply`-Zeile zeigt, dass der NPV bei jedem positiven Zinssatz negativ ist — die Wahl von 10 %
ist damit entscheidungsirrelevant. Die zwei Break-even-Zeilen übersetzen den NPV in Management-
Sprache: Was müsste sich ändern, damit das Projekt sich lohnt?

### 10. Monte Carlo nach Workshop-Struktur (Zeile 271–285)

`rnorm()` für Umsatz und Kosten in jedem Jahr, wie in Workshop 6, Aufgabe 5. `replicate()` hält den
Code kurz, `set.seed(713)` macht das Ergebnis reproduzierbar. Umsatz streut stärker (15 %) als
Kosten (10 %), weil Nachfrage und Preise vom Markt bestimmt werden.

---

## Erzeugte Ausgaben

| Datei | Inhalt | Beantwortet |
|---|---|---|
| `01_capm_regression.png` | Monatliche Überschussrenditen, Regressionslinie je Aktie | Beta, R², Ausreißer April 2026 |
| `02_security_market_line.png` | SML mit NVIDIA, Intel, Nasdaq; Alpha als gestrichelte Linie | Über-/Unterbewertung |
| `03_intel_forecast.png` | Kursverlauf und Sechs-Monats-Prognose mit 80/95 %-Intervall | Forecast gegen Historie |
| `04_npv_simulation.png` | Histogramm von 10.000 simulierten NPVs, Linie bei null | Unsicherheit Frage 2 |
| `run_log.txt` | Komplette Konsolenausgabe | Nachvollziehbarkeit |

Farben wie in Task 1: NVIDIA rot, Intel grün, Nasdaq blau.

---

## Abdeckung der Bewertungsrubrik

| Rubrik-Kriterium (High Distinction) | Umsetzung im Skript |
|---|---|
| „Beta is correctly estimated and CAPM is applied accurately for both stocks" | Abschnitt 2 und 3, Modulmethode `lm()` auf Überschussrenditen |
| „Discuss the empirical limitations of the CAPM … how much confidence" (Aufgabentext) | Abschnitt 4: Konfidenzintervalle und Robustheitstest |
| „The SML is used insightfully to assess over- and undervaluation" | SML-Grafik plus Alpha-Signifikanz aus der Regression |
| „The correlation … is computed and its implications for portfolio diversification are discussed with depth" | Abschnitt 5: Korrelation, Volatilität **und** Beta des Portfolios |
| „A well-justified forecasting method is applied, the forecast is plotted clearly, and its reliability is critically evaluated" | Abschnitt 6: Hold-out mit RMSE/MAPE, Prognose mit Intervallen, Trend-Vergleich |
| „NPV and IRR are correctly computed" | Abschnitt 7, `FinCal::npv()` / `irr()` |
| „Extending the analysis to reflect uncertainty … Findings are presented visually" | Abschnitt 8: Monte Carlo plus Histogramm |
| „Fully reproducible, logically structured, meaningful variable names" | Keine lokalen Dateien, `set.seed()`, sprechende Namen (`capm_table`, `sim_npv`, `intc_forecast`) |
| „Clear comments explain what each key step does and why" | Jeder Abschnitt mit Modulverweis und Begründung |
| „No unnecessary or redundant code is present" | 145 Codezeilen, jede Ausgabe wird im Video oder in der Summary verwendet |
