# Code-Walkthrough für die Präsentation

> **Format:** Chronologisch durch das Skript, Codeblock ausführen → Output erscheint → erklären.
> Part A (Code) und Part B (Interpretation) verschmelzen dabei. Für jeden Block steht hier: was der
> Code tut, was im Output steht, was du sagen solltest — und was du weglassen kannst.
>
> **Priorität:** 🔴 muss gesagt werden · 🟡 kurz erwähnen · ⚪ nur laufen lassen, nichts sagen
>
> Alle Zahlen sind aus dem letzten vollständigen Lauf verifiziert. Sprechvorschläge auf Englisch.

---

## ⚠️ Vor der Aufnahme: zwei Blocker

### 1. Der CPI-Download ist aktuell kaputt

`get_fred()` ruft nur noch `tq_get(get = "economic.data")` auf. Dieser Endpunkt lehnt Anfragen ohne
API-Key ab — getestet, er schlägt zuverlässig fehl. Ergebnis: `cpi` ist `NA` statt einer Tabelle,
und **Abschnitt 7.2 bis 7.5 sowie Abschnitt 8 brechen ab**. Das wäre live auf Kamera das
Worst-Case-Szenario.

Fix — `get_fred()` durch diese Version ersetzen:

```r
# Helper 2: FRED download.
# tq_get(get = "economic.data") is the method from the course, but FRED refuses
# that request without an API key, so the public CSV file is used as a fallback.
get_fred <- function(series_id, from, to) {
  out <- try(tq_get(series_id, get = "economic.data", from = from, to = to), silent = TRUE)
  if (is.data.frame(out) && nrow(out) > 0) return(out)

  tmp <- tempfile(fileext = ".csv")
  download.file(paste0("https://fred.stlouisfed.org/graph/fredgraph.csv?id=", series_id),
                tmp, method = "curl", quiet = TRUE, extra = "-s --max-time 60")
  read_csv(tmp, show_col_types = FALSE) %>%
    set_names(c("date", "price")) %>%
    mutate(symbol = series_id, date = as.Date(date)) %>%
    filter(date >= as.Date(from), date <= as.Date(to)) %>%
    select(symbol, date, price)
}
```

Das ist sogar ein **Pluspunkt im Video**: „The course method needs an API key, so I built a fallback
that reads the public CSV — the script runs on any machine." Zeigt, dass du die Datenquelle
verstanden hast.

### 2. Vor der Aufnahme einmal komplett durchlaufen lassen

`Session → Restart R`, dann das ganze Skript sourcen. Gründe: Yahoo kann kurz zicken, und du willst
wissen, wie lange jeder Block braucht (der Kursdownload dauert ~10 Sekunden — das ist im Video eine
lange Stille). **Tipp:** Beim Aufnehmen den Import-Block vorher schon laufen lassen und im Video nur
`prices` aufrufen, dann erscheint die Tabelle sofort.

---

## Was sich seit der letzten Fassung geändert hat

|                                 |                                                                                                                                                                                                                                                            |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Rollvolatilität entfernt | Abschnitt 5 hat jetzt nur noch die Monatsvolatilität (`06`). Deckt dieselbe Anforderung ab; das Videoskript verweist in Part B3 inzwischen ebenfalls auf `06` |
| Drawdown (`11`) entfernt        | Wie besprochen, nicht gefordert ✓                                                                                                                                                                                                                          |
| `write_csv()` entfernt          | `summary_table.csv` wird nicht mehr geschrieben. Fürs Video egal (du zeigst die Konsole), aber die Datei fehlt dann im `output`-Ordner                                                                                                                     |
| Beta/Korrelation entfernt       | Unkritisch, war Zusatz                                                                                                                                                                                                                                     |
| Dateinummern durchgezogen       | Die Lücken bei 07 und 11 sind geschlossen, die elf Grafiken heißen jetzt `01` bis `11`                                                                                                                                                                     |

---

## Zeitplan (Zielwert 9:00)

