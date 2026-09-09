# Analyse-Ergebnisse: NVDA vs. INTC vs. Nasdaq (2005–2025)

> **Hinweis:** Dies ist das Arbeitsdokument mit allen Zahlen und ihrer Interpretation — kein
> Abgabebestandteil. Die drei Submission Components bauen darauf auf:
> [01_video_presentation.md](01_video_presentation.md), [02_r_script.md](02_r_script.md),
> [03_executive_summary.md](03_executive_summary.md).
> Alle Zahlen stammen aus [bus713_assessment1.R](bus713_assessment1.R), Lauf vom 03.09.2026,
> Rohausgabe in [output/run_log.txt](output/run_log.txt).

---

## 1. Datenbasis

| | |
|---|---|
| Zeitraum | 03.01.2005 – 31.12.2025 (5.283 Handelstage, 252 Monate, 20,99 Jahre) |
| Aktien | NVIDIA (NVDA), Intel (INTC) — beide über den gesamten Zeitraum gelistet, keine Datenlücken |
| Benchmark | Nasdaq Composite (^IXIC) |
| Kursquelle | Yahoo Finance via `tq_get()`, Spalte `adjusted` (split- und dividendenbereinigt) |
| Inflation | US CPI, FRED-Serie `CPIAUCSL` (251 Monatswerte; Oktober 2025 fehlt in der Quelle) |
| Renditen | monatlich log (Rendite-/Volatilitätsvergleich), täglich arithmetisch (Clustering, VaR/ES) |

---

## 2. Gesamtergebnis auf einen Blick

| Kennzahl | NVIDIA | Intel | Nasdaq |
|---|---:|---:|---:|
| Kurs 03.01.2005 (adj.) | $0,18 | $13,34 | 2.152 |
| Kurs 31.12.2025 (adj.) | $186,3 | $36,90 | 23.242 |
| Gesamtwachstum | ×1.035 | ×2,77 | ×10,8 |
| **CAGR nominal** | **39,20 %** | **4,97 %** | **12,00 %** |
| **CAGR real (Fisher)** | **35,70 %** | **2,33 %** | **9,19 %** |
| Ø Rendite p.a. (log, ×12) | 33,1 % | 4,8 % | 11,3 % |
| Volatilität p.a. (monatlich) | 46,3 % | 30,6 % | 17,8 % |
| Volatilität p.a. (täglich) | 48,7 % | 34,9 % | 21,7 % |
| VaR 95 % (täglich) | −4,47 % | −3,14 % | −2,18 % |
| ES 95 % (täglich) | −6,71 % | −5,01 % | −3,29 % |
| VaR 99 % / ES 99 % | −7,75 % / −10,70 % | −6,07 % / −8,66 % | −3,90 % / −5,25 % |
| Max. Drawdown | −85,1 % (20.11.2008) | −70,8 % (08.04.2025) | −55,6 % (09.03.2009) |
| Kurtosis (täglich) | 10,7 | 16,4 | 11,2 |
| Sharpe Ratio | 0,90 | 0,26 | 0,63 |
| Sortino Ratio | 1,60 | 0,38 | 0,97 |
| Beta vs. Nasdaq | 1,68 | 0,92 | 1,00 |
| Korrelation vs. Nasdaq | 0,64 | 0,54 | 1,00 |
| Anteil positiver Monate | 63,5 % | 56,7 % | 61,5 % |
| **$10.000 → nominal** | **$10,35 Mio.** | **$27.672** | **$107.994** |
| **$10.000 → real (2005-Kaufkraft)** | **$6,08 Mio.** | **$16.262** | **$63.465** |

Inflation im Zeitraum: **+70,2 % kumuliert, 2,57 % p.a.** Risikofreier Zins (Ø 3M T-Bill): 1,71 %.

---

## 3. Kursverlauf und Renditen

**Abbildung:** `02_prices_indexed_log.png` (indexiert, Log-Skala) — die stärkste Grafik der Analyse.

Der Log-Chart zeigt drei klar getrennte Phasen:

- **2005–2015:** Intel und Nasdaq laufen praktisch deckungsgleich. NVIDIA ist in dieser Phase
  *nicht* der Überflieger: CAGR 14,6 % (2005–2015) bei extremer Schwankung, inkl. −76 % im Jahr 2008.
