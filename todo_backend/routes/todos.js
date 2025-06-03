const express = require('express');
const router = express.Router();
const Todo = require('../models/todo');

// GET all todos
router.get('/', async (req, res) => {
  const todos = await Todo.find();
  res.json(todos);
});

// POST new todo
router.post('/', async (req, res) => {
  const { title } = req.body;
  const newTodo = new Todo({ title });
  await newTodo.save();
  res.status(201).json(newTodo);
});

// PUT toggle complete
router.put('/:id', async (req, res) => {
  const { isCompleted } = req.body;
  const updated = await Todo.findByIdAndUpdate(
    req.params.id,
    { isCompleted },
    { new: true }
  );
  res.json(updated);
});

// DELETE a todo
router.delete('/:id', async (req, res) => {
  await Todo.findByIdAndDelete(req.params.id);
  res.json({ message: 'Todo deleted' });
});

module.exports = router;
