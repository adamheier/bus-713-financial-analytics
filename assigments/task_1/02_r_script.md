# Submission Component 2 — R Script

> **Abgabedatei:** [bus713_assessment1.R](bus713_assessment1.R) (725 Zeilen, läuft fehlerfrei
> durch, Laufzeit ca. 60 Sekunden). Dieses Dokument ist die Begleitdokumentation: Aufbau,
> Designentscheidungen und die Zuordnung zu den Anforderungen der Aufgabenstellung. Für das Video
> ist vor allem Abschnitt „Designentscheidungen" relevant — dort steht das *Warum*.

## Ausführen

```bash
Rscript bus713_assessment1.R
```

Oder in RStudio öffnen und `Source` (Strg+Shift+S). Das Skript legt den Ordner `output/` selbst an
und schreibt dort 13 Grafiken sowie `summary_table.csv`.

**Pakete:** `tidyquant`, `tidyverse`, `lubridate`, `forecast`, `patchwork` — die Installationszeile
steht auskommentiert in Zeile 34. `patchwork` wird nur in Abschnitt 2.1 gebraucht, um zwei ggplots
mit `+` zu einer Grafik zu verbinden; ohne `library(patchwork)` schlägt genau diese Stelle fehl.

**Datenquellen:** Yahoo Finance (Kurse) und FRED (US CPI, 3M-T-Bill). Beide werden zur Laufzeit
heruntergeladen, es sind keine lokalen Dateien nötig. Eine Internetverbindung ist Voraussetzung.

---

## Aufbau

| Abschnitt | Zeilen | Inhalt | Ergebnisobjekte |
|---|---|---|---|
| 0 | 31–88 | Setup: Pakete, Parameter, Farbzuordnung, zwei Hilfsfunktionen | `asset_colours`, `calc_cagr()`, `get_fred()` |
| 1 | 92–123 | Datenimport Kurse und CPI | `prices`, `cpi` |
| 2 | 127–192 | Kursverläufe, absolut und indexiert (Log-Skala) | Grafiken 01, 02 |
| 3 | 196–264 | Renditeberechnung monatlich und täglich | `monthly_returns`, `daily_returns`, Grafiken 03, 04 |
| 4 | 267–318 | Volatilität als Streuungsmaß | `risk_summary`, `daily_summary`, Grafik 05 |
| 5 | 322–417 | Volatilität im Zeitverlauf, Clustering | `monthly_vol`, `rolling_vol`, `acf_table`, Grafiken 06–08 |
| 6 | 420–531 | Downside Risk: VaR, ES, Drawdown | `var_es`, `var_recent`, `drawdown_summary`, Grafiken 09–11 |
| 7 | 535–631 | CAGR nominal, Inflation, reale CAGR | `cagr_table`, `cpi_cagr`, Grafiken 12, 13 |
| 8 | 635–685 | Risikoadjustierte Performance, Beta | `performance`, `market_sensitivity` |
| 9 | 689–725 | Zusammenfassende Ergebnistabelle | `summary_table`, `summary_report`, CSV |

Die Reihenfolge folgt bewusst dem Aufbau der Vorlesung: Modul 1 (Kurse, Renditen, CAGR) →
Modul 2 (Volatilität, Clustering, VaR/ES) → Modul 3 (reale Renditen, Sharpe/Sortino).

---

## Designentscheidungen

Das sind die Stellen, an denen im Video das „warum" erklärt werden sollte.

### 1. `adjusted` statt `close` (Zeile 95–102)

Die bereinigte Kursreihe berücksichtigt Splits und Dividenden und misst damit das, was ein Anleger
tatsächlich verdient hat. Bei NVIDIA ist das nicht optional: Der 10:1-Split im Juni 2024 würde in
der unbereinigten Reihe als −90-%-Tagesverlust erscheinen und sowohl Volatilität als auch VaR
verfälschen.

