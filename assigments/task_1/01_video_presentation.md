# Submission Component 1 — Video Presentation

> **Hinweis zur Sprache:** Der Sprechtext ist auf Englisch (so wird das Video aufgenommen), die
> Regieanweisungen und Erklärungen sind auf Deutsch. Alle Zahlen sind aus
> [bus713_assessment1.R](bus713_assessment1.R) verifiziert, Belege in
> [00_analyse_ergebnisse.md](00_analyse_ergebnisse.md).

## Formale Anforderungen (Checkliste vor der Aufnahme)

- [ ] **6–10 Minuten** Gesamtlänge — Zielwert dieses Skripts: **8:50**
- [ ] **Durchgehend auf Kamera sichtbar** (Webcam-Overlay in der Ecke, nicht ausblenden beim Screenshare)
- [ ] **Student ID zu Beginn zeigen** (in die Kamera halten, ca. 3 Sekunden, klar lesbar)
- [ ] Adressat ist **Management und Stakeholder**, nicht der Dozent — kein Fachjargon ohne Übersetzung
- [ ] Zwei Teile: **Part A Code & Approach**, **Part B Insights & Interpretation**
- [ ] Vorher offen haben: RStudio mit dem Skript, Ordner `output/` mit den Grafiken

---

## Zeitplan

| Zeit | Abschnitt | Auf dem Bildschirm |
|---|---|---|
| 0:00–0:35 | Intro + Student ID | Nur Kamera |
| 0:35–1:05 | Auftrag, Datenbasis, Skriptaufbau | Skript-Kopf, Abschnittsliste (Zeile 13–23) |
| 1:05–1:40 | **Part A1** Datenimport | Skript Abschnitt 1 |
| 1:40–2:15 | **Part A2** Kursgrafiken: Skalen und Log-Achse | Skript Abschnitt 2 |
| 2:15–2:50 | **Part A3** Renditen, zwei Frequenzen | Skript Abschnitt 3 |
| 2:50–3:25 | **Part A4** Volatilität & Clustering | Skript Abschnitt 4 und 5 |
| 3:25–4:00 | **Part A5** VaR & Expected Shortfall | Skript Abschnitt 6 |
| 4:00–4:35 | **Part A6** CAGR, Inflation, Ergebnistabelle | Skript Abschnitt 7, kurz 8 und 9 |
| 4:35–5:30 | **Part B1** Befund 1: Rendite und Streuung | `02_prices_indexed_log.png` |
| 5:30–6:20 | **Part B2** Befund 2: Risiko wird nicht immer bezahlt | `05_return_vs_volatility.png` |
| 6:20–7:10 | **Part B3** Befund 3: Risiko ist zeitvariabel | `06_monthly_realised_volatility.png` |
| 7:10–7:55 | **Part B4** Befund 4: Inflation | `10_cagr_nominal_vs_real.png` |
| 7:55–8:55 | Empfehlung, Limitationen, Schluss | `summary_table.csv` oder Kamera |

Part A und Part B sind damit etwa gleich lang (je ca. 4 Minuten). Die Aufgabenstellung gewichtet
beide Teile, deshalb sollte keiner untergehen. Der Sprechtext umfasst rund 1.290 Wörter — bei
normalem Präsentationstempo (145–150 Wörter pro Minute) sind das etwa 8:45 reine Sprechzeit; die Zeitplanung oben lässt in jedem Block Luft für Pausen und Scrollen.

---

## Sprechskript

### 0:00–0:35 — Intro *(nur Kamera, Student ID zeigen)*

> Hello, my name is Adam Heier, and this is my student ID.
>
> I work as an analyst at an investment firm, and our clients keep asking the same question: with
> all the excitement around artificial intelligence, is it better to pick individual technology
> stocks, or simply to track the market?
>
> To answer that, I compared two large-cap semiconductor stocks — NVIDIA and Intel — against the
> Nasdaq Composite, from January 2005 to December 2025. Same sector, same market, same period. The
> only difference is which company you picked.

### 0:35–1:05 — Datenbasis und Aufbau *(Skript-Kopf und Abschnittsliste zeigen)*

