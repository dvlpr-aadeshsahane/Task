SELECT id,
       title,
       description,
       due_date,
       priority,
       "assignedId",
       completed,
       created_at,
       updated_at
FROM public.tasks
LIMIT 1000;