- **2016–2025:** NVIDIA koppelt sich nach oben ab (CAGR 72,9 % in dieser Teilperiode), Intel fällt
  ab 2020 unter den Index und bricht 2024 ein (−59,6 % in einem Kalenderjahr).
- **Entscheidender Punkt für die Interpretation:** Die 39 % CAGR von NVIDIA stammen fast
  vollständig aus der zweiten Hälfte des Zeitraums. Wer 2005 investierte, hat zehn Jahre lang
  keine Überrendite gesehen — nur höhere Volatilität.

Kalenderjahresrenditen (%, adjusted):

| Jahr | NVDA | INTC | Nasdaq | | Jahr | NVDA | INTC | Nasdaq |
|---|---:|---:|---:|---|---|---:|---:|---:|
| 2006 | +102,5 | −17,2 | +9,5 | | 2016 | +227,0 | +8,8 | +7,5 |
| 2007 | +37,9 | +34,2 | +9,8 | | 2017 | +82,0 | +30,9 | +28,2 |
| 2008 | −76,3 | −43,5 | −40,5 | | 2018 | −30,8 | +4,2 | −3,9 |
| 2009 | +131,5 | +43,9 | +43,9 | | 2019 | +76,9 | +30,7 | +35,2 |
| 2010 | −17,6 | +6,3 | +16,9 | | 2020 | +122,3 | −14,7 | +43,6 |
| 2011 | −10,0 | +19,4 | −1,8 | | 2021 | +125,5 | +6,1 | +21,4 |
| 2012 | −11,0 | −12,0 | +15,9 | | 2022 | −50,3 | −46,6 | −33,1 |
| 2013 | +33,5 | +30,9 | +38,3 | | 2023 | +239,0 | +94,6 | +43,4 |
| 2014 | +27,4 | +44,2 | +13,4 | | 2024 | +171,2 | −59,6 | +28,6 |
| 2015 | +67,1 | −2,2 | +5,7 | | 2025 | +38,9 | +84,0 | +20,4 |

Extremwerte: NVIDIA schlechtester Tag −30,7 % (03.07.2008), bester Tag +29,8 % (11.11.2016).
Intel schlechtester Tag −26,1 % (02.08.2024, Quartalszahlen + Dividendenstreichung), bester Tag
+22,8 % (18.09.2025). Nasdaq: −12,3 % (16.03.2020) / +12,2 % (09.04.2025).

---

## 4. Risiko I: Volatilität

Die Rangfolge ist über jede Messmethode stabil: **NVIDIA > Intel > Nasdaq**.

Wichtiger als das Niveau ist das Verhältnis von Risiko zu Ertrag:

- NVIDIA: 2,6-fache Index-Volatilität → 2,9-fache Index-Rendite. Risiko wird bezahlt.
- Intel: 1,7-fache Index-Volatilität → 0,4-fache Index-Rendite. Risiko wird **nicht** bezahlt.
- Das ist der Kern der Antwort auf die Ausgangsfrage der Aufgabe: Einzeltitel bieten nicht
  automatisch bessere Chancen — sie bieten in jedem Fall mehr Risiko.

Diversifikation erklärt den Unterschied: Der Index streut über >2.500 Titel, das eliminiert
unsystematisches Risiko. Beta von Intel ist mit 0,92 fast marktneutral, die Korrelation aber nur
0,54 — Intels Zusatzrisiko ist überwiegend firmenspezifisch (Fertigungsrückstand, verpasster
KI-Zyklus) und wird vom Markt nicht mit Rendite entlohnt.

---

## 5. Risiko II: Volatilitätsclustering

**Abbildungen:** `04_daily_returns.png`, `06_monthly_realised_volatility.png`,
`07_rolling_volatility_30d.png`, `08_acf_squared_returns.png`.

Die 30-Tage-Rollvolatilität (annualisiert) über typische Regime:

| Phase | NVDA | INTC | Nasdaq |
|---|---:|---:|---:|
| Finanzkrise (Sep 2008 – Mär 2009) | 91,0 % | 62,3 % | 51,4 % |
| Ruhephase (2013–2014) | 23,0 % | 20,7 % | 13,0 % |
| Covid-Crash (Feb–Apr 2020) | 92,0 % | 86,2 % | 57,8 % |
| Zinswende (2022) | 62,9 % | 37,7 % | 31,6 % |
| KI-Phase (2023–2025) | 48,0 % | 49,0 % | 19,0 % |
| Intel-Absturz (Aug–Dez 2024) | 52,4 % | 60,9 % | 20,0 % |

