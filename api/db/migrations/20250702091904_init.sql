-- +goose Up
-- +goose StatementBegin
CREATE table temples (
  id UUID PRIMARY KEY,
  name_th TEXT NOT NULL,
  name_en TEXT NOT NULL,
  location POINT NOT NULL,
  address_th TEXT,
  address_en TEXT,
  contact_phone TEXT,
  founded_on DATE
);

CREATE TABLE users (
  id UUID PRIMARY KEY,
  username TEXT NOT NULL UNIQUE,
  image_url TEXT,
  password TEXT NOT NULL,
  email TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_accounts (
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  provider TEXT NOT NULL CHECK (provider IN ('google', 'facebook', 'github')), -- OAuth provider
  provider_user_id TEXT NOT NULL, -- external OAuth user ID
  access_token TEXT,
  refresh_token TEXT,
  token_expiry TIMESTAMP,
  PRIMARY KEY (provider, provider_user_id)
);

CREATE table temple_images (
  id UUID PRIMARY KEY,
  temple_id UUID NOT NULL REFERENCES temples(id) ON DELETE CASCADE,
  image_url TEXT NOT NULL,
  caption TEXT
);

CREATE table temple_events (
  id UUID PRIMARY KEY,
  temple_id UUID NOT NULL REFERENCES temples(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  event_start_date DATE,
  event_end_date DATE
);

CREATE table temple_staff (
  id UUID PRIMARY KEY,
  temple_id UUID NOT NULL REFERENCES temples(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  staff_name TEXT NOT NULL,
  role_id INTEGER REFERENCES staff_roles(id) ON DELETE SET NULL,
  position TEXT NOT NULL,
  contact_info TEXT
);

CREATE TABLE staff_roles (
  id SERIAL PRIMARY KEY,
  role_name TEXT UNIQUE NOT NULL
);

INSERT INTO staff_roles (id, role_name) VALUES
(1, 'Admin'),
(2, 'Monk'),
(3, 'Servant');

CREATE table temple_donations (
  id UUID PRIMARY KEY,
  temple_id UUID NOT NULL REFERENCES temples(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  temple_event_id UUID REFERENCES temple_events(id) ON DELETE SET NULL,
  donor_name TEXT,
  donation_amount DECIMAL(10, 2) NOT NULL,
  donation_date DATE NOT NULL,
  purpose TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE table temple_news (
  id UUID PRIMARY KEY,
  temple_id UUID NOT NULL REFERENCES temples(id) ON DELETE CASCADE,
  news_title TEXT NOT NULL,
  news_content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE table temple_reviews (
  id UUID PRIMARY KEY,
  temple_id UUID NOT NULL REFERENCES temples(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  title TEXT,
  description TEXT,
  rating INTEGER CHECK (review_rating >= 1 AND review_rating <= 5),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE table temple_schedules (
  id UUID PRIMARY KEY,
  temple_id UUID NOT NULL REFERENCES temples(id) ON DELETE CASCADE,
  schedule_date DATE NOT NULL,
  schedule_time TIME NOT NULL,
  activity TEXT NOT NULL
);

CREATE table temple_sponsorships (
  id UUID PRIMARY KEY,
  temple_id UUID NOT NULL REFERENCES temples(id) ON DELETE CASCADE,
  sponsor_name TEXT NOT NULL,
  sponsorship_amount DECIMAL(10, 2) NOT NULL,
  sponsorship_date DATE NOT NULL,
  purpose TEXT
);

CREATE table temple_memberships (
  id UUID PRIMARY KEY,
  temple_id UUID NOT NULL REFERENCES temples(id) ON DELETE CASCADE,
  member_name TEXT NOT NULL,
  membership_date DATE NOT NULL,
  membership_type TEXT NOT NULL
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DELETE table temples,
             users,
             temple_images,
             temple_events,
             temple_staff,
             temple_donations,
             temple_news,
             temple_reviews,
             temple_schedules,
             temple_sponsorships,
             temple_memberships;
-- +goose StatementEnd
