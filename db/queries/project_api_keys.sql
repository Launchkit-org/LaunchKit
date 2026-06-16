-- name: CreateAPIKey :one
INSERT INTO project_api_keys (project_id, name, key_hash, key_hint)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: GetAPIKeyByHash :one
SELECT * FROM project_api_keys
WHERE key_hash = $1 AND is_active = TRUE;

-- name: ListAPIKeysByOrg :many
SELECT * FROM project_api_keys
WHERE project_id = $1
ORDER BY created_at DESC;

-- name: RevokeAPIKey :exec
UPDATE project_api_keys
SET is_active = FALSE
WHERE id = $1 AND project_id = $2;

-- name: TouchAPIKeyUsage :exec
UPDATE project_api_keys
SET last_used_at = NOW()
WHERE id = $1;