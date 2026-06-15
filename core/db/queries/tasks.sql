-- name: CreateTask :one
INSERT INTO tasks (campaign_id, title, description, task_type, verification_type, config, points, is_required, display_order)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
RETURNING *;

-- name: GetTask :one
SELECT * FROM tasks
WHERE id = $1 AND deleted_at IS NULL;

-- name: ListTasksByCampaign :many
SELECT * FROM tasks
WHERE campaign_id = $1 AND deleted_at IS NULL
ORDER BY display_order ASC;

-- name: CountTasksByCampaign :one
SELECT COUNT(*) FROM tasks
WHERE campaign_id = $1 AND deleted_at IS NULL;

-- name: UpdateTask :one
UPDATE tasks SET
    title             = COALESCE($2, title),   -- COALESCE : evaluates a list of arguments and returns first non NULL value
    description       = COALESCE($3, description),
    config            = COALESCE($4, config),
    points            = COALESCE($5, points),
    is_required       = COALESCE($6, is_required),
    display_order     = COALESCE($7, display_order),
    updated_at        = NOW()
WHERE id = $1 AND deleted_at IS NULL
RETURNING *;

-- name: SoftDeleteTask :exec
UPDATE tasks
SET deleted_at = NOW()
WHERE id = $1 AND campaign_id = $2;