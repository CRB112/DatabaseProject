use IDBProject;
-- CREATE
    -- Add new instructor
    INSERT INTO instructor(ID, name, dept_name, salary)
    VALUES
        (10000, "Stark", "Physics", 100000)
    --Add new student
    INSERT INTO student(ID, name, tot_credits, advisor_id)
    VALUES
        (10000, "Stark", 25, 10000)
    --Add new section
    INSERT INTO section(course_id, sec_id, semester, year, building, room_number, time_slot_id, teacher)
    VALUES
        ('BIO-101', 1, 'Spring', 2025, 'Rick', 101, 'E', 10000)
-- READ

-- UPATE

-- DESTROY