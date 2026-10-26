
-- Module 2 - Assignment 2
-- Marketing Campaign Performance Analysis
-- Metrics: CPC, CPM, CTR, ROMI

-- 1. Explore the source table
SELECT
    ad_date,
    campaign_id,
    adset_id,
    spend,
    impressions,
    reach,
    clicks,
    leads,
    value,
    url_parameters,
    total
FROM public.facebook_ads_basic_daily;

-- 2. Aggregate campaign metrics by date and campaign
SELECT
    ad_date,
    campaign_id,
    SUM(spend) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(value) AS total_value,

    SUM(spend)::numeric
        / NULLIF(SUM(clicks), 0) AS cpc,

    (SUM(spend)::numeric
        / NULLIF(SUM(impressions), 0)) * 1000 AS cpm,

    (SUM(clicks)::numeric
        / NULLIF(SUM(impressions), 0)) * 100 AS ctr_percent,

    ((SUM(value) - SUM(spend))::numeric
        / NULLIF(SUM(spend), 0)) * 100 AS romi_percent

FROM public.facebook_ads_basic_daily
GROUP BY ad_date, campaign_id
ORDER BY ad_date, campaign_id;

-- 3. Bonus: Find the campaign with the highest ROMI
-- among campaigns with total spend above 500,000

SELECT
    campaign_id,
    SUM(spend) AS total_spend,
    ((SUM(value) - SUM(spend))::numeric
        / NULLIF(SUM(spend), 0)) * 100 AS romi_percent
FROM public.facebook_ads_basic_daily
GROUP BY campaign_id
HAVING SUM(spend) > 500000
ORDER BY romi_percent DESC
LIMIT 1;
