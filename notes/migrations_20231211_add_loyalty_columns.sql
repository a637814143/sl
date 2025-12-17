-- 8AM Lab loyalty migration: ensure lab_users has points + membership_level
ALTER TABLE lab_users
    ADD COLUMN IF NOT EXISTS points INT NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS membership_level VARCHAR(32) NOT NULL DEFAULT 'EXPERIENCE';

-- Reset all existing customers to baseline so points start accumulating correctly
UPDATE lab_users
SET points = 0,
    membership_level = 'EXPERIENCE'
WHERE role = 'CUSTOMER';