Drei Befunde:

1. **Regime, keine Konstante.** Zwischen der ruhigsten und der turbulentesten Phase liegt beim
   Nasdaq ein Faktor 4,5 (13 % vs. 58 %). Eine einzelne Volatilitätszahl für 21 Jahre ist ein
   Mittelwert über völlig verschiedene Welten.
2. **Krisen sind synchron.** März 2020 ist bei allen drei Assets der volatilste Monat. Genau dann,
   wenn Diversifikation gebraucht wird, laufen Korrelationen gegen 1 — Streuung über zwei
   Halbleiteraktien hilft im Crash nicht.
3. **Clustering ist statistisch belegt.** Autokorrelation der quadrierten Tagesrenditen:

   | | Lag 1 | Lag 5 | Lag 20 | Lag 50 | Rohrenditen Lag 1 |
   |---|---:|---:|---:|---:|---:|
   | NVDA | 0,085 | 0,076 | 0,063 | 0,032 | −0,043 |
   | INTC | 0,208 | 0,093 | 0,101 | 0,035 | −0,078 |
   | Nasdaq | 0,306 | 0,264 | 0,140 | 0,040 | −0,099 |

   Die Renditen selbst sind praktisch unkorreliert (Richtung nicht prognostizierbar), ihre
   *Größenordnung* dagegen bleibt über 50 Handelstage ≈ 10 Wochen positiv autokorreliert.
   **Übersetzung fürs Management: Man kann nicht vorhersagen, ob es morgen hoch oder runter geht —
   aber sehr wohl, dass es morgen unruhig bleibt, wenn es heute unruhig war.**

Ein aktueller Beleg dafür, dass das praktisch relevant ist: Intels Volatilität liegt seit 2024
dauerhaft über der von NVIDIA (2025: 63,9 % vs. 49,6 %). Das Risiko einer Position ist nicht das,
was der 21-Jahres-Durchschnitt sagt.

---

## 6. Risiko III: Downside Risk (VaR, ES, Drawdown)

**Abbildungen:** `09_var_histograms.png`, `10_var_es_comparison.png`, `11_drawdown.png`.

Historischer 95-%-Tages-VaR und Expected Shortfall, umgerechnet auf eine 1-Mio.-USD-Position:

| | VaR 95 % | in USD | ES 95 % | in USD |
|---|---:|---:|---:|---:|
| NVIDIA | −4,47 % | 44.684 | −6,71 % | 67.107 |
| Intel | −3,14 % | 31.424 | −5,01 % | 50.135 |
| Nasdaq | −2,18 % | 21.775 | −3,29 % | 32.891 |

Formulierung für Nicht-Techniker: *"An einem von zwanzig Handelstagen verliert eine
1-Mio.-USD-Position in NVIDIA mehr als 44.700 USD. Tritt dieser Fall ein, beträgt der
durchschnittliche Verlust 67.100 USD."*

Vier Interpretationspunkte:

1. **ES > VaR in der Aussagekraft.** Der ES liegt bei allen drei Assets rund 50 % unter dem VaR.
   VaR nennt nur die Schwelle, ES die Schwere dahinter — im Krisenfall ist das die relevante Zahl.
2. **Fat Tails.** Kurtosis von 10,7 (NVDA), 16,4 (INTC) und 11,2 (Nasdaq) gegenüber 3 bei
   Normalverteilung. Intels −26,1 % an einem einzigen Tag wäre unter Normalverteilungsannahme ein
   Ereignis, das statistisch nie vorkommen dürfte. Es kam vor. Ein normalverteilungsbasierter VaR
   würde das Risiko systematisch unterschätzen.
3. **Fensterwahl ist entscheidend.** Nur auf 2024–2025 gerechnet: Intel −5,27 % VaR und −7,82 % ES
   — **schlechter als NVIDIA** (−4,68 % / −6,98 %). Der Vollstichproben-VaR unterschätzt Intels
   heutiges Risiko um zwei Drittel. Konsequenz für die Praxis: Risikokennzahlen rollierend
   fortschreiben, nicht einmal über die Gesamthistorie rechnen.