*Ausnahme:* In Abschnitt 7.6 wird `close` bewusst zusätzlich ausgewertet, um bei Intel den Beitrag
der Dividende zur Gesamtrendite sichtbar zu machen (4,97 % gesamt vs. 2,26 % reine Kursrendite).

### 2. Renditen statt Preise (Zeile 196–201)

Preise haben einen Trend — ihr Mittelwert verschiebt sich laufend, deshalb ist ihre
Standardabweichung keine sinnvolle Risikokennzahl. Renditen schwanken um einen weitgehend stabilen
Mittelwert; erst dadurch werden Standardabweichung, Quantile und Autokorrelation interpretierbar.

### 3. Zwei Renditefrequenzen (Zeile 203–231)

| | Frequenz | Typ | Verwendung | Begründung |
|---|---|---|---|---|
| `monthly_returns` | monatlich | log | Rendite-/Volatilitätsvergleich, Korrelation, Beta | Log-Renditen sind über die Zeit additiv und behandeln Gewinne und Verluste symmetrisch |
| `daily_returns` | täglich | arithmetisch | Clustering, VaR, ES | Tail-Risiko braucht viele Beobachtungen: 5.283 statt 252 pro Asset; arithmetische Renditen sind direkt als prozentualer Positionsverlust lesbar |

### 3a. Kursgrafik: gemeinsame Skala für die Aktien, eigene für den Index (Zeile 130–168)

NVDA und INTC werden in USD gemessen und teilen sich deshalb eine y-Achse von 0 bis 200 — nur so
ist der Größenunterschied der Kursniveaus direkt ablesbar. Der Nasdaq steht in Indexpunkten, eine
gemeinsame Achse wäre sinnlos; er wird als eigener Plot gezeichnet und mit `patchwork` (`p_stocks +
p_index`) daneben gesetzt.

Zwei Details, die dabei wichtig sind:

- **`coord_cartesian(ylim = ...)` statt `scale_y_continuous(limits = ...)`.** `limits` löscht alle
  Beobachtungen außerhalb des Bereichs aus den Daten; NVIDIA erreicht 207 USD, die Linie hätte
  am Hoch eine Lücke. `coord_cartesian()` zoomt nur die Ansicht, die Daten bleiben vollständig.
- **`asset_colours`** (Zeile 54–56) hält die Farbe je Asset fest. Ohne diese Zuordnung würde
  ggplot in einem Plot mit nur zwei Assets die ersten beiden Farben der Palette vergeben — NVIDIA
  bliebe rot, Intel würde aber grün statt der Farbe aus den anderen Grafiken.

### 4. Log-Skala im Kursvergleich (Zeile 170–192)

Auf linearer Skala drückt NVIDIAs Wachstum (Faktor 1.035) die beiden anderen Reihen zu einer
flachen Linie zusammen. Auf logarithmischer Skala entsprechen gleiche vertikale Abstände gleichen
prozentualen Veränderungen — dadurch sind die Steigungen direkt vergleichbar und man sieht, dass
Intel und Nasdaq bis 2015 praktisch deckungsgleich laufen.

### 5. Clustering: drei Nachweise statt einem (Abschnitt 5)

1. **Visuell** in den Tagesrenditen (Grafik 04): Turbulenz tritt in Blöcken auf.
2. **Gemessen** als realisierte Monatsvolatilität und 30-Tage-Rollvolatilität (Grafiken 06, 07).
3. **Statistisch** über die Autokorrelation der quadrierten Renditen (Grafik 08, `acf_table`).
   Quadrieren entfernt die Richtung und lässt nur die Größe der Bewegung übrig. Die Rohrenditen
   sind praktisch unkorreliert (Lag 1 ≈ −0,04 bis −0,10), die quadrierten bleiben über 50 Lags
   positiv — das ist der formale Beleg für Persistenz.

### 6. Historischer VaR statt Normalverteilungs-VaR (Zeile 425–443)

