# Olist Late Delivery & Customer Satisfaction Analysis

**Business question:** Which product categories and regions drive the most
late deliveries, and how does that relate to customer review scores?

**Dataset:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/olistbr/brazilian-ecommerce)
— ~100k real orders (2016–2018) from the largest department store on
Brazilian marketplaces.

## Tools used

- **SQL (SQLite)** — schema design, table loading, and the core joins/aggregations
  that answer the business question (`sql/`)
- **Python (pandas, scipy)** — statistical testing (correlation, t-test) and
  clean CSV exports for reporting (`python/`)
- **Google Sheets** — final dashboard/visuals for a non-technical audience
  (link: *add your published Sheets link here once built*)

## Project structure

```
olist-portfolio/
├── data/
│   ├── raw/              # source CSVs
│   └── olist.db          # SQLite database (built by python/01_load_data.py)
├── sql/
│   ├── 01_schema.sql      # table definitions
│   └── 02_analysis.sql    # views answering the business question
├── python/
│   ├── 01_load_data.py    # loads raw CSVs into SQLite
│   └── 02_analysis.py     # runs stats + exports summary CSVs
├── sheets_exports/         # CSVs ready to paste into Google Sheets
└── README.md
```

## How to run it

```bash
pip install pandas scipy
python python/01_load_data.py   # builds data/olist.db from the raw CSVs
python python/02_analysis.py    # runs the SQL views + stats, exports CSVs
```

## Key findings

- **Late deliveries tank satisfaction.** Orders delivered after the estimated
  date average a **2.55–2.57** review score, vs **4.21–4.29** for on-time
  orders — a statistically significant relationship (point-biserial
  r = -0.364, p ≈ 0).
- **Lateness is heavily regional.** Northeastern states (AL, MA, SE, CE, PI,
  BA) have late-delivery rates of 15–26%, roughly 3-4x higher than the
  best-performing states — pointing to logistics/carrier issues rather than
  demand-side problems.
- **Category effects are smaller but real.** Categories like
  `christmas_supplies`, `furniture_mattress_and_upholstery`, and
  `office_furniture` show above-average lateness (~12-14%), often tied to
  bulky items or seasonal demand spikes.

## Next steps

- Build the Google Sheets dashboard from `sheets_exports/`
- Segment by seller (are specific sellers driving the regional lateness?)
- Control for order value / freight distance as confounders
