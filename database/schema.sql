-- NEXUS Database Schema
-- PostgreSQL 14+

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    avatar_url TEXT,
    role VARCHAR(50) DEFAULT 'member' CHECK (role IN ('admin', 'member', 'viewer')),
    is_active BOOLEAN DEFAULT true,
    last_login_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Projects table
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    color VARCHAR(7), -- Hex color
    owner_id UUID REFERENCES users(id) ON DELETE SET NULL,
    is_archived BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Project members
CREATE TABLE project_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(50) DEFAULT 'member' CHECK (role IN ('owner', 'admin', 'member', 'viewer')),
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(project_id, user_id)
);

-- Tasks table
CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'todo' CHECK (status IN ('todo', 'in-progress', 'review', 'completed')),
    priority VARCHAR(50) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high')),
    assignee_id UUID REFERENCES users(id) ON DELETE SET NULL,
    reporter_id UUID REFERENCES users(id) ON DELETE SET NULL,
    due_date TIMESTAMP WITH TIME ZONE,
    estimated_hours DECIMAL(10, 2),
    actual_hours DECIMAL(10, 2),
    position INTEGER DEFAULT 0, -- For ordering within columns
    is_archived BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tags table
CREATE TABLE tags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    color VARCHAR(7), -- Hex color
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(project_id, name)
);

-- Task tags (many-to-many)
CREATE TABLE task_tags (
    task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
    tag_id UUID REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (task_id, tag_id)
);

-- Comments table
CREATE TABLE comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    is_edited BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Attachments table
CREATE TABLE attachments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    filename VARCHAR(255) NOT NULL,
    file_url TEXT NOT NULL,
    file_type VARCHAR(100),
    file_size BIGINT, -- bytes
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Activity log
CREATE TABLE activities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    action VARCHAR(100) NOT NULL, -- 'task_created', 'task_updated', etc.
    entity_type VARCHAR(50), -- 'task', 'comment', etc.
    entity_id UUID,
    metadata JSONB, -- Additional data about the action
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Notifications table
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(100) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT,
    link TEXT,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_tasks_project_id ON tasks(project_id);
CREATE INDEX idx_tasks_assignee_id ON tasks(assignee_id);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_priority ON tasks(priority);
CREATE INDEX idx_tasks_due_date ON tasks(due_date);
CREATE INDEX idx_comments_task_id ON comments(task_id);
CREATE INDEX idx_activities_project_id ON activities(project_id);
CREATE INDEX idx_activities_created_at ON activities(created_at DESC);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);

-- Full-text search index
CREATE INDEX idx_tasks_search ON tasks USING GIN (
    to_tsvector('english', title || ' ' || COALESCE(description, ''))
);

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply trigger to relevant tables
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON tasks
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_comments_updated_at BEFORE UPDATE ON comments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Sample data (for development)
-- Insert demo user
INSERT INTO users (id, email, password_hash, name, role) VALUES
    ('550e8400-e29b-41d4-a716-446655440000', 'demo@nexus.dev', '$2b$10$placeholder', 'Demo User', 'admin');

-- Insert demo project
INSERT INTO projects (id, name, description, owner_id) VALUES
    ('660e8400-e29b-41d4-a716-446655440000', 'NEXUS Development', 'Main development project', '550e8400-e29b-41d4-a716-446655440000');

-- Insert demo tasks
INSERT INTO tasks (project_id, title, description, status, priority, assignee_id) VALUES
    ('660e8400-e29b-41d4-a716-446655440000', 'Design System Architecture', 'Create comprehensive design system', 'in-progress', 'high', '550e8400-e29b-41d4-a716-446655440000'),
    ('660e8400-e29b-41d4-a716-446655440000', 'API Integration Layer', 'Build robust API integration', 'todo', 'high', '550e8400-e29b-41d4-a716-446655440000'),
    ('660e8400-e29b-41d4-a716-446655440000', 'Performance Optimization', 'Optimize bundle size', 'review', 'medium', '550e8400-e29b-41d4-a716-446655440000');

-- Insert demo tags
INSERT INTO tags (project_id, name, color) VALUES
    ('660e8400-e29b-41d4-a716-446655440000', 'frontend', '#00ff88'),
    ('660e8400-e29b-41d4-a716-446655440000', 'backend', '#00d4ff'),
    ('660e8400-e29b-41d4-a716-446655440000', 'urgent', '#ff0055');

-- Useful queries

-- Get all tasks for a project with assignee and tags
CREATE OR REPLACE VIEW v_project_tasks AS
SELECT 
    t.id,
    t.title,
    t.description,
    t.status,
    t.priority,
    t.due_date,
    u.name as assignee_name,
    u.email as assignee_email,
    ARRAY_AGG(DISTINCT tag.name) as tags,
    t.created_at,
    t.updated_at
FROM tasks t
LEFT JOIN users u ON t.assignee_id = u.id
LEFT JOIN task_tags tt ON t.id = tt.task_id
LEFT JOIN tags tag ON tt.tag_id = tag.id
GROUP BY t.id, u.name, u.email;

-- Get project statistics
CREATE OR REPLACE VIEW v_project_stats AS
SELECT 
    p.id as project_id,
    p.name as project_name,
    COUNT(t.id) as total_tasks,
    COUNT(t.id) FILTER (WHERE t.status = 'todo') as todo_count,
    COUNT(t.id) FILTER (WHERE t.status = 'in-progress') as in_progress_count,
    COUNT(t.id) FILTER (WHERE t.status = 'review') as review_count,
    COUNT(t.id) FILTER (WHERE t.status = 'completed') as completed_count,
    ROUND(
        (COUNT(t.id) FILTER (WHERE t.status = 'completed')::DECIMAL / 
        NULLIF(COUNT(t.id), 0) * 100), 
        2
    ) as completion_rate,
    COUNT(t.id) FILTER (WHERE t.priority = 'high') as high_priority_count,
    COUNT(t.id) FILTER (WHERE t.due_date < CURRENT_TIMESTAMP AND t.status != 'completed') as overdue_count
FROM projects p
LEFT JOIN tasks t ON p.id = t.project_id AND t.is_archived = false
GROUP BY p.id, p.name;

-- Get user activity
CREATE OR REPLACE VIEW v_user_activity AS
SELECT 
    u.id as user_id,
    u.name,
    COUNT(DISTINCT t.id) as assigned_tasks,
    COUNT(DISTINCT c.id) as comments_count,
    COUNT(DISTINCT a.id) as activities_count,
    MAX(a.created_at) as last_activity
FROM users u
LEFT JOIN tasks t ON u.id = t.assignee_id
LEFT JOIN comments c ON u.id = c.user_id
LEFT JOIN activities a ON u.id = a.user_id
GROUP BY u.id, u.name;
