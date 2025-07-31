-- Cleanup duplicate doctors and normalize data
-- Version: 4.0
-- Description: Cleanup duplicate doctor names and normalize data

-- First, let's see what duplicates we have
-- This will help identify the issues

-- Clean up duplicate doctor names in doctor_schedule
-- Remove extra spaces and normalize names
UPDATE doctor_schedule
SET name = TRIM(REPLACE(REPLACE(name, '  ', ' '), ' ,', ','))
WHERE name LIKE '%  %' OR name LIKE '%, %';

-- Fix specific known duplicates
UPDATE doctor_schedule
SET name = 'dr. Hetty Wati Napitupulu, Sp.A'
WHERE name = 'dr. Hetty Wati Napitupulu, SpA';

-- Remove exact duplicates from doctor_schedule
DELETE ds1 FROM doctor_schedule ds1
INNER JOIN doctor_schedule ds2
WHERE ds1.id > ds2.id
AND ds1.name = ds2.name
AND ds1.specialization = ds2.specialization
AND ds1.day = ds2.day
AND ds1.start_time = ds2.start_time
AND ds1.end_time = ds2.end_time;

-- Update doctor table to remove duplicates
DELETE d1 FROM doctor d1
INNER JOIN doctor d2
WHERE d1.id > d2.id
AND d1.name = d2.name
AND d1.specialization = d2.specialization;

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_doctor_schedule_name ON doctor_schedule(name);
CREATE INDEX IF NOT EXISTS idx_doctor_schedule_day ON doctor_schedule(day);
CREATE INDEX IF NOT EXISTS idx_appointments_doctor_id ON appointments(doctor_id);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON appointments(appointment_date);
CREATE INDEX IF NOT EXISTS idx_reviews_doctor_id ON reviews(doctor_id);
CREATE INDEX IF NOT EXISTS idx_news_status ON news(status);
CREATE INDEX IF NOT EXISTS idx_news_date ON news(date);
