-- name: UpsertCompletion :one
INSERT INTO task_completions (user_id, task_id, campaign_id, status, points_earned, proof)
VALUES ($1, $2, $3, $4, $5, $6)
ON CONFLICT (user_id, task_id) DO UPDATE
    SET status = $4, points_earned = $5, proof = $6, completed_at = NOW()
RETURNING *;

-- name: GetCompletion :one
SELECT * FROM task_completions
WHERE user_id = $1 AND task_id = $2;

-- name: ListCompletionsByUserAndCampaign :many
SELECT tc.*, t.points AS task_points, t.is_required, t.title AS task_title
FROM task_completions tc
JOIN tasks t ON t.id = tc.task_id
WHERE tc.campaign_id = $1 AND tc.user_id = $2;

-- name: GetUserPointsForCampaign :one
SELECT COALESCE(SUM(points_earned), 0)::INT AS total_points
FROM task_completions
WHERE campaign_id = $1 AND user_id = $2 AND status = 'verified';

-- name: GetCompletionSpeedSeconds :one
SELECT EXTRACT(EPOCH FROM (MAX(completed_at) - MIN(completed_at)))::INT AS seconds
FROM task_completions
WHERE campaign_id = $1 AND user_id = $2 AND status = 'verified';

-- name: CountVerifiedTasksForUser :one
SELECT COUNT(*) FROM task_completions
WHERE campaign_id = $1 AND user_id = $2 AND status = 'verified';

-- name: ListCampaignLeaderboard :many
SELECT user_id, SUM(points_earned)::INT AS total_points
FROM task_completions
WHERE campaign_id = $1 AND status = 'verified'
GROUP BY user_id
ORDER BY total_points DESC
LIMIT $2 OFFSET $3;