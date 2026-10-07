# Submission Component 1 — Video Presentation

> **Format wie in Task 1:** chronologisch durch das Skript, Abschnitt ausführen → Output erscheint →
> erklären. Für jeden Block: was auf dem Schirm ist, was du sagst, was du weglassen kannst.
>
> **Priorität:** 🔴 muss gesagt werden · 🟡 kurz erwähnen · ⚪ nur laufen lassen
>
> Sprechtext auf Englisch, Erklärungen auf Deutsch. Alle Zahlen sind aus
> [bus713_R-code_AdamHeier2.R](bus713_R-code_AdamHeier2.R) verifiziert, Hintergrund in
> [00_analyse_ergebnisse.md](assigments/Adam/task_1/00_analyse_ergebnisse.md).

---

## Formale Anforderungen

- [ ] **6–10 Minuten** — Zielwert dieses Skripts: **8:50**
- [ ] **Durchgehend auf Kamera sichtbar**
- [ ] **Student ID zu Beginn zeigen**
- [ ] **Beide Fragen** abdecken — Frage 1 ist 20 Punkte wert, Frage 2 zehn; die Zeit ist ungefähr 2:1 verteilt
- [ ] Die Aufgabe verlangt fünf Elemente: *approach, why this approach, how the code connects to the
  conclusions, summary of key findings, recommendations*. Die ersten drei laufen durch den
  Code-Durchgang, die letzten zwei liefert der Schlussblock.

## Vor der Aufnahme

- `Session → Restart R`, dann das ganze Skript einmal sourcen. Es dauert ~6 Sekunden; der Download
  in Abschnitt 1 ist der einzige spürbare Wartemoment.
- `FinCal` muss installiert sein (`install.packages("FinCal")`), sonst bricht Abschnitt 7 ab.
- `set.seed(713)` sorgt dafür, dass die Monte-Carlo-Zahlen bei jedem Lauf identisch sind — die
  Werte unten stimmen also auch live.
- RStudio-Schrift auf mindestens 14 pt, Plots im Viewer groß ziehen.

---

## Zeitplan

| Zeit | Block | Auf dem Schirm |
|---|---|---|
| 0:00–0:30 | Intro, Student ID, die zwei Fragen | Kamera |
| 0:30–1:05 | Abschnitt 1 — Daten | Code, `nrow(capm_data)` |
| 1:05–1:55 | **Abschnitt 2 — Beta** 🔴 | `summary()`, Plot 01 |
| 1:55–2:50 | **Abschnitt 3 — CAPM und SML** 🔴 | `capm_table`, Plot 02 |
| 2:50–3:40 | **Abschnitt 4 — Zuverlässigkeit** 🔴 | `confint()`, Beta ohne 2026 |
| 3:40–4:20 | **Abschnitt 5 — Korrelation** 🔴 | `cor()`, Portfolio-Tabelle |
| 4:20–5:25 | **Abschnitt 6 — Forecast** 🔴 | Hold-out, Prognosetabelle, Plot 03 |
| 5:25–6:10 | **Hedging** 🔴 (kein Code) | Plot 03 oder Kamera |
| 6:10–6:55 | **Abschnitt 7 — NPV und IRR** 🔴 | `npv()`, `irr()`, Zinstabelle |
| 6:55–7:45 | **Abschnitt 8 — Monte Carlo** 🔴 | Ergebnisse, Plot 04 |
| 7:45–8:50 | **Befunde und Empfehlungen** 🔴 | Kamera |

Sprechtext insgesamt ca. 1.200 Wörter — bei 145 Wörtern pro Minute rund 8:15 reine Sprechzeit,
bei ruhigem Tempo (135 wpm) 8:55. Die Planung lässt Luft für Pausen, Scrollen und Code-Ausführung.

---

## 0:00–0:30 — Intro *(Kamera, Student ID zeigen)*

> Hello, my name is Adam Heier, and this is my student ID.
>
> Today I'm answering two questions. First, for our portfolio manager: what risk and return should
> we expect from NVIDIA and Intel, does holding both diversify, where is Intel heading, and how could
> we protect that position? Second, for management: should the firm invest half a million dollars in
> a five-year project? Everything comes from one R script, which I'll run section by section.

---

## 0:30–1:05 — Abschnitt 1: Daten *(Zeile 38–72)* 🟡

**Was der Code macht:** Lädt Tageskurse für NVIDIA, Intel, den Nasdaq und den 10-Jahres-Zins,
reduziert auf Monatsendwerte und baut die Tabelle `capm_data` im Layout von `capm.r` aus Modul 4:
Renditen, risikofreier Zins, Überschussrenditen.