| Zeit | Block | Was auf dem Schirm ist |
|---|---|---|
| 0:00–0:30 | Intro + Student ID + Fragestellung | Kamera |
| 0:30–0:50 | Abschnitt 0 Setup | Code |
| 0:50–1:20 | Abschnitt 1.1 Import + Datencheck | `prices`, Check-Tabelle |
| 1:20–1:35 | Abschnitt 1.2 CPI | `cpi` |
| 1:35–1:55 | Abschnitt 2.1 Kursverläufe | Plot 01 |
| 1:55–2:40 | **Abschnitt 2.2 Indexiert, Log-Skala** 🔴 | Plot 02 |
| 2:40–3:00 | Abschnitt 3.1 + 3.2 Renditen | zwei Tabellen |
| 3:00–3:20 | Abschnitt 3.3 + 3.4 Renditeplots | Plot 03, 04 |
| 3:20–4:00 | **Abschnitt 4 Volatilität** 🔴 | `risk_summary`, Plot 05 |
| 4:00–4:20 | Abschnitt 5.1 Monatsvolatilität | Plot 06, Top-5-Tabelle |
| 4:20–4:50 | **Abschnitt 5.2 + 5.3 Clustering** 🔴 | Plot 07, `acf_table` |
| 4:50–5:30 | **Abschnitt 6.1 + 6.2 VaR / ES** 🔴 | `var_es`, Plot 08 |
| 5:30–5:45 | Abschnitt 6.3 VaR/ES-Balken | Plot 09 |
| 5:45–6:05 | **Abschnitt 6.4 VaR aktuell** 🔴 | `var_recent` |
| 6:05–6:25 | Abschnitt 7.1 + 7.2 CAGR und Inflation | `cagr_table`, `cpi_cagr` |
| 6:25–7:10 | **Abschnitt 7.3 + 7.4 Reale CAGR** 🔴 | Plot 10 |
| 7:10–7:25 | Abschnitt 7.5 Wert von 10.000 USD | Plot 11 |
| 7:25–7:45 | Abschnitt 8 Sharpe | `performance` |
| 7:45–8:15 | Abschnitt 9 Ergebnistabelle | `summary_report` |
| 8:15–9:00 | **Empfehlung, Limitationen, Schluss** 🔴 | Kamera |

---

## ⚠️ Ein Risiko dieses Formats

Die Aufgabenstellung nennt ausdrücklich **zwei Teile**: „Part A: Code and Approach" und „Part B:
Insights and Interpretation". Wenn du chronologisch durchgehst, ist Part B über das ganze Video
verteilt — ein Marker mit Häkchenliste könnte ihn als „fehlt" werten.

**Absicherung:** Der letzte Block (8:15–9:00) muss ein klar abgegrenzter Interpretationsteil sein.
Kündige ihn an: *„That was the code. Let me now put the three findings together and say what they
mean for an investor."* Dann ist Part B unübersehbar vorhanden, obwohl du unterwegs schon
interpretiert hast.

---

# Block für Block

## Abschnitt 0 — Setup und Parameter *(Zeile 19–59, ~20 s)*

**Priorität:** 🟡

**Was der Code macht:** Lädt fünf Pakete, definiert Zeitraum, Ticker, Farben und zwei
Hilfsfunktionen. `calc_cagr()` kapselt die CAGR-Formel, `get_fred()` den Inflationsdownload.

**Mehrwert:** Alles Steuerbare steht an einer Stelle. Ein anderes Aktienpaar heißt: eine Zeile
ändern (`tickers`), Skript neu laufen lassen.

**Was du sagst:**
> "All parameters sit at the top — the period, the three tickers, and two helper functions. If a
> client asked me to run this for two different stocks, I would change one line and re-run.

**Weglassen:** Die Farbzuordnung (`asset_colours`) und `position_value` musst du nicht erklären.
Nicht die Pakete einzeln vorlesen — „tidyquant for the data, ggplot for the charts" reicht.

---

## Abschnitt 1.1 — Kursimport und Datencheck *(Zeile 66–86, ~30 s)*

**Priorität:** 🔴 (die `adjusted`-Begründung ist Pflicht)

**Was der Code macht:** Lädt drei Kursreihen in einem Aufruf und hängt ein Klartext-Label an. Danach
eine Kontrollabfrage: Zeilenzahl, erstes und letztes Datum, erster und letzter Kurs je Asset.

**Was im Output steht:**

