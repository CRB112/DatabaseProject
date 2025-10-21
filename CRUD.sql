

--CRUD
    -- CREATE
        -- Add new instructor
        INSERT INTO instructor(ID, name, dept_name, salary)
        VALUES
            (<ID>, <name>, <dept_name>, <salary>)
        --Add new student
        INSERT INTO student(ID, name, tot_credits, advisor_id)
        VALUES
            (<ID>, <name>, <tot_credits>, <advisor_id>)
        --Add new section
        INSERT INTO section(course_id, sec_id, semester, year, building, room_number, time_slot_id, teacher)
        VALUES
            (<course_id>, <sec_id>, <semester>, <year>, <building>, <room_number>, <time_slot_id, <instructor_id>)
    -- READ
        --Read <instructor> table
        SELECT ID, name, dept_name, salary FROM instructor
        --Read <student> table
        SELECT ID, name, tot_credits, advisor_id FROM student
        --Read <section> table
        SELECT course_id, sec_id, semester, year, building, room_number, time_slot_id, teacher FROM section
        
    -- UPDATE
        --Update <instructor> table
        UPDATE instructor
        SET ID = <NewId> | name = <name> | dept_name = <NewDept_name> | salary = <NewSalary>
        WHERE <condition>;
        --Update <student> table
        UPDATE student
        SET ID = <NewId> | name = <NewName> | tot_credits = <NewTotal_Credits> | advisor_id = <NewAdvisor_Id>
        WHERE <condition>
        --Update <section> table
        UPDATE section
        SET course_id = <NewCourse_Id> | sec_id = <NewSec_Id> | semester = <NewSemester> | year = <NewYear>
        | building = <NewBuilding> | room_number = <NewRoom_Number> | time_slot_id = <NewTimeSlotId> | teacher = <NewTeacherId>
    -- DESTROY
        --Delete from instructor
        DELETE FROM instructor
        WHERE <Condition>
        --Delete from student
        DELETE FROM student
        WHERE <Condition>
        --Delete from section
        DELETE FROM section
        WHERE <Condition>

--SPECIAL QUERIES
    --Enroll in class
    INSERT INTO takes(ID, course_id, sec_id, semester, year, grade)
    VALUES
        (<student.ID>, <section.course_id>, <section.sec_id>, <section.semester>, <section.yeat>, DEFAULT)
    --Assign instructor to class
    UPDATE section
    SET teacher = <instructor.ID>
    WHERE course_id = <selectedCourse> AND sec_id = <selectedSection> AND semester = <selectedSemester> AND year = <selectedYear>
    --Dropping a section
    DELETE FROM section
    WHERE  course_id = <selectedCourse> AND sec_id = <selectedSection> AND semester = <selectedSemester> AND year = <selectedYear>
    --Give a grade to a section
    UPDATE takes
    SET grade = <grade>
    WHERE course_id = <selectedCourse> AND sec_id = <selectedSection> AND semester = <selectedSemester> AND year = <selectedYear>