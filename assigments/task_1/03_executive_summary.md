# Submission Component 3 — Executive Summary

> **Hinweis:** Der Abgabetext ist auf Englisch. Version A ist die Fassung zum Einreichen
> (~250 Wörter, deckt die vier geforderten Fragen ab). Version B ergänzt „Challenges" und
> „Application" ausführlicher — falls der Marker die beiden im Aufgabentext genannten Punkte
> separat ausformuliert sehen will. Zahlenbelege in [00_analyse_ergebnisse.md](00_analyse_ergebnisse.md).

---

## Version A — Abgabefassung (263 Wörter)

**Executive Summary**

**What did you analyse?** I compared two large-cap semiconductor stocks, NVIDIA and Intel, against
the Nasdaq Composite from January 2005 to December 2025. One reproducible R script pulls adjusted
prices from Yahoo Finance and US CPI data from FRED, and evaluates returns, volatility over time,
downside risk (Value at Risk and Expected Shortfall) and long-run growth in nominal and
inflation-adjusted terms.

**What did you find?** NVIDIA compounded at 39.2% a year nominally and 35.7% in real terms, the
Nasdaq at 12.0% and 9.2%, and Intel at 5.0% and 2.3%. Both stocks were far riskier than the index
— 46% and 31% annual volatility against 18% — but only NVIDIA was rewarded for that risk (Sharpe
ratio 0.90, against 0.63 for the index and 0.26 for Intel). Volatility clusters strongly, so risk is
a regime rather than a constant: Intel's Value at Risk over the last two years (−5.3%) is
two-thirds worse than its twenty-one-year figure (−3.1%). Inflation of 2.57% a year removed 41% of
every nominal end value, and Intel's share price alone grew more slowly than consumer prices.

**What would you recommend?** Keep the index as the portfolio core, and treat any single stock as a
deliberately sized satellite that can survive a 60–85% drawdown, because that is what both stocks
delivered. Judge performance in real, risk-adjusted terms, and re-estimate risk on a rolling window
rather than once.

**What are the limitations?** NVIDIA was selected with hindsight, historical VaR assumes the past
repeats, the index excludes dividends while the stock series include them, and CAGR is sensitive to
the start and end dates chosen.

---

## Version B — erweiterte Fassung mit Challenges und Application (456 Wörter)

**Executive Summary**

**What did you analyse?** I compared two large-cap semiconductor stocks, NVIDIA and Intel, against
the Nasdaq Composite from January 2005 to December 2025, using one reproducible R script that
downloads adjusted prices from Yahoo Finance and US CPI data from FRED. The analysis covers
returns, volatility over time, downside risk (Value at Risk and Expected Shortfall) and long-run
growth in nominal and real terms.

**What did you find?** NVIDIA compounded at 39.2% a year nominally and 35.7% in real terms, the
Nasdaq at 12.0% and 9.2%, and Intel at 5.0% and 2.3%. Both stocks were far riskier than the index
(46% and 31% annual volatility against 18%), but only NVIDIA was rewarded for it: Sharpe ratio 0.90
against 0.63 for the index and 0.26 for Intel. Volatility clusters — squared daily returns stay
positively autocorrelated beyond fifty trading days — so risk is a regime, not a constant. Inflation
of 2.57% a year removed 41% of every nominal end value; Intel's share price alone grew more slowly
than consumer prices, and only reinvested dividends kept the position ahead of inflation.

**What would you recommend?** Keep the index as the core holding and treat single stocks as a
deliberately sized satellite that can survive a 60–85% drawdown. Evaluate performance in real,
risk-adjusted terms, and re-estimate risk on a rolling window: Intel's recent VaR of −5.3% is
two-thirds worse than its full-sample figure.

**What are the limitations?** NVIDIA was picked with hindsight, historical VaR assumes the past
repeats, the Nasdaq index excludes dividends while the stock series include them, and CAGR depends
heavily on the endpoints chosen.

**What was challenging?** The FRED endpoint used in the module material refused requests without an
API key, so I wrote a fallback that reads the public CSV series instead; the October 2025 CPI
observation is also missing from the source data and had to be handled explicitly. The harder
problem was conceptual: deciding which price series answers which question. Intel's real growth
looked positive on adjusted prices but negative on price alone, and that difference — dividends —
changes the conclusion, so both figures belong in the report.

**How would I apply this?** The workflow generalises directly: pull data through an API, transform
it, compute a small number of decision-relevant metrics, and end with one table and one chart that
a non-specialist can act on. That structure works for monitoring costs, demand or delivery times
just as well as for share prices, and a script beats a spreadsheet because it is repeatable and
auditable. Personally, the real-versus-nominal distinction is the lasting takeaway: a salary,
a savings account or a "safe" long-term holding can rise in money terms and still lose purchasing
power, and only the inflation-adjusted number tells you whether you are actually better off.

---

## Prüfhinweise vor der Abgabe

- Version A liegt bei 263 Wörtern inklusive der vier Fragen-Überschriften, also im Rahmen von
  „approximately 250". Falls hart gekürzt werden muss: im Absatz „What did you find?" den Halbsatz
  ab „Intel's Value at Risk over the last two years" streichen (−25 Wörter).
- Alle Prozentzahlen stimmen mit `output/summary_table.csv` überein — bei einem erneuten Skriptlauf
  mit späterem Enddatum ändern sich die Werte und müssen hier nachgezogen werden.
- Die Aufgabenstellung verlangt Challenges und Application zusätzlich zu den vier Fragen. Wenn nur
  eine Datei abgegeben werden darf, ist Version B die sichere Wahl; wenn strikt 250 Wörter gelten,
  Version A abgeben und Challenges/Application im Video ansprechen.