| | Handelstage | erster Kurs | letzter Kurs |
|---|---:|---:|---:|
| NVIDIA | 5.283 | $0,18 | $186,29 |
| Intel | 5.283 | $13,34 | $36,90 |
| Nasdaq | 5.283 | 2.152 | 23.242 |

**Was du sagst:**
> "I use the *adjusted* closing price, which corrects for dividends and stock splits. That is not
> optional here: NVIDIA did a ten-for-one split in 2024, and on unadjusted prices the analysis would
> read that as a ninety-percent crash in a single day.
>
> The second block is a data check — same number of trading days, same start and end date for all
> three. If the samples didn't line up, every comparison after this point would be quietly wrong."

**Mehrwert:** Der Datencheck ist billig und zeigt Sorgfalt. Nebenbei: Die erste und letzte Spalte
enthalten schon die ganze Geschichte — 18 Cent auf 186 Dollar gegen 13 auf 37.

**Weglassen:** Die `to = "2026-01-01"`-Feinheit (Yahoo schließt das Enddatum aus). Interessiert
niemanden im Publikum.

---

## Abschnitt 1.2 — CPI von FRED *(Zeile 88–94, ~15 s)*

**Priorität:** 🟡

**Was der Code macht:** Holt den US-Verbraucherpreisindex (Serie `CPIAUCSL`) als Monatsreihe und
entfernt fehlende Werte.

**Was im Output steht:** 251 Monatswerte, Januar 2005 = 191,6 bis Dezember 2025 = 326,0.

**Was du sagst:**
> "This is the inflation data — the US Consumer Price Index, straight from the Federal Reserve
> database. I need it later to convert nominal returns into real ones."

**Der eine erwähnenswerte Punkt (🟡):** Oktober 2025 fehlt in der Quelle, weil der
US-Regierungsstillstand die Veröffentlichung verzögert hat — deshalb der `filter(!is.na(price))`.
Ein Satz genügt: *"One month is missing because the government shutdown delayed the release, so I
filter it out."* Das ist ein authentisches Datenproblem und wirkt gut.

**Weglassen:** Was ein API-Key ist. Nur erwähnen, falls du den Fallback eingebaut hast (siehe oben).

---

## Abschnitt 2.1 — Kursverläufe absolut *(Zeile 101–133, ~20 s → Plot 01)*

**Priorität:** 🟡

**Was der Code macht:** Zwei getrennte Plots, mit `patchwork` nebeneinandergesetzt. Die beiden
Aktien teilen sich eine USD-Skala von 0 bis 200, der Index behält seine Indexpunkte.

**Was der Plot zeigt:** NVIDIA liegt bis etwa 2016 optisch auf der Nulllinie und explodiert danach.
Intel bewegt sich die ganzen 21 Jahre zwischen 13 und 62 Dollar.

**Was du sagst:**
> "First look at the raw prices. The two stocks share one dollar scale, so you can see how far apart
> they are — but the index has to keep its own, because index points and dollars aren't the same
> unit. And this is exactly the problem with price charts: NVIDIA's growth is so large that Intel
> looks like a flat line, which it isn't."

**Mehrwert:** Der Plot ist die *Begründung* für den nächsten. Genau so verkaufen: „das ist das
Problem" → nächster Block ist die Lösung.

**Weglassen:** `coord_cartesian` statt `limits`, `patchwork`-Syntax. Das ist Handwerk, kein Befund.

---

## Abschnitt 2.2 — Indexiert auf 100, Log-Skala *(Zeile 136–156, ~45 s → Plot 02)* 🔴

**Priorität:** 🔴 **Kernaussage 1 — der wichtigste Plot der ganzen Arbeit**

**Was der Code macht:** Setzt jede Reihe auf 100 zum Startdatum (`100 * adjusted / first(adjusted)`)
und zeichnet auf logarithmischer y-Achse.

**Warum Log-Skala:** Auf linearer Skala ist ein Faktor 1.035 gegen Faktor 2,8 nicht darstellbar. Auf
Log-Skala bedeutet gleiche Steigung gleiches prozentuales Wachstum — erst dadurch werden die drei
Linien vergleichbar.

