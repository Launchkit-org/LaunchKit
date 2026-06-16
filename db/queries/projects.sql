-- name: CreateProject :one
INSERT INTO projects (
    company_name, employee_count, discovery_source,
    name, slug, description, logo_url, website_url,
    twitter_handle, discord_invite_link,
    treasury_wallet, blockchain, environment,
    token_address, token_name, token_symbol
) VALUES (
    $1, $2, $3,
    $4, $5, $6, $7, $8,
    $9, $10,
    $11, $12, $13,
    $14, $15, $16
)
RETURNING *;

-- name: GetProjectByID :one
SELECT * FROM projects WHERE id = $1;

-- name: GetProjectBySlug :one
SELECT * FROM projects WHERE slug = $1;

-- name: UpdateProject :one
UPDATE projects SET
    name               = COALESCE($2, name),
    description        = COALESCE($3, description),
    logo_url           = COALESCE($4, logo_url),
    website_url        = COALESCE($5, website_url),
    twitter_handle     = COALESCE($6, twitter_handle),
    discord_invite_link = COALESCE($7, discord_invite_link),
    updated_at         = NOW()
WHERE id = $1
RETURNING *;

-- name: UpdateProjectTokenInfo :one
UPDATE projects SET
    token_address = $2,
    token_name    = $3,
    token_symbol  = $4,
    updated_at    = NOW()
WHERE id = $1
RETURNING *;