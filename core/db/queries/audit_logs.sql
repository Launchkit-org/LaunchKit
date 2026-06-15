-- name: CreateAuditLog :one
INSERT INTO audit_logs (project_id, user_id, action, entity_type, entity_id, changes, ip_address)
VALUES ($1, $2, $3, $4, $5, $6, $7)
RETURNING *;

-- name: ListAuditLogsByProject :many
SELECT al.*, u.wallet_address, u.display_name
FROM audit_logs al
LEFT JOIN users u ON u.id = al.user_id
WHERE al.project_id = $1
ORDER BY al.created_at DESC
LIMIT $2 OFFSET $3;

-- name: ListAuditLogsByEntity :many
SELECT * FROM audit_logs
WHERE project_id = $1 AND entity_type = $2 AND entity_id = $3
ORDER BY created_at DESC;