> Section one downloads five years of monthly data, October 2021 to September 2026 — sixty months,
> the standard window for estimating beta. I use adjusted prices, so the returns include dividends.
> As the risk-free rate I take the ten-year US Treasury yield, as in Module 4, and convert it into a
> monthly rate. Subtracting it gives each stock's excess return — what investors earned for taking
> risk.

**Weglassen:** Warum `^TNX` statt FRED, `floor_date()`, `pivot_wider()`. Handwerk, kein Befund.

---

## 1:05–1:55 — Abschnitt 2: Beta *(Zeile 76–106 → `summary()`, Plot 01)* 🔴

**Was der Code macht:** Zwei Regressionen wie im Modul: `lm(nvda_excess ~ nasdaq_excess)`.
Steigung = Beta, Achsenabschnitt = Alpha, R² = Anteil, den der Markt erklärt.

**Was im Output steht:**

| | Beta | Alpha / Monat | p-Wert Alpha | R² |
|---|---:|---:|---:|---:|
| NVIDIA | 1,93 | +3,06 % | **0,013** | 0,61 |
| Intel | 1,84 | +1,27 % | 0,59 | **0,27** |

> Section two estimates beta exactly as in the module: a regression of each stock's excess return
> on the Nasdaq's. The slope is beta.
>
> NVIDIA's beta is 1.93 — when the Nasdaq moves one percent, NVIDIA moves almost two. The market
> explains sixty-one percent of its movements, and its alpha, three percent a month that the market
> doesn't explain, is statistically significant.
>
> Intel's beta is similar at 1.84, but the market explains only twenty-seven percent of its moves,
> and its alpha is not significant. And look at this point at the top right: April 2026, when Intel
> gained a hundred and fourteen percent in a single month. Keep that point in mind.

**Mehrwert:** Der Ausreißer im Scatterplot ist der visuelle Anker für Abschnitt 4. Zeig mit der
Maus darauf.

**Plot 1: CAPM regression (talking points, ~60-90 seconds)**

**What the plot shows**

- Each dot is one month (Oct 2021 to Sep 2026, n = 60).
- x-axis: Nasdaq excess return. y-axis: stock excess return (both minus the risk-free rate, the 10-year US Treasury yield).
- The black line is the OLS regression line. Its slope is beta.

**Why this approach**

- Beta is the CAPM measure of systematic (market) risk.
- Regressing excess returns on market excess returns is the standard way to estimate it.
- 60 monthly observations is the common window for beta estimation.

**Key results**

- NVIDIA: beta = 1.93, R² = 0.61, alpha = 3.06% per month.
- Intel: beta = 1.84, R² = 0.27, alpha = 1.27% per month.
- Both stocks are aggressive (beta > 1): if the Nasdaq moves 1%, they move about 1.9% and 1.8% on average.

**Most important insight: R²**

- Nasdaq explains 61% of NVIDIA's monthly variation, but only 27% of Intel's.
- 73% of Intel's variation is company-specific (unsystematic) risk, which beta does not capture.
- Similar betas, but Intel's beta is far less reliable.

**Limitations (the rubric asks for this)**

- Intel's April 2026 outlier (Intel +114%, Nasdaq +15.3%) is not a data error: close and adjusted prices match and the price level stayed high after the jump.
- Cook's distance for this month is 1.66 (threshold about 0.07), so it has a very strong influence on Intel's regression.
- Therefore I report Intel's beta with and without April (insert numbers from your section 4 output).
- Alpha is not a forecast. It reflects the AI-driven rally in this sample. Check the p-value or `confint()` before claiming it is significantly different from zero.
- Nasdaq is a tech-heavy market proxy. A broader index (e.g. S&P 500) would give different betas.
- Betas change over time, and the CAPM relies on simplifying assumptions.

**Link to the recommendation**

- Both stocks carry high market risk, so the portfolio would be more volatile than the market.
- Intel's risk is mostly stock-specific, which is a reason for caution when relying on its beta.
- Transition: "With these betas, I now calculate the CAPM expected returns and place both stocks on the Security Market Line."

**Weglassen:** Residual standard error, F-Statistik, Adjusted R².

---

## 1:55–2:50 — Abschnitt 3: CAPM und SML *(Zeile 110–158 → `capm_table`, Plot 02)* 🔴