**Was du sagst:**
> "Now the same data, but every series starts at a hundred and the axis is logarithmic. On a log
> scale, equal slopes mean equal percentage growth, so the three lines are finally comparable.
>
> Three very different outcomes: ten thousand dollars became **ten point four million** in NVIDIA,
> **a hundred and eight thousand** in the Nasdaq, and **twenty-seven thousand six hundred** in Intel.
>
> But look at the first ten years. Until 2015, Intel and the Nasdaq run almost on top of each other,
> and NVIDIA is not the star — it just swings more. Almost all of its advantage was earned after
> 2016, with the AI cycle. In 2005, nobody could have told you which of the two chip makers would be
> which."

**Mehrwert:** Der zweite Absatz ist der Punkt, an dem du vom Beschreiben ins Analysieren wechselst.
Genau dafür gibt es in „Insights and Interpretation" Punkte. Unbedingt drin lassen.

---

## Abschnitt 3.1 + 3.2 — Renditen berechnen *(Zeile 164–188, ~20 s)* 🔴

**Priorität:** 🔴 (methodische Begründung ist Pflicht)

**Was der Code macht:** Zwei Renditereihen aus denselben Kursen — monatliche Log-Renditen
(252 Werte) und tägliche arithmetische Renditen (5.283 Werte).

**Was du sagst:**
> "From here on I work on returns, not prices. Prices trend — their average keeps moving, so a
> standard deviation of prices doesn't mean anything. Returns fluctuate around a stable average.
>
> I compute two frequencies on purpose. Monthly log returns for the return and volatility
> comparison, because log returns add up over time. Daily returns for the risk measures, because
> tail risk needs a lot of observations — five thousand three hundred instead of two hundred fifty."

**Mehrwert:** Das ist die Stelle, an der du zeigst, dass du verstanden hast *warum* Finanzanalyse
auf Renditen läuft. Steht so auch in Workshop 2, Aufgabe 1–3.

**Weglassen:** Der Unterschied log vs. arithmetisch im Detail. Ein Halbsatz reicht.

---

## Abschnitt 3.3 + 3.4 — Renditeplots *(Zeile 190–219, ~20 s → Plot 03, 04)*

**Priorität:** 🟡 (Plot 04) · ⚪ (Plot 03)

**Was die Plots zeigen:** Plot 03 monatlich, Plot 04 täglich. Beide zeigen dasselbe Muster, Plot 04
deutlicher: Ausschläge kommen in **Blöcken**, nicht gleichmäßig verteilt.

**Was du sagst (nur zu Plot 04):**
> "Here are the daily returns. Two things are visible before I compute anything. NVIDIA's band is
> simply wider than Intel's, and Intel's is wider than the index. And the big moves cluster —
> 2008, 2020, 2022, and Intel again in 2024. That observation is what section five turns into a
> measurement."

**Weglassen:** Plot 03 kommentarlos durchlaufen lassen. Er zeigt nichts, was Plot 04 nicht besser
zeigt. Einzelne Ausreißer nicht aufzählen — die Blockstruktur ist der Punkt, nicht der Einzeltag.

---

## Abschnitt 4 — Volatilität *(Zeile 226–259, ~40 s → `risk_summary`, Plot 05)* 🔴

**Priorität:** 🔴 **Kernaussage 2**

**Was der Code macht:** Mittelwert und Standardabweichung der Monatsrenditen je Asset, annualisiert
mit ×12 bzw. ×√12. Dazu Extremmonate und Anteil positiver Monate.

**Was im Output steht:**

| | Rendite p.a. | Volatilität p.a. | schlechtester Monat | positive Monate |
|---|---:|---:|---:|---:|
| NVIDIA | 33,1 % | 46,3 % | −49,2 % | 63,5 % |
| Intel | 4,8 % | 30,6 % | −37,1 % | 56,7 % |
| Nasdaq | 11,3 % | 17,8 % | −19,5 % | 61,5 % |

**Was du sagst:**
> "Volatility is just the standard deviation of returns, annualised. Both stocks are far riskier
> than the index: forty-six percent for NVIDIA, thirty-one for Intel, against eighteen for the
> Nasdaq.
>
> The bar chart is the one that answers our client's question. For NVIDIA the extra risk was paid
> for — two and a half times the index volatility, almost three times the return. For Intel it was
> not: nearly twice the index risk, for **less than half** the index return. Same sector, same
> twenty-one years."