4. **Drawdown ist die gelebte Erfahrung.** VaR misst einen Tag; ein Investor erlebt aber
   Verlustphasen: NVIDIA −85,1 % (2008), Intel −70,8 % (bis April 2025, also über vier Jahre
   anhaltend), Nasdaq −55,6 % (2009). Wer NVIDIAs 39 % CAGR wollte, musste 2008 einen
   85-%-Verlust aussitzen, ohne zu wissen, dass er zurückkommt.

---

## 7. Langfristige Performance: nominal vs. real

**Abbildungen:** `12_cagr_nominal_vs_real.png`, `13_value_of_investment.png`.

Fisher-Gleichung: `(1 + r_real) = (1 + r_nominal) / (1 + Inflation)`, Inflation = CPI-CAGR 2,574 %.

| | nominal | real | Differenz |
|---|---:|---:|---:|
| NVIDIA | 39,20 % | 35,70 % | −3,50 pp |
| Intel | 4,97 % | 2,33 % | −2,64 pp |
| Nasdaq | 12,00 % | 9,19 % | −2,81 pp |

Der Effekt wirkt in Prozentpunkten klein und ist über 21 Jahre trotzdem massiv: Die kumulierte
Inflation von 70,2 % vernichtet **41 % jedes nominalen Endwerts**. Aus $107.994 im Nasdaq werden
$63.465 Kaufkraft von 2005.

**Der schärfste Befund der Analyse — Intel:**

| Intel-Kennzahl | Wert |
|---|---:|
| CAGR inkl. reinvestierter Dividenden (`adjusted`) | 4,97 % |
| CAGR nur Kursentwicklung (`close`, 23,07 → 37,30 USD) | 2,26 % |
| dieselbe Zahl real | **−0,30 %** |
| Inflation | 2,57 % |

Der reine Aktienkurs von Intel ist über 21 Jahre **langsamer gestiegen als die Lebenshaltungskosten**.
Wer die Dividenden konsumiert statt reinvestiert hat — was viele Privatanleger tun —, hat mit dem
eingesetzten Kapital real Kaufkraft verloren. Nur die reinvestierte Dividende hebt das Ergebnis auf
+2,33 % real. Für den Vergleich mit dem Nasdaq Composite ist das zusätzlich relevant, weil der Index
ein *Kursindex* ohne Dividenden ist: In der sauberen Gegenüberstellung Kurs gegen Kurs stehen
Intels 2,26 % gegen 12,00 % des Index.

---

## 8. Risikoadjustierte Performance

| | Rendite p.a. | Volatilität | Sharpe | Sortino |
|---|---:|---:|---:|---:|
| NVIDIA | 44,4 % | 47,1 % | 0,90 | 1,60 |
| Intel | 9,5 % | 30,4 % | 0,26 | 0,38 |
| Nasdaq | 13,0 % | 17,7 % | 0,63 | 0,97 |

(arithmetische Monatsrenditen, risikofreier Zins 1,71 %)

NVIDIA schlägt den Index auch risikoadjustiert — das ist bemerkenswert und muss ehrlich gesagt
werden. Intel liegt bei jeder Kennzahl klar hinten: weniger als die Hälfte der Index-Rendite bei
1,7-facher Volatilität. Der Sortino-Vergleich (1,60 / 0,97 / 0,38) verschiebt das Bild nicht — auch
wenn man nur Abwärtsrisiko bestraft, bleibt die Rangfolge.

Einschränkung, die in die Präsentation gehört: Diese Sharpe Ratio ist **ex post** berechnet und die
Titelauswahl ist mit Wissen von heute getroffen. NVIDIA war 2005 keine erkennbar überlegene
Anlage — 2008 verlor sie 76 %, 2012 lag sie hinter dem Index.

---

## 9. Kernbotschaften für die Präsentation

1. **Der Sektor war richtig, der Titel entschied.** Zwei US-Halbleiterunternehmen, derselbe Markt,
   derselbe Zeitraum, 21 Jahre — Ergebnisunterschied Faktor 374 im Endwert. Sektor-Exposure ist
   keine Erfolgsgarantie; das Stock-Picking-Risiko ist real und bleibt.
