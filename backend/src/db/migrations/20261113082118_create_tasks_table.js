/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = async function (knex) {
    await knex.schema.createTable("tasks", (table) => {
        table.uuid("id").primary().defaultTo(knex.fn.uuid());

        table.string("title", 255).notNullable();

        table.text("description").nullable();

        table.date("due_date").nullable();

        table

            .enu("priority", ["low", "medium", "high"], {

                useNative: false,

            })

            .notNullable()

            .defaultTo("medium");

        table.enu("assignedId", ["aarav", "priya", "rohan"]);

        table.boolean("completed").notNullable().defaultTo(false);

        table.timestamps(true, true);


        table.index("due_date");

        table.index("completed");

    })
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = async function (knex) {

};
