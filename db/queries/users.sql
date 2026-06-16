-- name: CreateUser :one
INSERT INTO users (wallet_address, ens_name, display_name, avatar_url)
VALUES ($1, $2, $3, $4)
ON CONFLICT (wallet_address) DO UPDATE
SET last_seen = NOW()
RETURNING *;

-- name: GetUserByID :one
SELECT * FROM users WHERE id = $1;

-- name: GetUserByWallet :one
SELECT * FROM users WHERE wallet_address = $1;

-- name: UpdateUserProfile :one
UPDATE users
SET display_name = $2, avatar_url = $3, ens_name = $4, updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: UpsertTwitter :one
UPDATE users
SET twitter_id = $2, twitter_handle = $3, updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: UpsertDiscord :one
UPDATE users
SET discord_id = $2, discord_handle = $3, discord_token = $4, updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: TouchLastSeen :exec
UPDATE users SET last_seen = NOW() WHERE id = $1;