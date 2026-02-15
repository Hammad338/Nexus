# 🚀 NEXUS - Quick Start Guide

Get up and running with NEXUS in 2 minutes!

## Option 1: Simple Start (Recommended)

Just want to try it out? No installation needed!

1. Open `frontend/public/index.html` in your browser
2. Start creating tasks!

That's it! Everything runs in your browser with LocalStorage.

## Option 2: With Backend (For Developers)

Want the full experience with API integration?

### Step 1: Install Dependencies
```bash
npm install
```

### Step 2: Configure Environment
```bash
cp .env.example .env
# Edit .env if needed (defaults work fine for local dev)
```

### Step 3: Start Development Server
```bash
npm run dev
```

### Step 4: Open in Browser
Visit: `http://localhost:3000`

## What You Get

### ✨ Features
- Drag-and-drop kanban board
- Task priorities and tags
- Real-time statistics
- Particle effects background
- Export/Import functionality
- Dark cyberpunk theme

### 🎯 Quick Actions
- **Create Task**: Click "+ NEW TASK" button
- **Move Task**: Drag cards between columns
- **Edit Task**: Click on any task card
- **Delete Task**: Edit task → Delete button
- **Export Data**: Click 💾 icon in header
- **Import Data**: Click 📥 icon in header

## Project Structure

```
nexus-project/
├── frontend/
│   └── public/
│       └── index.html      ← Start here!
├── backend/
│   └── server.js           ← API server (optional)
├── docs/                   ← Full documentation
└── database/               ← PostgreSQL schema (future)
```

## Tips & Tricks

### Keyboard Shortcuts (Future Feature)
- `N` - New task
- `Esc` - Close modal
- `⌘/Ctrl + K` - Search

### Task Organization
- Use **tags** for categories (frontend, backend, urgent)
- Set **priorities** to highlight important work
- Use **descriptions** for task details and requirements

### Data Management
- Data saves automatically to LocalStorage
- Export regularly to backup your tasks
- Import to restore or merge tasks

## Customization

### Change Theme Colors
Edit CSS variables in `frontend/public/index.html`:

```css
:root {
    --primary: #00ff88;      /* Change to your color */
    --secondary: #00d4ff;
    --tertiary: #ff00ff;
}
```

### Adjust Particle Count
Find this line in the JavaScript:

```javascript
const particleCount = 50;  // Lower for better performance
```

## Troubleshooting

### Tasks not saving?
- Check browser console for errors
- Make sure LocalStorage is enabled
- Try clearing browser cache

### Animations laggy?
- Reduce particle count in code
- Close other browser tabs
- Update graphics drivers

### Port already in use?
```bash
# Change port in .env file
PORT=3001
```

## Next Steps

1. **Read the full README**: See `README.md` for complete details
2. **Check API docs**: See `docs/API.md` for backend integration
3. **View architecture**: See `docs/ARCHITECTURE.md` for system design
4. **Contribute**: See `docs/CONTRIBUTING.md` to contribute

## Need Help?

- 📖 Check documentation in `/docs`
- 🐛 Report bugs on GitHub Issues
- 💬 Ask questions in Discussions
- ✉️ Contact: your-email@example.com

## Share Your Feedback!

Love NEXUS? Star the repo! ⭐
Found a bug? Open an issue! 🐛
Have ideas? Create a discussion! 💡

---

**Built with ❤️ by Hammad**

Ready to manage projects like a pro? Let's go! 🚀
