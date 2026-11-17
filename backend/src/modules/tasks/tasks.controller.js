const service = require("./tasks.service");
const response = require("../../core/response");



module.exports.addTask = async (req, res) => {
    const data = req.validatedData.body;
    const result = await service.addNewTask(data);
    return response.success(res, 200, "task successfully created", result);
}

module.exports.getTasks = async (req, res) => {
    const filters = req.validatedData.query;
    const result = await service.getAllTasks(filters);
    return response.success(res, 200, "task successfully get", result);
}

module.exports.toggleTask = async (req, res) => {
    const { id } = req.validatedData.params;
    const result = await service.toggleTask(id);
    return response.success(res, 200, "task successfully toggled", result);
}
