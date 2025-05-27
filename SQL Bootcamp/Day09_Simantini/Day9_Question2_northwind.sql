/* 2.  
	Create stored procedure  using IN and INOUT parameters to assign tasks to employees
 	Parameters:
				IN p_employee_id INT,
				IN p_task_name VARCHAR(50),
				INOUT p_task_count INT DEFAULT 0
 
	·Inside Logic: Create table employee_tasks: */
CREATE OR REPLACE PROCEDURE assign_task(
    IN p_employee_id INT,
    IN p_task_name VARCHAR(50),
    INOUT p_task_count INT DEFAULT 0
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Create the employee_tasks table if it does not exist
    CREATE TABLE IF NOT EXISTS employee_tasks (
        task_id SERIAL PRIMARY KEY,
        employee_id INT,
        task_name VARCHAR(50),
        assigned_date DATE DEFAULT CURRENT_DATE
    );
    
    -- Insert the new task into the employee_tasks table
    INSERT INTO employee_tasks (employee_id, task_name)
    VALUES (p_employee_id, p_task_name);
    
    -- Count the total number of tasks assigned to the employee
    SELECT COUNT(*) 
	INTO p_task_count
    FROM employee_tasks
    WHERE employee_id = p_employee_id;
    
    -- Raise a NOTICE message with the task details
    RAISE NOTICE 'Task "%" assigned to employee %. Total tasks: %',
        p_task_name, p_employee_id, p_task_count;
END;
$$;

 
-- After creating stored procedure test by calling  it:
CALL assign_task(1, 'Review Reports');
 