**Mehrwert:** Das ist die eigentliche Antwort auf „ist Stock-Picking besser als der Index". Nicht
„beide sind riskanter", sondern „nur bei einem hat sich das Risiko ausgezahlt".

**Weglassen:** `share_positive` und die Extremmonate. Nette Zahlen, aber sie tragen kein Argument —
außer du hast am Ende Zeit übrig.

---

## Abschnitt 5.1 — Monatsvolatilität *(Zeile 266–289, ~20 s → Plot 06)*

**Priorität:** 🟡

**Was der Code macht:** Gruppiert die Tagesrenditen nach Monat und berechnet je Monat eine
Standardabweichung — realisierte Volatilität. Danach die fünf turbulentesten und drei ruhigsten
Monate.

**Was im Output steht:** März 2020 ist bei **allen drei** Assets der volatilste Monat (NVDA 8,1 %,
INTC 8,4 %, NDX 5,7 % Tagesvolatilität). Ruhigste Phasen: 2013/2014 und 2017.

**Was du sagst:**
> "Volatility is not one number, it moves. This is the standard deviation of daily returns inside
> each month. Two things: the spikes come in groups rather than isolated, and March 2020 is the most
> volatile month for all three assets at once. That matters — when you actually need
> diversification, the crises arrive together."

**Mehrwert:** Erledigt zwei Anforderungen der Aufgabenstellung in einem Bild („behaviour of
volatility over time" und „periods of calm and turbulence").

**Weglassen:** Die Top-5-Tabelle vorlesen. Einmal „March 2020" nennen reicht.

---

## Abschnitt 5.2 + 5.3 — Clustering und ACF *(Zeile 291–325, ~30 s → Plot 07, `acf_table`)* 🔴