`quantile(daily.returns, 0.05)` nutzt die tatsächliche empirische Verteilung. Ein parametrischer
VaR würde Normalverteilung unterstellen; die gemessene Kurtosis von 10,7 bis 16,4 (gegenüber 3 bei
Normalverteilung) zeigt, dass diese Annahme hier falsch wäre und das Risiko systematisch
unterschätzen würde.

### 7. VaR zusätzlich auf dem kurzen Fenster (Zeile 483–495)

Bewusst eingebaute Gegenprobe: derselbe VaR nur auf 2024–2025 gerechnet. Ergebnis für Intel
−5,27 % statt −3,14 %. Damit wird die zentrale Schwäche des historischen VaR im Skript selbst
sichtbar gemacht, statt sie nur in den Limitationen zu erwähnen.

### 8. Fisher-Gleichung statt Subtraktion (Zeile 559–573)

`(1 + r_real) = (1 + r_nominal) / (1 + Inflation)`. Die einfache Differenz nominal − Inflation
überschätzt die reale Rendite, weil beide Größen sich verzinsen. Bei NVIDIA beträgt der Unterschied
0,9 Prozentpunkte pro Jahr — über 21 Jahre keine Rundungsfrage.

### 9. `get_fred()` mit Fallback (Zeile 70–88)

Die Kursvariante aus der Vorlesung, `tq_get(get = "economic.data")`, wird zuerst versucht. Der
FRED-Endpunkt lehnt Anfragen ohne API-Key inzwischen zeitweise ab, deshalb fällt die Funktion in
diesem Fall auf die öffentliche CSV-Datei von FRED zurück. Beide Wege liefern dieselbe Serie; der
Fallback stellt nur sicher, dass das Skript auf jedem Rechner reproduzierbar durchläuft.

### 10. Gruppierte Verarbeitung statt Copy-Paste (durchgehend)

Statt den Ablauf für jedes Asset zu kopieren (wie in den Modulbeispielen mit Apple/Microsoft), wird
über `group_by(asset)` gerechnet. Ein neues Asset erfordert damit genau eine geänderte Zeile
(`tickers`, Zeile 47–49), nicht drei Blöcke Duplikat. Das ist der Punkt „well structured and
reproducible" aus der Aufgabenstellung.

---

## Erzeugte Ausgaben

Elf Grafiken, lückenlos durchnummeriert in der Reihenfolge, in der das Skript sie erzeugt.

| Datei | Inhalt | Verwendet für |
|---|---|---|
| `01_prices_levels.png` | Bereinigte Kurse: NVDA und INTC auf gemeinsamer 0–200-USD-Skala, Nasdaq daneben mit eigener | Kontext |
| `02_prices_indexed_log.png` | Wachstum von 100 USD, Log-Skala | **Kernaussage 1** |
| `03_monthly_returns.png` | Monatliche Log-Renditen | Renditeverlauf |
| `04_daily_returns.png` | Tagesrenditen, Clustering sichtbar | Clustering visuell |
| `05_return_vs_volatility.png` | Rendite gegen Volatilität, annualisiert | **Kernaussage 2** |
| `06_monthly_realised_volatility.png` | Realisierte Volatilität je Monat | Volatilität über die Zeit, ruhige und turbulente Phasen |
| `07_acf_squared_returns.png` | ACF der quadrierten Renditen, 50 Lags | Clustering statistisch |
| `08_var_histograms.png` | Renditeverteilung mit VaR- und ES-Linie | VaR erklären |
| `09_var_es_comparison.png` | VaR und ES im Direktvergleich | Downside Risk |
| `10_cagr_nominal_vs_real.png` | CAGR nominal vs. real, mit Inflationslinie | **Kernaussage 3** |
| `11_value_of_investment.png` | Endwert von 10.000 USD, nominal vs. real | Inflation in Geld |
| `run_log.txt` | Vollständige Konsolenausgabe des Laufs | Nachvollziehbarkeit |