> Everything you'll see comes from one reproducible R script. It downloads prices from Yahoo
> Finance and US inflation data from the Federal Reserve, and writes every chart straight to disk.
>
> The script has nine numbered sections that follow the logic of the question: first prices and
> returns, then risk, then inflation. Nothing is copied by hand, so the whole study re-runs in
> about a minute.

### 1:05–1:40 — Part A1: Datenimport *(Abschnitt 1 zeigen)*

> Section one downloads the data. I use the *adjusted* closing price, which corrects for dividends
> and stock splits. That matters here: NVIDIA did a ten-for-one split in 2024, and without the
> adjustment the analysis would read that as a ninety-percent crash.
>
> I then check that all three series have the same number of trading days and the same start and
> end date — if the samples didn't line up, every comparison after that would be quietly wrong.

### 1:40–2:15 — Part A2: Kursgrafiken *(Abschnitt 2 zeigen)*

> Section two plots the prices, with two deliberate choices. The two stocks share one dollar scale,
> so you can see how far apart their price levels are — but the index keeps its own scale, because
> index points and dollars are not the same unit.
> 
> 
> coord_cartesian() zooms without deleting observations - with
> scale_y_continuous(limits = ...) every point above 200 would be dropped from
> the data (NVIDIA peaks at 207 USD) and the line would break.


>
> For the comparison chart I rescale all three to a hundred and switch to a log axis. On a normal
> scale NVIDIA flattens the other two into a straight line; on a log scale, equal slopes mean equal
> percentage growth.
> 
> I use a logarithmic y-axis because on a linear scale, NVIDIA's extreme growth would compress Intel and the Nasdaq into flat lines near zero, making their trends invisible. On a log scale, equal vertical distances represent equal percentage changes, so the slopes are directly comparable across all three assets regardless of their different starting levels.
> 
> A log scale is essential here: on a linear scale NVIDIA's growth compresses everything else into a flat line. On a log scale, equal vertical distances mean equal percentage changes, so the slope is directly comparable.


### 2:15–2:50 — Part A3: Renditen *(Abschnitt 3 zeigen)*

> Section three turns prices into returns — the most important methodological step in the script.
> We never measure risk on prices, because prices trend: their average keeps moving, so a standard
> deviation of prices means nothing. Returns fluctuate around a stable average.
>
> I compute two frequencies on purpose: monthly log returns for the return and volatility
> comparison, and daily returns for the risk work, because tail risk needs a lot of observations —
> five thousand three hundred per asset instead of two hundred and fifty.

| Chart                                    | Zeigt                                                         | Beantwortet                                             |
| ---------------------------------------- | ------------------------------------------------------------- | ------------------------------------------------------- |
| **Monthly log returns** (Bild 2)         | Roh-Renditen: Richtung + Größe jeder einzelnen Monatsbewegung | "Wie stark schwankt der Preis, und in welche Richtung?" |
| **Monthly realised volatility** (Bild 1) | Nur die Streuung (Standardabweichung), Richtung fällt weg     | "Wann war es turbulent, wann ruhig?"                    |
**Der eigentliche Mehrwert von Chart 1 gegenüber Chart 2:** Volatility Clustering ist im Returns-Chart nur schwer zu erkennen, weil positive und negative Ausschläge sich optisch abwechseln — dein Auge muss "Amplitude" aus einem verrauschten Signal herausfiltern. Im Volatility-Chart siehst du das **direkt und eindeutig**: die Spitzen bei 2008/09, 2020 (Corona) und die INTC-Spitze um 2025 springen sofort ins Auge, weil Richtung rausgerechnet ist und nur "wie wild war's" übrig bleibt.


### 2:50–3:25 — Part A4: Volatilität und Clustering *(Abschnitt 4 und 5 zeigen)*

