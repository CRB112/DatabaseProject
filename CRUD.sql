use idbproject;

INSERT INTO department(dept_name, building, budget) 
VALUES
    ("Computer Science", "Carl", 1000000),
    ("Biology", "Rick", 1250000),
    ("Music", "Performance Center", 900000),
    ("Physics", "Smith", 1333000),
    ("Art", "Louve", 650000);

INSERT INTO instructor(ID, name, salary, dept_name)
VALUES
    (12345, "Johnson", 90000, "Computer Science"),
    (14837, "Smith", 100000, "Music"),
    (59282, "Roberts", 120000, "Biology"),
    (12225, "Johnson", 90000, "Computer Science"),
    (15245, 'Johnson', 90000, 'Computer Science'),
    (10946, 'Davis', 85000, 'Biology'),
    (17547, 'Lee', 78000, 'Music'),
    (12125, 'Adams', 82000, 'Art'),
    (55559, 'Johnson', 95000, 'Physics'),
    (12353, 'Green', 80000, 'Art');

INSERT INTO student(ID, name, tot_credits, advisor_id) 
VALUES
    (19284, "Timmy", 10, 12345),
    (19285, "Tommy", 10, 12345),
    (12950, "Billy", 56, 17547),
    (46703, "Sam", 98, 12125),
    (11111, "Carl", 61, 14837),
    (12589, "Bob", 71, 15245),
    (10294, "James", 19, 12353),
    (10592, "Mort", 119, 10946),
    (26092, "Bort", 1, 12345),
    (61486, "Boris", 44, 10946),
    (12629, "Andy", 89, 59282);

INSERT INTO classroom(room, building, capacity)
VALUES
    (246, "Carl", 30),
    (101, "Rick", 28),
    (190, "Performance Center", 120),
    (344, "Smith", 45),
    (12, "Louve", 50),
    (9999, "Carl", 99),
    (222, "Smith", 100);

INSERT INTO time_slot(time_slot_id, day, start_hr, start_min, end_hr, end_min)
VALUES
    ("A", "M", 9, 30, 11, 00),
    ("B", "M", 12, 00, 1, 30),
    ("C", "T", 9, 15, 10, 45),
    ("D", "T", 12, 30, 2, 00),
    ("E", "W", 9, 30, 11, 00),
    ("F", "W", 12, 00, 1, 30),
    ("G", "H", 9, 15, 10, 45),
    ("H", "H", 11, 30, 12, 30),
    ("I", "F", 9, 00, 10, 15);

INSERT INTO course(course_id, title, dept_name, credits, prereq) 
VALUES
    ("CS-101", "Computer Science A", "Computer Science", 3, DEFAULT),
    ("BIO-101", "Intro to Biology", "Biology", 3, DEFAULT),
    ("PHY-101", "Intro to Physics", "Physics", 3, DEFAULT),
    ("MUS-111", "Modern Music", "Music", 2, DEFAULT),
    ("CS-102", "Computer Science A Lab", "Computer Science", 3, DEFAULT),
    ("BIO-111", "Oceanography", "Biology", 2, DEFAULT),
    ("PHY-108", "Physics of Pianos", "Physics", 4, DEFAULT),
    ("ART-111", "Art 1", "Art", 3, DEFAULT),
    ("CS-333", "Intro to Databases", "Computer Science", 3, "CS-101"),
    ("BIO-311", "Botany", "Biology", 3, "BIO-111"),
    ("PHY-421", "Quantum Physics", "Physics", 4, "PHY-101"),
    ("BIO-401", "All About Frogs", "Biology", 4, "BIO-311");

INSERT INTO section (course_id, sec_id, semester, year, building, room_number, time_slot_id, teacher)
VALUES
    ("CS-101", 1, "Fall", 2025, "Carl", 246, "A", 12345),  
    ("CS-101", 2, "Spring", 2025, "Carl", 9999, "B", 12225),  
    ("CS-102", 1, "Fall", 2025, "Carl", 246, "C", 15245),    
    ("CS-102", 2, "Spring", 2025, "Carl", 9999, "D", 12345);  
    ("BIO-101", 1, "Fall", 2025, "Rick", 101, "E", 59282),    
    ("BIO-101", 2, "Spring", 2025, "Rick", 101, "F", 10946),   
    ("BIO-111", 1, "Fall", 2025, "Rick", 101, "C", 59282),    
    ("BIO-111", 2, "Spring", 2025, "Rick", 101, "D", 15245), 
    ("PHY-101", 1, "Fall", 2025, "Smith", 344, "E", 55559),    
    ("PHY-101", 2, "Spring", 2025, "Smith", 344, "F", 14837),   
    ("PHY-108", 1, "Fall", 2025, "Smith", 344, "G", 15245),    
    ("PHY-108", 2, "Spring", 2025, "Smith", 344, "H", 12125),  
    ("MUS-111", 1, "Fall", 2025, "Performance Center", 190, "I", 14837), 
    ("MUS-111", 2, "Spring", 2025, "Performance Center", 190, "A", 17547),
    ("ART-121", 1, "Fall", 2025, "Louve", 12, "E", 12125),   
    ("ART-121", 2, "Spring", 2025, "Louve", 12, "F", 12353); 

INSERT INTO takes(ID, course_id, sec_id, semester, year, grade)
VALUES
    (19284, "CS-101", 1, "Fall", 2025, "A"),  
    (19285, "CS-101", 2, "Spring", 2025, "B"),  
    (12950, "BIO-101", 1, "Fall", 2025, "C"),    
    (46703, "BIO-111", 1, "Fall", 2025, "B"),  
    (11111, "PHY-101", 1, "Fall", 2025, "A"),  
    (12589, "CS-102", 1, "Fall", 2025, "A"),  
    (10294, "PHY-108", 1, "Fall", 2025, "C"),  
    (10592, "MUS-111", 1, "Fall", 2025, "B");