const router = require("express").Router();
const validator = require("../../middlewares/validate");
const validations = require("./tasks.validations");
const controller = require("./tasks.controller");


router.post("/", validator(validations.addTask), controller.addTask);
router.get("/", validator(validations.getTasks), controller.getTasks);
router.patch("/:id/toggle", validator(validations.toggleTask), controller.toggleTask);



module.exports = router;
