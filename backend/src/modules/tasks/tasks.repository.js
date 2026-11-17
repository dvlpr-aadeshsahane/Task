const { query } = require("../../config/db");

async function getTasks({ assignee, status } = {}) {
    const conditions = [];
    const values = [];

    if (assignee) {
        values.push(assignee);
        conditions.push(`"assignedId" = $${values.length}`);
    }

    if (status) {
        values.push(status === "completed");
        conditions.push(`completed = $${values.length}`);
    }

    const whereClause = conditions.length > 0
        ? ` WHERE ${conditions.join(" AND ")}`
        : "";
    const SQL = `SELECT * FROM tasks${whereClause}`;
    const result = await query(SQL, values);
    return result.rows;
}


async function addNewTask(data) {
    const SQL = 'INSERT INTO tasks (title, description, due_date, priority, "assignedId") VALUES ($1, $2, $3, $4, $5) RETURNING *';
    const result = await query(SQL, [data.title, data.description, data.due_date, data.priority, data.assignedId]);
    return result.rows[0];

}

async function toggleTask(id) {
    const SQL = `
        UPDATE tasks
        SET completed = NOT completed,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = $1
        RETURNING *
    `;
    const result = await query(SQL, [id]);
    return result.rows[0];
}

module.exports = {
    getTasks, addNewTask, toggleTask
}
