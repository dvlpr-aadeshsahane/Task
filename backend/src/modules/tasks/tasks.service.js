const reposiory = require("./tasks.repository");
const AppError = require("../../utils/app_error");



async function getAllTasks(filters) {
    return await reposiory.getTasks(filters);
}


async function addNewTask(data) {
    return await reposiory.addNewTask(data);
}

async function toggleTask(id) {
    const task = await reposiory.toggleTask(id);

    if (!task) {
        throw new AppError("Task not found", 404);
    }

    return task;
}


module.exports = {
    getAllTasks, addNewTask, toggleTask
}