**Was der Code macht:** CAPM-Erwartung = risikofreier Zins + Beta × Marktrisikoprämie, beides als
Durchschnitt derselben 60 Monate (Moduldefinition: historische Überschussrendite des Marktes).
Dann der Vergleich mit der tatsächlich erzielten Rendite.

**Was im Output steht:**

| | CAPM verlangt | realisiert | Position |
|---|---:|---:|---|
| NVIDIA | 24,4 % | 61,1 % | über der SML |
| Intel | 23,4 % | 38,6 % | über der SML |
| Nasdaq | 14,5 % | 14,5 % | auf der SML |

> Section three turns beta into a required return. The CAPM says: risk-free rate plus beta times
> the market risk premium. Following the module, I take the premium from the same five years — the
> Nasdaq returned 14.5 percent a year against a 3.8 percent risk-free rate.
>
> So the CAPM says NVIDIA should have earned 24 percent a year, and Intel 23. They actually earned
> 61 and 39. Both plot above the Security Market Line: they delivered more return than their risk
> justifies, which makes them undervalued in CAPM terms. And the dashed distance to the line is
> exactly the alpha from the regression — the two tools tell the same story.

**Mehrwert:** Der letzte Satz zeigt, dass du verstehst, *warum* die Methode konsistent ist — der
Nasdaq liegt exakt auf der Linie, weil alle Inputs aus demselben Fenster stammen.

**Weglassen:** Die Spalte `capm_forward` — die kommt im nächsten Block.

---

## 2:50–3:40 — Abschnitt 4: Zuverlässigkeit *(Zeile 162–174 → `confint()`, Robustheitstest)* 🔴

**Was der Code macht:** 95 %-Konfidenzintervalle für beide Betas, und Intels Beta ohne die neun
Monate von 2026.

**Was im Output steht:** NVIDIA 1,52 – 2,34; Intel 1,04 – 2,64; Intel ohne 2026: **1,11**.

> How much should we trust this? Section four checks. NVIDIA's beta is fairly precise, between 1.5
> and 2.3. Intel's could be anywhere from 1.0 to 2.6 — and without 2026, its beta drops from 1.84 to
> 1.11. Nine months change the risk picture by two thirds, largely because of that one April.
>
> That is the CAPM's empirical problem from Module 4.4 in our own data: alphas should be zero but
> aren't, and one factor leaves most of Intel's risk unexplained. The inputs matter too: with
> today's yield and a long-run premium of five percent, the CAPM would ask for about fifteen percent
> instead of twenty-four. So: moderate confidence in NVIDIA's numbers, low confidence in Intel's.
> 
> "The CAPM predicts alpha of zero, but both stocks beat the line. Intel's market risk explains only 27% of its movements, so I trust its beta less. The result also depends on the inputs: with a normal 5% market premium, the required return would be much lower. So I have moderate confidence in NVIDIA and low confidence in Intel."

**Mehrwert:** Das ist die Antwort auf „how much confidence should an investor place in your
findings" — mit eigenen Zahlen statt nur mit Theorie. Für High Distinction entscheidend.

**Optional bei Zeitreserve:** Fama/French — Alpha variiert mit Größe, Value und Momentum. Und:
NVIDIA ist selbst eines der größten Gewichte im Nasdaq, das bläht sein R² auf.

---

## 3:40–4:20 — Abschnitt 5: Korrelation *(Zeile 178–193 → `cor()`, Portfolio-Tabelle)* 🔴

**Was im Output steht:** Korrelation **0,23**.

| | Volatilität | Beta |
|---|---:|---:|
| NVIDIA | 50,1 % | 1,93 |
| Intel | 72,2 % | 1,84 |
| 50/50-Portfolio | **48,4 %** | **1,89** |
| Nasdaq | 20,3 % | 1,00 |

> Section five asks whether holding both helps. The correlation of their monthly returns is only
> 0.23 — surprisingly low for two chipmakers, because their company stories are so different.
>
> You can see it in the table: a fifty-fifty portfolio is less volatile than NVIDIA alone, 48
> percent against 50, even though Intel on its own is far riskier at 72. So yes, combining them
> diversifies firm-specific risk. But the portfolio's beta stays at 1.89. Diversification removes
> company risk, not market risk — together they are still a leveraged bet on the Nasdaq.

**Mehrwert:** Die Unterscheidung Gesamtrisiko vs. Marktrisiko beantwortet „meaningful
diversification?" präziser als ein reines Ja oder Nein.

---

## 4:20–5:25 — Abschnitt 6: Forecast *(Zeile 197–235 → Hold-out, Prognose, Plot 03)* 🔴