2. **Risiko wurde nur bei einem der beiden Titel bezahlt.** Beide Einzelaktien haben deutlich mehr
   Risiko als der Index. NVIDIA hat es mit Überrendite vergütet (Sharpe 0,90 vs. 0,63), Intel nicht
   (0,26). Ex ante war nicht erkennbar, welcher der beiden welcher sein würde.
3. **Inflation ist der stille Kostenblock.** 2,57 % p.a. klingen harmlos und kosten über 21 Jahre
   41 % des Endvermögens. Bei Intel entscheidet die Inflationsbereinigung über Erfolg und
   Misserfolg: 4,97 % nominal → 2,33 % real, und auf reiner Kursbasis −0,30 % real.
4. **Risiko ist zeitvariabel.** Volatilitätsclustering ist in den Daten belegt (ACF der quadrierten
   Renditen über 50 Lags positiv). Ein Risikobudget, das auf einer 21-Jahres-Durchschnittszahl
   basiert, ist im Krisenfall zu klein — Intels aktueller VaR ist 68 % schlechter als der
   historische Durchschnitt.

**Empfehlung:** Index als Kern (bester realer Ertrag je Risikoeinheit für einen normalen Anleger),
Einzeltitel höchstens als bewusst dimensionierte Satellitenposition, deren Größe so gewählt ist,
dass ein Drawdown von 60–85 % tragbar bleibt. Bewertung immer real und risikoadjustiert, Risiko
rollierend statt einmalig messen.

---

## 10. Korrektur zur ursprünglichen These

Die Ausgangshypothese bei der Titelauswahl lautete, Intels reale CAGR sei „sehr wahrscheinlich
negativ oder nahe Null". Das ist auf Basis der bereinigten Kurse **nicht korrekt**: +2,33 % real
inkl. reinvestierter Dividenden. Die Botschaft trägt trotzdem, in präziserer Form:

- Intel hat die Inflation geschlagen, aber nur dank Dividende (+2,33 % real).
- Der Aktienkurs allein hat real verloren (−0,30 % p.a.).
- Entscheidend ist ohnehin der **Opportunitätsvergleich**: 2,33 % real gegen 9,19 % real des Index
  — bei 1,7-fachem Risiko. Aus $10.000 wurden real $16.262 statt $63.465. Das ist die eigentliche
  Kosten-Aussage, nicht das Vorzeichen.

---

## 11. Limitationen

| Limitation | Auswirkung |
|---|---|
| **Selektionsbias** | NVIDIA wurde mit Wissen von 2026 ausgewählt. Der Rückblick auf einen Gewinner sagt nichts über die Ex-ante-Erfolgswahrscheinlichkeit von Stock-Picking. |
| **Index ohne Dividenden** | Der Nasdaq Composite ist ein Kursindex, die Aktienkurse sind dividendenbereinigt. Der Vergleich begünstigt die Einzeltitel leicht (bei Intel um ca. 2,7 pp p.a.). |
| **Historischer VaR** | Unterstellt, dass die Vergangenheit die Zukunft repräsentiert. Volatilitätsclustering widerlegt genau diese i.i.d.-Annahme — deshalb der Kontrollrechnung über 2024–2025. |
| **Endpunktsensitivität der CAGR** | CAGR nutzt nur Anfangs- und Endwert. Startpunkt 2005 (Vorkrisenhoch) und Endpunkt 2025 (KI-Hochphase) prägen das Ergebnis stark: NVDA 2005–2015 nur 14,6 % p.a. |
| **CPI als Durchschnittswarenkorb** | Die individuelle Inflation eines Anlegers (Miete, Studiengebühren, Region) weicht ab. Der Oktober-2025-Wert fehlt in der Quelle (verzögerte BLS-Veröffentlichung). |
| **Keine Kosten, Steuern, Währung** | Transaktionskosten, Quellensteuer auf Dividenden und für einen australischen Anleger das USD/AUD-Risiko sind nicht berücksichtigt. |
| **Nur zwei Titel, kein Portfolio** | Portfolioeffekte (Gewichtung, Korrelation, Rebalancing) sind nicht modelliert; die Korrelation NVDA/INTC von 0,37 deutet an, dass eine Kombination beider das Bild verändern würde. |
| **Rückwärtsgewandte Volatilitätsmessung** | Realisierte und rollierende Volatilität beschreiben die Vergangenheit. Ein GARCH(1,1)-Modell wäre der nächste Schritt für eine echte Prognose. |
