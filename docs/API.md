# NEXUS API Documentation

Base URL: `http://localhost:3000/api`

## Overview

The NEXUS API provides a RESTful interface for managing tasks in the project management system. All responses are in JSON format.

## Response Format

### Success Response
```json
{
  "success": true,
  "data": { ... },
  "count": 10  // Optional, for list endpoints
}
```

### Error Response
```json
{
  "success": false,
  "error": "Error message",
  "message": "Detailed error description"  // Development only
}
```

## Endpoints

### Tasks

#### Get All Tasks
```
GET /api/tasks
```

**Query Parameters:**
- `status` (optional): Filter by status (`todo`, `in-progress`, `review`, `completed`)
- `priority` (optional): Filter by priority (`low`, `medium`, `high`)
- `tags` (optional): Comma-separated list of tags

**Example:**
```bash
curl http://localhost:3000/api/tasks?status=in-progress&priority=high
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "1",
      "title": "Design System Architecture",
      "description": "Create comprehensive design system",
      "status": "in-progress",
      "priority": "high",
      "tags": ["design", "frontend"],
      "createdAt": "2024-01-15T10:30:00.000Z",
      "updatedAt": "2024-01-15T10:30:00.000Z"
    }
  ],
  "count": 1
}
```

---

#### Get Single Task
```
GET /api/tasks/:id
```

**Example:**
```bash
curl http://localhost:3000/api/tasks/1
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "1",
    "title": "Design System Architecture",
    "description": "Create comprehensive design system",
    "status": "in-progress",
    "priority": "high",
    "tags": ["design", "frontend"],
    "createdAt": "2024-01-15T10:30:00.000Z",
    "updatedAt": "2024-01-15T10:30:00.000Z"
  }
}
```

---

#### Create Task
```
POST /api/tasks
```

**Request Body:**
```json
{
  "title": "New Task",
  "description": "Task description",
  "status": "todo",
  "priority": "medium",
  "tags": ["backend", "api"]
}
```

**Example:**
```bash
curl -X POST http://localhost:3000/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Implement Authentication",
    "description": "Add JWT-based authentication",
    "status": "todo",
    "priority": "high",
    "tags": ["security", "backend"]
  }'
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "123456789",
    "title": "Implement Authentication",
    "description": "Add JWT-based authentication",
    "status": "todo",
    "priority": "high",
    "tags": ["security", "backend"],
    "createdAt": "2024-01-15T10:35:00.000Z",
    "updatedAt": "2024-01-15T10:35:00.000Z"
  }
}
```

---

#### Update Task
```
PUT /api/tasks/:id
```

**Request Body:** (All fields optional)
```json
{
  "title": "Updated Title",
  "description": "Updated description",
  "status": "in-progress",
  "priority": "high",
  "tags": ["updated", "tags"]
}
```

**Example:**
```bash
curl -X PUT http://localhost:3000/api/tasks/1 \
  -H "Content-Type: application/json" \
  -d '{
    "status": "completed"
  }'
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "1",
    "title": "Design System Architecture",
    "status": "completed",
    "updatedAt": "2024-01-15T11:00:00.000Z"
  }
}
```

---

#### Delete Task
```
DELETE /api/tasks/:id
```

**Example:**
```bash
curl -X DELETE http://localhost:3000/api/tasks/1
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "1",
    "title": "Design System Architecture"
  }
}
```

---

### Statistics

#### Get Statistics
```
GET /api/stats
```

**Example:**
```bash
curl http://localhost:3000/api/stats
```

**Response:**
```json
{
  "success": true,
  "data": {
    "total": 10,
    "byStatus": {
      "todo": 3,
      "in-progress": 4,
      "review": 2,
      "completed": 1
    },
    "byPriority": {
      "high": 5,
      "medium": 3,
      "low": 2
    },
    "completionRate": 10
  }
}
```

---

### Bulk Operations

#### Bulk Actions
```
POST /api/tasks/bulk
```

**Request Body:**
```json
{
  "action": "delete",  // or "archive"
  "taskIds": ["1", "2", "3"]
}
```

**Example:**
```bash
curl -X POST http://localhost:3000/api/tasks/bulk \
  -H "Content-Type: application/json" \
  -d '{
    "action": "delete",
    "taskIds": ["1", "2"]
  }'
```

**Response:**
```json
{
  "success": true,
  "data": {
    "action": "delete",
    "affected": 2,
    "tasks": [...]
  }
}
```

---

### Health Check

#### System Health
```
GET /api/health
```

**Example:**
```bash
curl http://localhost:3000/api/health
```

**Response:**
```json
{
  "success": true,
  "status": "operational",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "uptime": 3600
}
```

---

## Status Codes

- `200` - Success
- `201` - Created
- `400` - Bad Request
- `404` - Not Found
- `500` - Internal Server Error

## Data Types

### Task Object
```typescript
{
  id: string;
  title: string;
  description: string;
  status: 'todo' | 'in-progress' | 'review' | 'completed';
  priority: 'low' | 'medium' | 'high';
  tags: string[];
  createdAt: string;  // ISO 8601 format
  updatedAt: string;  // ISO 8601 format
}
```

## Rate Limiting

Currently no rate limiting is implemented. In production, consider:
- 100 requests per minute per IP
- 1000 requests per hour per user

## Authentication

Authentication is not currently implemented. Future versions will support:
- JWT tokens
- OAuth2
- API keys

## CORS

CORS is enabled for all origins in development. In production, configure allowed origins in the `.env` file.

## Error Handling

All errors follow a consistent format:

```json
{
  "success": false,
  "error": "Brief error description",
  "message": "Detailed error message (dev only)"
}
```

Common error codes:
- `TASK_NOT_FOUND` - Task with given ID doesn't exist
- `VALIDATION_ERROR` - Request validation failed
- `INVALID_STATUS` - Invalid status value
- `INVALID_PRIORITY` - Invalid priority value

## Examples

### Complete Workflow Example

```javascript
// 1. Create a task
const response1 = await fetch('http://localhost:3000/api/tasks', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    title: 'Build API',
    description: 'Create REST API',
    status: 'todo',
    priority: 'high',
    tags: ['backend']
  })
});
const { data: newTask } = await response1.json();

// 2. Update task status
const response2 = await fetch(`http://localhost:3000/api/tasks/${newTask.id}`, {
  method: 'PUT',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    status: 'in-progress'
  })
});

// 3. Get all in-progress tasks
const response3 = await fetch('http://localhost:3000/api/tasks?status=in-progress');
const { data: tasks } = await response3.json();

// 4. Get statistics
const response4 = await fetch('http://localhost:3000/api/stats');
const { data: stats } = await response4.json();
```

---

## Changelog

### v1.0.0 (Current)
- Initial API release
- Basic CRUD operations
- Filtering and statistics
- Bulk operations

### Future Versions
- v1.1.0: Authentication & Authorization
- v1.2.0: WebSocket support for real-time updates
- v1.3.0: File upload support
- v2.0.0: Database integration (PostgreSQL)