**Priorität:** 🔴 (wörtliche Anforderung: „evidence of volatility clustering")

**Was der Code macht:** Quadriert die Tagesrenditen — das entfernt die Richtung und lässt nur die
Größe der Bewegung übrig. Dann Autokorrelation dieser quadrierten Renditen über 50 Lags, einmal als
Grafik, einmal als Zahlentabelle.

**Was im Output steht:**

| | quadriert Lag 1 | Lag 20 | Lag 50 | **Rohrendite Lag 1** |
|---|---:|---:|---:|---:|
| NVIDIA | 0,085 | 0,063 | 0,032 | −0,043 |
| Intel | 0,208 | 0,101 | 0,035 | −0,078 |
| Nasdaq | 0,306 | 0,140 | 0,040 | −0,099 |

**Was du sagst:**
> "This is the formal test. I square each return, which removes the direction and keeps only the
> size of the move, and then check whether today's size predicts tomorrow's. If turbulence were
> random, the bars would drop to zero after one or two lags. They stay above the significance line
> for more than fifty trading days — roughly ten weeks.
>
> And the contrast in the last column is the whole point: the returns themselves are essentially
> uncorrelated. **You cannot predict whether tomorrow goes up or down. You can predict that it stays
> turbulent if today was turbulent.** That distinction is what risk management is built on."
> 
> "This chart tests whether volatility is predictable. We square the daily returns to isolate the size of a move from its direction, then check how strongly today's magnitude correlates with magnitude many days later. Across all three assets, the bars stay clearly above the blue significance line for 30-plus days — meaning a turbulent day is followed by more turbulent days, not random noise. That's the statistical proof behind volatility clustering."

**Mehrwert:** Der fettgedruckte Satz ist die beste „what does it mean" Formulierung im ganzen Video.
Für ein Management-Publikum ist das die verständlichste Übersetzung von Volatilitätsclustering.

**Weglassen:** Was Autokorrelation mathematisch ist. Die blaue Signifikanzlinie erklären reicht.

---

## Abschnitt 6.1 + 6.2 — VaR und Expected Shortfall *(Zeile 331–369, ~40 s → `var_es`, Plot 08)* 🔴

**Priorität:** 🔴 (wörtliche Anforderung, „interpreted clearly")

**Was der Code macht:** VaR = 5 %-Quantil der Tagesrenditen. ES = Mittelwert aller Tage unterhalb
dieser Schwelle. Beides zusätzlich auf 99 % und umgerechnet auf eine 1-Mio.-USD-Position.

**Was im Output steht:**

| | VaR 95 % | ES 95 % | ES in USD auf 1 Mio. |
|---|---:|---:|---:|
| NVIDIA | −4,47 % | −6,71 % | 67.107 |
| Intel | −3,14 % | −5,01 % | 50.135 |
| Nasdaq | −2,18 % | −3,29 % | 32.891 |

**Was du sagst:**
> "Volatility treats a gain and a loss the same way. Management usually only cares about the loss,
> so this is downside risk.
>
> Value at Risk is one line of code — the fifth percentile of the daily returns. In plain language:
> **on one trading day in twenty, a one-million-dollar position in NVIDIA loses more than
> forty-four thousand dollars.** But that only tells you where the bad zone starts. Expected
> Shortfall is the average of everything beyond it — and if that day happens, the average loss is
> sixty-seven thousand.
>
> On the histogram: the solid red line is the cutoff, the dashed line the average loss beyond it.
> The distance between the two lines is the part that Value at Risk alone hides."

**Mehrwert:** Der Dollar-Satz ist der Moment, in dem ein Nicht-Techniker versteht, worum es geht.
Unbedingt in Dollar sprechen, nicht in Prozent.

**Weglassen:** Die 99 %-Zahlen. Sie sagen dasselbe eine Stufe extremer — nur nennen, wenn Zeit ist.

---

## Abschnitt 6.3 — VaR/ES-Balken *(Zeile 371–387, ~15 s → Plot 10)*

**Priorität:** ⚪ bis 🟡

**Was der Plot zeigt:** Dieselben sechs Zahlen als Balken. ES ist bei jedem Asset deutlich negativer
als VaR.

**Was du sagst (falls überhaupt):**
> "Side by side, and you can see the pattern holds for all three: Expected Shortfall is always the
> more negative number — that follows directly from how it's defined."

**Mehrwert:** Gering, du hast die Zahlen gerade genannt. Kommentarlos durchlaufen lassen ist völlig
in Ordnung — der Plot liegt ja im Abgabeordner.

---

## Abschnitt 6.4 — VaR auf zwei Jahren *(Zeile 389–400, ~20 s → `var_recent`)* 🔴

**Priorität:** 🔴 — **nicht rauslassen** (dein Kommentar „vllt rauslassen?" im Code)

**Was der Code macht:** Derselbe VaR, aber nur auf 2024–2025 gerechnet.

**Was im Output steht:**

| | VaR volle Historie | VaR 2024–2025 |
|---|---:|---:|
| NVIDIA | −4,47 % | −4,69 % |
| **Intel** | **−3,14 %** | **−5,27 %** |
| Nasdaq | −2,18 % | −2,20 % |

**Was du sagst:**
> "One more check, and it changes the recommendation. If I compute the same measure on the last two
> years only, Intel's Value at Risk is minus five point three percent — **worse than NVIDIA's**, and
> two thirds worse than its own long-run number.
>
> That's the clustering result showing up in practice: risk is a regime, not a constant. A risk
> limit built on a twenty-one-year average would be far too small for the Intel position we hold
> today."

**Mehrwert:** Das ist die stärkste eigenständige Erkenntnis im ganzen Risikoteil und der einzige
Block, der zwei Kapitel verbindet (Clustering → VaR). Er zeigt außerdem, dass du die Grenzen deiner
eigenen Methode kennst — genau das, wonach „limitations" fragt. Kostet 20 Sekunden.

---

## Abschnitt 7.1 + 7.2 — CAGR und Inflation *(Zeile 406–425, ~20 s)*

**Priorität:** 🟡

**Was der Code macht:** CAGR je Asset aus Anfangs- und Endkurs, dann dieselbe Formel auf den CPI
angewendet — Inflation ist nichts anderes als die Wachstumsrate des Preisindex.

**Was im Output steht:** NVIDIA 39,20 %, Nasdaq 12,00 %, Intel 4,97 % nominal. Inflation 2,574 %
p.a., kumuliert +70,2 % über den Zeitraum.

**Was du sagst:**
> "The compound annual growth rate turns twenty-one years into one annual number: thirty-nine
> percent for NVIDIA, twelve for the index, five for Intel.
>
> Then the same formula on the Consumer Price Index — inflation is just the growth rate of a price
> index. Two point five seven percent a year, which doesn't sound like much. Over the full period
> it's **seventy percent**."

**Mehrwert:** Dass du dieselbe Funktion auf Kurse und auf den CPI anwendest, ist ein guter
Nebensatz — es zeigt, dass CAGR ein allgemeines Konzept ist und kein Aktien-Trick.

---

## Abschnitt 7.3 + 7.4 — Reale CAGR *(Zeile 427–463, ~45 s → Plot 10)* 🔴

**Priorität:** 🔴 **Kernaussage 3**

**Was der Code macht:** Fisher-Gleichung `(1 + real) = (1 + nominal) / (1 + Inflation)`, dazu der
Endwert von 10.000 USD nominal und in Kaufkraft von 2005.

**Was im Output steht:**

| | nominal | real | 10.000 USD real |
|---|---:|---:|---:|
| NVIDIA | 39,20 % | 35,70 % | 6.083.619 |
| Nasdaq | 12,00 % | 9,19 % | 63.465 |
| Intel | 4,97 % | 2,33 % | 16.262 |

**Was du sagst:**
> "I use the Fisher equation rather than simply subtracting inflation, because both rates compound —
> over twenty-one years that difference is not a rounding error.
>
> In real terms: NVIDIA thirty-six percent a year, the Nasdaq nine point two, Intel two point three.
> The red line is inflation, and look how close Intel's real bar sits to it.
>
> Here is what that means for a client. Ten thousand dollars in the Nasdaq became a hundred and
> eight thousand — but in 2005 purchasing power, only **sixty-three thousand**. Inflation quietly
> took forty-one percent of every nominal number I have shown you today."

**Mehrwert:** Der Satz „inflation took forty-one percent" ist die Zahl, die im Kopf bleibt. Die
Aufgabenstellung verlangt ausdrücklich „the impact of inflation on long-term investment performance
should be clearly discussed" — das ist die Stelle, an der du das erledigst.

**Optionaler Zusatz, wenn du 15 Sekunden hast** (starke Pointe, Zahlen stimmen):
> "And Intel's five percent include reinvested dividends. The share price alone grew at two point
> three percent a year, while inflation ran at two point six — so an investor who spent the
> dividends actually lost purchasing power over twenty-one years, even though the share price rose."

---

## Abschnitt 7.5 — Wert von 10.000 USD *(Zeile 465–480, ~15 s → Plot 11)*

**Priorität:** ⚪ bis 🟡

**Was der Plot zeigt:** Dieselbe Aussage in Dollar statt in Prozent, auf Log-Skala.

**Was du sagst:** Nichts Neues — du hast die Zahlen im vorherigen Block schon genannt. Entweder
kommentarlos durchlaufen lassen oder einen Satz:
> "The same message in money rather than in percent."

**Weglassen:** Ja, wenn die Zeit knapp wird. Redundant zu Plot 10.

---

## Abschnitt 8 — Sharpe und Sortino *(Zeile 484–514, ~20 s → `performance`)*

**Priorität:** 🟡 (Sharpe) · ⚪ (Sortino)

**Was der Code macht:** Überschussrendite über den risikofreien Zins (1,71 %, Ø 3-Monats-T-Bill),
geteilt durch die Volatilität. Sortino dasselbe, aber nur mit Abwärtsabweichung.

**Was im Output steht:** Sharpe 0,90 (NVDA) / 0,63 (Nasdaq) / 0,26 (Intel).

**Was du sagst:**
> "One number that combines return and risk: the Sharpe ratio — excess return per unit of
> volatility. Zero point nine for NVIDIA, zero point six three for the index, zero point two six for
> Intel. So the index beat Intel on a risk-adjusted basis by a factor of more than two.
>
> I also computed the Sortino ratio, which only penalises downside volatility. The ranking doesn't
> change."

**Mehrwert:** Sharpe macht aus „mehr Rendite, mehr Risiko" eine echte Bewertung. Sortino ist ein
Nebensatz — nicht erklären, nur erwähnen, dass die Rangfolge stabil bleibt.

**Weglassen:** Herleitung von Downside Deviation und MAR. Kostet 30 Sekunden für null neue Aussage.

---

## Abschnitt 9 — Ergebnistabelle *(Zeile 517–546, ~30 s → `summary_report`)* 🔴

**Priorität:** 🔴 (dein Schlussbild)

**Was der Code macht:** Fügt alle Kennzahlen per `left_join` zu einer Tabelle zusammen und rundet
sie auf präsentationsfähige Werte.

**Was im Output steht:**

| Asset | Rend. p.a. | Vola | VaR 95 % | ES 95 % | CAGR nom. | CAGR real | 10k real | Sharpe |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| NVIDIA | 33,1 | 46,3 | −4,47 | −6,71 | 39,20 | 35,70 | 6.083.619 | 0,90 |
| Intel | 4,8 | 30,6 | −3,14 | −5,01 | 4,97 | 2,33 | 16.262 | 0,26 |
| Nasdaq | 11,3 | 17,8 | −2,18 | −3,29 | 12,00 | 9,19 | 63.465 | 0,63 |

**Was du sagst:**
> "Everything in one table — return, risk, tail risk, inflation-adjusted growth, and the
> risk-adjusted ratio. This is the one output I would actually put in front of a client. Read the
> Intel row across: more than one and a half times the index risk, and less than half the index
> return, in real terms two point three percent against nine point two."

**Mehrwert:** Die Tabelle ist dein Übergang von Code zu Empfehlung. Ideal, um hier die Kamera wieder
groß zu machen.

**Tipp:** `write.csv(summary_report, "output/summary_table.csv", row.names = FALSE)` wieder
einbauen, damit die Tabelle auch als Datei im Abgabeordner liegt.

---

## Schlussblock — Empfehlung und Limitationen *(~45 s, Kamera)* 🔴

**Priorität:** 🔴 — hier sichert du Part B formal ab

**Ankündigen, dass jetzt die Interpretation kommt:**

> "That was the code. Let me put the findings together and say what they mean for an investor.
>
> First: the sector was right, the stock decided. Two chip makers, the same twenty-one years, and a
> factor of three hundred and seventy between them in the final value. Sector exposure guarantees
> nothing.
>
> Second: both stocks carried far more risk than the index, but only one of them paid for it. And in
> 2005 nobody could have known which one.
>
> Third: inflation removed forty-one percent of every nominal figure, and for Intel it is the
> difference between a decent-sounding five percent and a real two point three.
>
> So my recommendation: the index stays the core of the portfolio — nine point two percent real, at
> eighteen percent volatility, with none of the single-company risk. Individual stocks belong in a
> satellite position, sized so that a very deep loss is survivable.
>
> Two limitations. I picked NVIDIA knowing how the story ended, so this is not evidence that
> stock-picking works — it's evidence of what it costs when it doesn't. And historical Value at Risk
> assumes the past repeats, which is exactly why I re-estimated it on recent data.
>
> The headline: nominal returns flatter, and the only comparison that means anything is a real,
> risk-adjusted one. Thank you."

---

## Wenn du über 9:30 landest — in dieser Reihenfolge kürzen

1. Abschnitt 7.5 (Plot 11) kommentarlos durchlaufen lassen — spart 15 s
2. Abschnitt 6.3 (Plot 09) kommentarlos durchlaufen lassen — spart 15 s
3. Abschnitt 3.3 (Plot 03) nicht erwähnen — spart 10 s
4. In Abschnitt 8 nur Sharpe nennen, Sortino weglassen — spart 10 s
5. In Abschnitt 1.1 den Datencheck weglassen — spart 15 s

Zusammen etwa eine Minute, ohne dass eine Pflichtanforderung wegfällt.

## Was du auf keinen Fall kürzen solltest

- die `adjusted`-Begründung (1.1)
- den zweiten Absatz zu Plot 02 („In 2005 nobody could have told you…")
- die ACF-Interpretation (5.3) — wörtliche Anforderung
- die Dollar-Formulierung von VaR und ES (6.2) — wörtliche Anforderung
- den 2024/25-VaR (6.4) — deine beste eigene Erkenntnis
- die Inflations-Botschaft (7.3/7.4) — wörtliche Anforderung
- den Schlussblock — sichert Part B ab