**Was im Output steht:**

| Hold-out Apr – Sep 2026 | RMSE | MAPE |
|---|---:|---:|
| ETS | 66,5 | 58,0 % |
| Linearer Trend | 83,2 | 74,3 % |

Prognose: 120 $ flach; März 2027 80 %-Intervall **68 – 212 $**. Trend: 57 – 59 $.

> Section six forecasts Intel's price for the next six months — the obvious question after it
> tripled this year. First I test two methods from the module on six months they haven't seen:
> exponential smoothing misses by 58 percent, a straight-line trend by 74. Both fail, because Intel
> tripled in exactly that window.
>
> I use exponential smoothing on log prices, which keeps the forecast positive. The model chooses a
> smoothing parameter of one — the best forecast for next month is simply this month's price. That's
> the random walk from Module 2, confirmed by the data. A straight line would predict under 60
> dollars, half today's price.
>
> So the forecast is flat at 120 dollars, with an eighty percent range of 68 to 212 after six months.
> There is no reliable directional signal. The value of this forecast is the range: it shows how far
> Intel could plausibly fall.


Next, I forecast Intel's closing price for the next six months.

Before trusting any method, I tested two of them on data they had not seen. I hid the last six months, April to September 2026, and let exponential smoothing and a straight-line trend predict them. Then I compared the forecasts with the real prices in this table.

Intel traded between 90 and 140 dollars in that period. Exponential smoothing stayed at 44 dollars, the last price it knew. The trend line was even lower, at about 27 dollars, because Intel's price had been falling for years before. Both methods predicted too low in every single month. The average error was 58 percent for exponential smoothing and 74 percent for the trend, so both are poor. Exponential smoothing was less wrong, so I use it, on log prices so the forecast cannot fall below zero.

For the real forecast, I refit the model on all 60 months. It is flat at about 116 dollars, which means the model expects no change. There is no reliable signal that Intel will rise or fall.

What matters is the range. With 80 percent probability, the price after six months lies between about 66 and 204 dollars. For a portfolio manager, this is not a price target. It shows how uncertain Intel is, in both directions, and why protecting against a fall, for example with a put option, is worth considering.

**Mehrwert:** Methode begründet (Modul + Daten), gegen Alternative getestet, Zuverlässigkeit
kritisch bewertet, Konsequenz für den PM — alle vier Rubrikpunkte in einer Minute.

**Achtung, zwei „Alphas":** Den ETS-Parameter „smoothing parameter" nennen, nicht „alpha" — sonst
verwechselt das Publikum ihn mit dem CAPM-Alpha.

---

## 5:25–6:10 — Hedging *(kein Code, Plot 03 stehen lassen oder Kamera)* 🔴

> That range leads to the hedge. I would buy put options: the right to sell Intel at, say, 100
> dollars for six months. If Intel falls to 68, the put pays 32 dollars a share and caps the loss;
> if Intel rises, we keep the upside, minus the premium.
>
> Why not futures? Single-stock futures are no longer traded in the US, and a Nasdaq futures hedge
> only covers market risk — but our regression showed that 73 percent of Intel's risk is
> firm-specific. The limitations: with 72 percent volatility the puts are expensive, the protection
> expires after six months, and losses down to the strike aren't covered.

The forecast gives no direction, but a very wide range: after six months, Intel could plausibly be anywhere between about 66 and 204 dollars. So instead of guessing where the price goes, I would protect against a fall.

My choice is a put option on Intel. It gives us the right, but not the obligation, to sell the shares at a fixed price, say 100 dollars, for six months. If Intel falls to 66, the put pays 34 dollars per share. If Intel rises, we let it expire and keep the upside, minus the premium we paid. It works like an insurance policy.

Why not a futures contract? A future would lock in a selling price and give up the upside. A Nasdaq future would also hedge only market risk, and my regression showed that the market explains just 27 percent of Intel's movements. The other 73 percent is company-specific, and only a put on Intel itself covers it.

The limitations: the premium is lost whenever we do not need the protection, and with Intel's high volatility it is expensive. The protection expires after six months. And the first losses down to the strike, here 16 dollars from today's price of about 116, are ours. So a put makes sense if limiting a large fall matters more than its cost.
**Mehrwert:** Die Begründung gegen Futures kommt aus deinem eigenen R² — das verbindet Hedging mit
der Analyse, statt es als Lehrbuchabsatz anzuhängen.

