-- name: InsertAnalyticsSnapshot :one
INSERT INTO campaign_analytics_snapshots (
    campaign_id, participant_count, task_completion_rate,
    sybil_flagged_count, claim_rate, tokens_claimed
)
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING *;

-- name: GetLatestSnapshot :one
SELECT * FROM campaign_analytics_snapshots
WHERE campaign_id = $1
ORDER BY snapshot_at DESC
LIMIT 1;

-- name: ListSnapshotsByCampaign :many
SELECT * FROM campaign_analytics_snapshots
WHERE campaign_id = $1
ORDER BY snapshot_at ASC;

-- name: ListSnapshotsInRange :many
SELECT * FROM campaign_analytics_snapshots
WHERE campaign_id = $1
  AND snapshot_at BETWEEN $2 AND $3
ORDER BY snapshot_at ASC;