const { z } = require("zod");

module.exports.getTasks = z.object({
    query: z.object({
        assignee: z.enum(["aarav", "priya", "rohan"], {
            error: "Assignee must be aarav, priya, or rohan",
        }).optional(),

        status: z.enum(["active", "completed"], {
            error: "Status must be active or completed",
        }).optional(),
    }),
});

module.exports.toggleTask = z.object({
    params: z.object({
        id: z.uuid({ error: "Task ID must be a valid UUID" }),
    }),
});

module.exports.addTask = z.object({

    body: z.object({

        title: z

            .string({ error: "Title is required" })

            .trim()

            .min(1, "Title is required")

            .max(255, "Title must not exceed 255 characters"),

        description: z

            .string()

            .trim()

            .optional()

            .nullable(),

        due_date: z

            .iso.date({

                error: "Due date must be in YYYY-MM-DD format",

            })

            .optional()

            .nullable(),

        priority: z.enum(["low", "medium", "high"], {

            error: "Priority must be low, medium, or high",

        }).default("medium"),

        assignedId: z.enum(["aarav", "priya", "rohan"], {

            error: "Assignee must be aarav, priya, or rohan",

        }),

        completed: z.boolean().default(false),

    }),

});