**Optional:** Ein Collar (zusätzlich Call verkaufen) senkt die Kosten, deckelt aber den Gewinn.

---

## 6:10–6:55 — Abschnitt 7: NPV und IRR *(Zeile 243–264)* 🔴

**Was im Output steht:** NPV −120.921 $, IRR 0 %; NPV bei 0/5/8/10/12 %: 0 / −67k / −101k / −121k /
−140k; Break-even-Umsatz 231.899 $; maximale Investition 379.079 $.

> Question two. The project costs 500 thousand dollars and earns 100 thousand a year for five years.
> Section seven computes NPV and IRR with the FinCal package from Module 6.
>
> At a 10 percent required return, the NPV is minus 121 thousand dollars, and the IRR is exactly
> zero. The reason is simple: five times 100 thousand is exactly the 500 thousand we put in. The
> project gives our money back with no return at all, so it's negative at every positive discount
> rate — the choice of ten percent doesn't change the decision. To break even, revenue would have to
> be 16 percent higher every year, or the investment 24 percent lower.

**Mehrwert:** „IRR = 0 %" in einem Satz erklärt („gibt nur das Geld zurück") ist genau die
„plain language"-Interpretation, die die Rubrik verlangt.

---

## 6:55–7:45 — Abschnitt 8: Monte Carlo *(Zeile 268–297 → Plot 04)* 🔴

**Was im Output steht:** Mittel −121.476 $; 5 % −210.529 $; 95 % −32.026 $; **P(NPV > 0) = 1,2 %**.

> But revenues and costs are only forecasts, and a single NPV suggests false precision. So section
> eight runs a Monte Carlo simulation, as in Workshop 6: ten thousand possible futures, drawing
> revenue and costs for every year. Revenue varies more, fifteen percent, because demand and prices
> are set by the market, while costs are largely under our control.
>
> The histogram shows the result. The average NPV is minus 121 thousand. Even the best five percent
> of outcomes lose 32 thousand, and only 1.2 percent of simulations create value. Uncertainty
> doesn't rescue this project — it only shows how much worse it could get.

**Mehrwert:** Die Begründung für Monte Carlo („false precision", Umsatz streut stärker als Kosten)
erfüllt das Rubrikkriterium „the chosen approach is explicitly justified".

---

## 7:45–8:50 — Befunde und Empfehlungen *(Kamera)* 🔴

**Ankündigen**, damit „summary of key findings" und „recommendations" unübersehbar sind:

> Let me bring the findings together.
>
> For the portfolio manager: both stocks roughly double the market's moves. Both plot above the
> SML, but only NVIDIA's outperformance is statistically reliable. Holding both lowers total risk,
> not market risk, and Intel's price isn't forecastable six months out. My recommendation: hold them
> as a satellite position, not the core — more NVIDIA, a smaller Intel position protected with puts
> after its rally — and size it knowing that a ten percent market fall means about nineteen percent
> for these two.
>
> For management: reject the project on current terms. It only returns its cost and destroys value
> in almost ninety-nine percent of simulated futures. Revisit it only if the investment falls below
> 380 thousand dollars or the project carries an option to expand or abandon.
>
> The main caveat: five years that included an AI boom and an extreme rally drive all of this — a
> different window would give different betas. Thank you.

---

## Wenn du über 9:30 landest — in dieser Reihenfolge kürzen

1. Abschnitt 1 auf zwei Sätze — spart 15 s
2. In Abschnitt 4 den Satz zur Marktrisikoprämie streichen — spart 15 s
3. In Abschnitt 6 den Satz zum linearen Trend streichen — spart 10 s
4. Im Hedging die Begründung gegen Futures auf einen Satz — spart 10 s
5. Im Schluss die Revisiting-Bedingung weglassen — spart 8 s

## Nicht kürzen

- Beta-Interpretation und den April-Ausreißer (Abschnitt 2)
- Die SML-Einstufung beider Aktien (Abschnitt 3) — Kernanforderung
- Das Konfidenzurteil „moderate / low confidence" (Abschnitt 4) — wörtliche Aufgabenfrage
- „Company risk, not market risk" (Abschnitt 5)
- Den Glättungsparameter = 1 und die Spanne 68 – 212 $ (Abschnitt 6)
- Vorteile **und** Grenzen beim Hedging — Rubrik verlangt beides
- „IRR = 0, gibt nur das Geld zurück" (Abschnitt 7)
- Die 1,2 % (Abschnitt 8)
- Den Schlussblock — er liefert „key findings" und „recommendations"
