/**
 * Task Model
 * Represents a task in the NEXUS project management system
 */

class Task {
    constructor(data) {
        this.id = data.id || this.generateId();
        this.title = data.title;
        this.description = data.description || '';
        this.status = data.status || 'todo';
        this.priority = data.priority || 'medium';
        this.tags = data.tags || [];
        this.assignee = data.assignee || null;
        this.dueDate = data.dueDate || null;
        this.estimatedHours = data.estimatedHours || null;
        this.actualHours = data.actualHours || null;
        this.attachments = data.attachments || [];
        this.comments = data.comments || [];
        this.archived = data.archived || false;
        this.createdAt = data.createdAt || new Date().toISOString();
        this.updatedAt = data.updatedAt || new Date().toISOString();
    }

    generateId() {
        return `task_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    }

    validate() {
        const errors = [];

        if (!this.title || this.title.trim().length === 0) {
            errors.push('Title is required');
        }

        if (this.title && this.title.length > 200) {
            errors.push('Title must be less than 200 characters');
        }

        const validStatuses = ['todo', 'in-progress', 'review', 'completed'];
        if (!validStatuses.includes(this.status)) {
            errors.push(`Status must be one of: ${validStatuses.join(', ')}`);
        }

        const validPriorities = ['low', 'medium', 'high'];
        if (!validPriorities.includes(this.priority)) {
            errors.push(`Priority must be one of: ${validPriorities.join(', ')}`);
        }

        if (!Array.isArray(this.tags)) {
            errors.push('Tags must be an array');
        }

        return {
            valid: errors.length === 0,
            errors
        };
    }

    update(data) {
        const allowedFields = [
            'title',
            'description',
            'status',
            'priority',
            'tags',
            'assignee',
            'dueDate',
            'estimatedHours',
            'actualHours',
            'archived'
        ];

        allowedFields.forEach(field => {
            if (data.hasOwnProperty(field)) {
                this[field] = data[field];
            }
        });

        this.updatedAt = new Date().toISOString();
        return this;
    }

    addComment(comment) {
        this.comments.push({
            id: `comment_${Date.now()}`,
            text: comment.text,
            author: comment.author,
            createdAt: new Date().toISOString()
        });
        this.updatedAt = new Date().toISOString();
        return this;
    }

    addAttachment(attachment) {
        this.attachments.push({
            id: `attachment_${Date.now()}`,
            name: attachment.name,
            url: attachment.url,
            type: attachment.type,
            size: attachment.size,
            uploadedAt: new Date().toISOString()
        });
        this.updatedAt = new Date().toISOString();
        return this;
    }

    toJSON() {
        return {
            id: this.id,
            title: this.title,
            description: this.description,
            status: this.status,
            priority: this.priority,
            tags: this.tags,
            assignee: this.assignee,
            dueDate: this.dueDate,
            estimatedHours: this.estimatedHours,
            actualHours: this.actualHours,
            attachments: this.attachments,
            comments: this.comments,
            archived: this.archived,
            createdAt: this.createdAt,
            updatedAt: this.updatedAt
        };
    }

    static fromJSON(json) {
        return new Task(json);
    }

    // Utility methods
    isOverdue() {
        if (!this.dueDate) return false;
        return new Date(this.dueDate) < new Date() && this.status !== 'completed';
    }

    getAge() {
        const created = new Date(this.createdAt);
        const now = new Date();
        const diffTime = Math.abs(now - created);
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        return diffDays;
    }

    getTimeToComplete() {
        if (this.status !== 'completed') return null;
        const created = new Date(this.createdAt);
        const updated = new Date(this.updatedAt);
        const diffTime = Math.abs(updated - created);
        const diffHours = Math.ceil(diffTime / (1000 * 60 * 60));
        return diffHours;
    }
}

module.exports = Task;
