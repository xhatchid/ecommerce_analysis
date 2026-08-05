"""
Deeper analysis on top of the SQL views: correlation between lateness and
review score, and clean summary tables exported to CSV for Google Sheets.

Run from the project root:
    python python/02_analysis.py
"""
import sqlite3
from pathlib import Path
import pandas as pd
from scipy import stats

ROOT = Path(__file__).resolve().parent.parent
DB_PATH = ROOT / "data" / "olist.db"
SQL_PATH = ROOT / "sql" / "02_analysis.sql"
EXPORT_DIR = ROOT / "sheets_exports"
EXPORT_DIR.mkdir(exist_ok=True)


def main():
    conn = sqlite3.connect(DB_PATH)
    conn.executescript(SQL_PATH.read_text())

    # --- Pull the order-level fact table for stats work ---
    facts = pd.read_sql(
        "SELECT DISTINCT order_id, is_late, review_score "
        "FROM order_delivery_facts WHERE review_score IS NOT NULL",
        conn,
    )

    # Point-biserial correlation: is_late (binary) vs review_score (continuous)
    corr, p_value = stats.pointbiserialr(facts["is_late"], facts["review_score"])
    print(f"Orders analysed: {len(facts):,}")
    print(f"Point-biserial correlation (late vs review score): r = {corr:.3f}, p = {p_value:.2e}")

    # Independent two-sample t-test: do late orders get meaningfully worse scores?
    late_scores = facts.loc[facts["is_late"] == 1, "review_score"]
    ontime_scores = facts.loc[facts["is_late"] == 0, "review_score"]
    t_stat, t_p = stats.ttest_ind(late_scores, ontime_scores, equal_var=False)
    print(f"t-test (late vs on-time review scores): t = {t_stat:.2f}, p = {t_p:.2e}")
    print(f"Mean review score — late: {late_scores.mean():.2f}, on-time: {ontime_scores.mean():.2f}")

    # --- Export clean summary tables for Google Sheets ---
    category_df = pd.read_sql("SELECT * FROM late_rate_by_category", conn)
    state_df = pd.read_sql("SELECT * FROM late_rate_by_state", conn)
    lateness_df = pd.read_sql("SELECT * FROM review_score_by_lateness", conn)

    category_df.to_csv(EXPORT_DIR / "late_rate_by_category.csv", index=False)
    state_df.to_csv(EXPORT_DIR / "late_rate_by_state.csv", index=False)
    lateness_df.to_csv(EXPORT_DIR / "review_score_by_lateness.csv", index=False)

    stats_summary = pd.DataFrame([{
        "orders_analysed": len(facts),
        "point_biserial_r": round(corr, 3),
        "correlation_p_value": p_value,
        "t_statistic": round(t_stat, 2),
        "t_test_p_value": t_p,
        "avg_score_late": round(late_scores.mean(), 2),
        "avg_score_on_time": round(ontime_scores.mean(), 2),
    }])
    stats_summary.to_csv(EXPORT_DIR / "correlation_stats_summary.csv", index=False)

    print(f"\nExported summary CSVs to: {EXPORT_DIR}")
    for f in sorted(EXPORT_DIR.glob("*.csv")):
        print(f"  - {f.name}")

    conn.close()


if __name__ == "__main__":
    main()