> Sections four and five deal with volatility. Four measures how widely returns are dispersed — the
> standard deviation, annualised. Five asks whether that number is even constant over time, using
> realised volatility per month and a thirty-day rolling window.
>
> Then I test for clustering formally: I square each daily return, which removes the direction and
> keeps only the size of the move, and run an autocorrelation function on it. If turbulence were
> random, those correlations would drop to zero. They stay positive beyond fifty trading days.
> 
> **Die Kernaussage in einem Satz für deine Präsentation:**

> "Man kann aus der Vergangenheit nicht vorhersagen, _ob_ der Kurs morgen steigt oder fällt (`raw_lag1` ≈ 0) — aber man kann sehr wohl vorhersagen, _wie stark_ er sich bewegen wird (`sq_lag1` bis `sq_lag50` bleiben deutlich positiv)."

Das ist genau der Unterschied zwischen **Richtungsvorhersage** (nicht möglich, Markteffizienz) und **Risikovorhersage** (sehr wohl möglich, Basis für Modelle wie GARCH in der Praxis) — ein zentraler Punkt der modernen Finanzmarkttheorie, den du hier sauber mit deinen eigenen Daten belegt hast.

### 3:25–4:00 — Part A5: VaR und ES *(Abschnitt 6 zeigen)*

> Volatility treats gains and losses symmetrically. VaR and ES look only at the left tail: how bad can a bad day get?
> 
> Section six is downside risk. Volatility treats a gain and a loss the same way; management
> usually only cares about the loss.
>
> Value at Risk is the fifth percentile of the daily return distribution — one line of code, the
> `quantile` function. Expected Shortfall is the average of everything worse than that cutoff.
> Value at Risk tells you where the bad zone starts; Expected Shortfall tells you how bad it gets
> once you're in it. I convert both into dollars on a one-million-dollar position.

### 4:00–4:35 — Part A6: CAGR, Inflation und Ergebnistabelle *(Abschnitt 7 zeigen, 8 und 9 kurz)*

> Section seven measures long-run growth. The compound annual growth rate turns twenty-one years of
> price change into one annual rate. A nominal rate is only half the answer, so I also download the
> US Consumer Price Index and apply the Fisher equation: one plus the real return equals one plus
> the nominal return, divided by one plus inflation. I use the exact form rather than subtracting,
> because both rates compound.
>
> Sections eight and nine add the risk-adjusted ratios and pull everything into one summary table.

### 4:35–5:30 — Part B1: Befund 1 *(`02_prices_indexed_log.png`)*

> Now the results. This chart shows what a hundred dollars invested in January 2005 became, on the
> log scale I just described.
>
> Three very different outcomes. NVIDIA turned ten thousand dollars into **ten point four million**.
> The Nasdaq turned the same ten thousand into **one hundred and eight thousand**. Intel turned it
> into **twenty-seven thousand six hundred**. As annual growth rates: thirty-nine percent for
> NVIDIA, twelve for the index, five for Intel.
>
> But look at the first ten years. Until about 2015, Intel and the Nasdaq move together, and NVIDIA
> is not the star — it just swings more, including a seventy-six percent loss in 2008. Almost all
> of NVIDIA's advantage was earned in the second half. In 2005, nobody could have told you which of
> the two would be which.

### 5:30–6:20 — Part B2: Befund 2 *(`05_return_vs_volatility.png`)*

> That leads to the finding that matters most for the original question. Both individual stocks
> carry far more risk than the index: annual volatility of forty-six percent for NVIDIA and
> thirty-one for Intel, against eighteen for the Nasdaq.
>
> The question is whether that extra risk got paid for. For NVIDIA it did: two and a half times the
> index volatility, almost three times the return — Sharpe ratio zero point nine against zero point
> six three for the index. For Intel it did not: nearly *twice* the index risk, for **less than
> half** the index return. Sharpe ratio zero point two six.
>
> Same sector, same twenty-one years, and the gap in the final value is a factor of three hundred
> and seventy.

### 6:20–7:10 — Part B3: Befund 3 *(`06_monthly_realised_volatility.png`)*

