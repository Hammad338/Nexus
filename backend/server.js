const express = require('express');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files from frontend
app.use(express.static(path.join(__dirname, '../frontend/public')));

// In-memory database (for demo purposes)
let tasks = [
    {
        id: '1',
        title: 'Design System Architecture',
        description: 'Create comprehensive design system with reusable components',
        status: 'in-progress',
        priority: 'high',
        tags: ['design', 'frontend', 'urgent'],
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
    },
    {
        id: '2',
        title: 'API Integration Layer',
        description: 'Build robust API integration with error handling',
        status: 'todo',
        priority: 'high',
        tags: ['backend', 'api'],
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
    }
];

// API Routes

// Get all tasks
app.get('/api/tasks', (req, res) => {
    const { status, priority, tags } = req.query;
    let filteredTasks = [...tasks];

    if (status) {
        filteredTasks = filteredTasks.filter(task => task.status === status);
    }

    if (priority) {
        filteredTasks = filteredTasks.filter(task => task.priority === priority);
    }

    if (tags) {
        const tagArray = tags.split(',');
        filteredTasks = filteredTasks.filter(task => 
            task.tags.some(tag => tagArray.includes(tag))
        );
    }

    res.json({
        success: true,
        data: filteredTasks,
        count: filteredTasks.length
    });
});

// Get single task
app.get('/api/tasks/:id', (req, res) => {
    const task = tasks.find(t => t.id === req.params.id);
    
    if (!task) {
        return res.status(404).json({
            success: false,
            error: 'Task not found'
        });
    }

    res.json({
        success: true,
        data: task
    });
});

// Create task
app.post('/api/tasks', (req, res) => {
    const { title, description, status, priority, tags } = req.body;

    if (!title) {
        return res.status(400).json({
            success: false,
            error: 'Title is required'
        });
    }

    const newTask = {
        id: Date.now().toString(),
        title,
        description: description || '',
        status: status || 'todo',
        priority: priority || 'medium',
        tags: tags || [],
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
    };

    tasks.push(newTask);

    res.status(201).json({
        success: true,
        data: newTask
    });
});

// Update task
app.put('/api/tasks/:id', (req, res) => {
    const taskIndex = tasks.findIndex(t => t.id === req.params.id);

    if (taskIndex === -1) {
        return res.status(404).json({
            success: false,
            error: 'Task not found'
        });
    }

    const updatedTask = {
        ...tasks[taskIndex],
        ...req.body,
        id: req.params.id, // Prevent ID from being changed
        updatedAt: new Date().toISOString()
    };

    tasks[taskIndex] = updatedTask;

    res.json({
        success: true,
        data: updatedTask
    });
});

// Delete task
app.delete('/api/tasks/:id', (req, res) => {
    const taskIndex = tasks.findIndex(t => t.id === req.params.id);

    if (taskIndex === -1) {
        return res.status(404).json({
            success: false,
            error: 'Task not found'
        });
    }

    const deletedTask = tasks.splice(taskIndex, 1)[0];

    res.json({
        success: true,
        data: deletedTask
    });
});

// Get statistics
app.get('/api/stats', (req, res) => {
    const stats = {
        total: tasks.length,
        byStatus: {
            todo: tasks.filter(t => t.status === 'todo').length,
            'in-progress': tasks.filter(t => t.status === 'in-progress').length,
            review: tasks.filter(t => t.status === 'review').length,
            completed: tasks.filter(t => t.status === 'completed').length
        },
        byPriority: {
            high: tasks.filter(t => t.priority === 'high').length,
            medium: tasks.filter(t => t.priority === 'medium').length,
            low: tasks.filter(t => t.priority === 'low').length
        },
        completionRate: tasks.length > 0 
            ? Math.round((tasks.filter(t => t.status === 'completed').length / tasks.length) * 100)
            : 0
    };

    res.json({
        success: true,
        data: stats
    });
});

// Bulk operations
app.post('/api/tasks/bulk', (req, res) => {
    const { action, taskIds } = req.body;

    if (!action || !taskIds || !Array.isArray(taskIds)) {
        return res.status(400).json({
            success: false,
            error: 'Invalid bulk operation request'
        });
    }

    let affectedTasks = [];

    switch (action) {
        case 'delete':
            affectedTasks = tasks.filter(t => taskIds.includes(t.id));
            tasks = tasks.filter(t => !taskIds.includes(t.id));
            break;
        
        case 'archive':
            tasks = tasks.map(task => {
                if (taskIds.includes(task.id)) {
                    affectedTasks.push({ ...task, archived: true });
                    return { ...task, archived: true, updatedAt: new Date().toISOString() };
                }
                return task;
            });
            break;

        default:
            return res.status(400).json({
                success: false,
                error: 'Unknown bulk action'
            });
    }

    res.json({
        success: true,
        data: {
            action,
            affected: affectedTasks.length,
            tasks: affectedTasks
        }
    });
});

// Health check
app.get('/api/health', (req, res) => {
    res.json({
        success: true,
        status: 'operational',
        timestamp: new Date().toISOString(),
        uptime: process.uptime()
    });
});

// Fallback to frontend for client-side routing
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, '../frontend/public/index.html'));
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({
        success: false,
        error: 'Internal server error',
        message: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
});

// Start server
app.listen(PORT, () => {
    console.log(`
╔═══════════════════════════════════════╗
║                                       ║
║   🚀 NEXUS SERVER OPERATIONAL         ║
║                                       ║
║   Port: ${PORT}                          ║
║   Environment: ${process.env.NODE_ENV || 'development'}           ║
║   API: http://localhost:${PORT}/api      ║
║                                       ║
╚═══════════════════════════════════════╝
    `);
});

module.exports = app;
