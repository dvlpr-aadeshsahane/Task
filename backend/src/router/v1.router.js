const router = require("express").Router();


router.use("/tasks", require("../modules/tasks/tasks.router"));

module.exports = router;