> Second finding: risk is not a constant, and this chart is the evidence. Rolling volatility moves
> in waves. In the calm years 2013 and 2014 the Nasdaq ran at thirteen percent; in the Covid crash
> it hit fifty-eight.
>
> Two practical consequences. The crises are synchronised — March 2020 is the most volatile month
> for all three assets, so diversifying across two semiconductor stocks does not help on the day
> you need it. And Intel's Value at Risk over the full twenty-one years is minus three point one
> percent; over the last two years alone it's minus five point three — **worse than NVIDIA's**. A
> risk limit built on the long-run average would be far too small for the position we hold today.

### 7:10–7:55 — Part B4: Befund 4 *(`10_cagr_nominal_vs_real.png`)*

> Third finding, and the one I'd put in front of the board: inflation. US consumer prices rose two
> point five seven percent a year — seventy percent in total. That quietly removes **forty-one
> percent** of every nominal figure I've shown you.
>
> In real terms, NVIDIA delivered thirty-six percent a year, the Nasdaq nine point two, and Intel
> two point three. And there's a detail behind Intel's number: those five percent include
> reinvested dividends. Intel's share price alone grew at two point three percent while inflation
> ran at two point six. An investor who held Intel and spent the dividends **lost purchasing power
> over twenty-one years**, even though the share price went up.

### 7:55–8:55 — Empfehlung und Schluss *(Kamera oder Summary-Tabelle)*

> So what do I recommend?
>
> For a normal client, the index stays the core of the portfolio. It delivered the best real return
> per unit of risk of any *predictable* choice: nine point two percent real, at eighteen percent
> volatility, with none of the single-company risk. Individual stocks belong in a satellite
> position, sized so that a deep drawdown is survivable — because that is what actually happened:
> NVIDIA lost eighty-five percent in 2008, Intel seventy-one percent through 2025.
>
> Two limitations I want to be honest about. I picked NVIDIA knowing how the story ended, so this
> is not evidence that stock-picking works — it's evidence of what it costs when it doesn't. And
> historical Value at Risk assumes the past repeats, which is why I re-estimated it on recent data.
>
> The headline: nominal returns flatter, sector exposure guarantees nothing, and the only
> comparison that means anything is a real, risk-adjusted one. Thank you.

---

## Regie- und Aufnahmehinweise

**Bildschirmaufteilung.** Screenshare mit Kamera-Overlay unten rechts. In RStudio Schriftgröße auf
mindestens 14 pt erhöhen, Zoom des Editors auf ~130 % — kleiner Code ist im Video unlesbar.

**Part A: nicht zeilenweise vorlesen.** Zu den sechs markierten Stellen scrollen und jeweils sagen
*was* passiert und *warum*. Der Bewertungsschwerpunkt liegt auf dem „warum": bereinigte Kurse,
getrennte Skalen plus Log-Achse, Renditen statt Preise, zwei Frequenzen, quadrierte Renditen für
Clustering, Fisher statt Subtraktion.

**Abschnitt 2 nicht überspringen.** Die Grafik aus Abschnitt 2 ist dieselbe, die in Part B1 die
Kernaussage trägt. Wenn die Entscheidung für die Log-Skala vorher im Code erklärt wurde, muss sie
in Part B nicht noch einmal begründet werden — das spart dort Zeit und wirkt zusammenhängend.

**Zahlen im Sprechtext.** Immer ausgesprochene Form verwenden („thirty-nine percent", nicht „39 %"),
sonst klingt es abgelesen. Die fett markierten Zahlen sind die, die hängenbleiben sollen — dort
kurz Pause machen.

**Wenn die Zeit knapp wird**, in dieser Reihenfolge kürzen:
1. in Part A1 den zweiten Absatz (Datencheck) streichen
2. in Part A6 den letzten Absatz (Abschnitte 8 und 9) auf einen Halbsatz kürzen
3. den zweiten Absatz von Part B1 (die 2005–2015-Beobachtung) streichen
4. in der Empfehlung nur eine der beiden Limitationen nennen

**Wenn Zeit übrig ist** (unter 7:00), ergänzen:
- Die Fat-Tail-Zahl: *"Intel's worst day was minus twenty-six percent. Under a normal distribution
  that is a once-in-the-history-of-the-universe event. It happened in August 2024."*
