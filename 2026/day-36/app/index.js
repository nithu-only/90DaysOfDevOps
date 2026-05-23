const express = require("express");
const mongoose = require("mongoose");

const app = express();
app.use(express.json());

const PORT = process.env.PORT || 3000;
const MONGO_URI = process.env.MONGO_URI;

mongoose.connect(MONGO_URI)
.then(() => console.log("MongoDB Connected"))
.catch(err => console.log(err));

const TaskSchema = new mongoose.Schema({
    title: String
});

const Task = mongoose.model("Task", TaskSchema);

app.post("/task", async (req, res) => {
    const task = new Task({ title: req.body.title });
    await task.save();
    res.send(task);
});

app.get("/tasks", async (req, res) => {
    const tasks = await Task.find();
    res.send(tasks);
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});