Nicht mehr enthalten: die 30-Tage-Rollvolatilität und der Drawdown-Chart wurden aus dem Skript
entfernt. `summary_table.csv` wird nur geschrieben, wenn die `write.csv()`-Zeile in Abschnitt 9
wieder aktiviert wird.

---

## Abdeckung der Aufgabenstellung

| Anforderung aus der Assessment-Beschreibung | Umsetzung |
|---|---|
| „returns for the selected stocks and the Nasdaq index … computed at an appropriate frequency and visualised over time" | Abschnitt 3: monatlich und täglich, Grafiken 03 und 04 |
| „graphs of prices and returns … briefly discussed" | Abschnitt 2 und 3, Diskussion in [00_analyse_ergebnisse.md](00_analyse_ergebnisse.md) §3 |
| „volatility should be computed and compared across assets" | Abschnitt 4, `risk_summary`, Grafik 05 |
| „the behaviour of volatility over time should be considered" | Abschnitt 5.1 und 5.2, Grafiken 06 und 07 |
| „periods of calm and turbulence … identified and interpreted" | `slice_max`/`slice_min` auf `monthly_vol` (Zeile 349–350), Regime-Tabelle in der Analyse |
| „evidence of volatility clustering" | Abschnitt 5.3 und 5.4, ACF-Grafik und `acf_table` |
| „VaR and ES computed using the return series" | Abschnitt 6.1, 95 % und 99 %, zusätzlich in USD |
| „interpreted clearly … potential losses and extreme outcomes" | Abschnitt 6.2–6.5, inkl. Fensterkontrolle und Max Drawdown |
| „CAGR for each stock and the Nasdaq" | Abschnitt 7.1, `calc_cagr()` nach Methode aus Modul 1.5 |
| „nominal and real terms, with inflation-adjusted CAGR calculated using US CPI data" | Abschnitt 7.2 und 7.3, FRED `CPIAUCSL`, Fisher-Gleichung |
| „impact of inflation on long-term investment performance … clearly discussed" | Abschnitt 7.4–7.6, Grafiken 12 und 13, Dividendenanalyse bei Intel |
| „clear evaluation … return, risk, and inflation … what these results imply for investment decisions" | Abschnitt 8 und 9, Empfehlung im Video und in der Executive Summary |
| „well structured and reproducible, comments explain the key steps" | Nummerierte Abschnitte, zentrale Parameter, keine manuellen Dateipfade, Kommentare erklären Zweck statt Syntax |

---

## Bekannte Punkte, die im Video erwähnt werden sollten

- **Fehlender CPI-Wert Oktober 2025.** Die BLS-Veröffentlichung entfiel wegen des
  US-Regierungsstillstands; die Serie hat an dieser Stelle ein `NA`, das in Zeile 120–121 explizit
  gefiltert wird. Auf die CAGR-Berechnung hat das keinen Einfluss, weil dafür nur der erste und der
  letzte Wert verwendet werden.
- **Der Nasdaq Composite ist ein Kursindex** und enthält keine Dividenden, die Aktienreihen sind
  dagegen dividendenbereinigt. Der Vergleich fällt dadurch minimal zugunsten der Einzeltitel aus —
  bei Intel um rund 2,7 Prozentpunkte pro Jahr. Der ehrliche Kurs-gegen-Kurs-Vergleich steht in
  Abschnitt 7.6.
- **`tq_get()` liefert `to` exklusiv.** Deshalb wird ein Tag mehr angefragt und anschließend
  gefiltert (Zeile 99–102), damit der 31.12.2025 tatsächlich enthalten ist.
- **Die beiden FRED-Meldungen im Log sind kein Fehler.** `get_fred()` versucht zuerst den
  Vorlesungsweg über `tq_get()`; schlägt er fehl, greift der CSV-Fallback. Die Warnung im Log
  dokumentiert genau diesen Übergang.
