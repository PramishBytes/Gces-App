-- Tracks migrations in Django
CREATE TABLE IF NOT EXISTS django_migrations (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    app VARCHAR(255) NOT NULL, 
    name VARCHAR(255) NOT NULL, 
    applied DATETIME NOT NULL
);

-- Tracks auto-increment sequences
CREATE TABLE sqlite_sequence(name, seq);

-- Manages content types in Django
CREATE TABLE IF NOT EXISTS django_content_type (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    app_label VARCHAR(100) NOT NULL, 
    model VARCHAR(100) NOT NULL
);

-- Stores group permissions
CREATE TABLE IF NOT EXISTS auth_group_permissions (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    group_id INTEGER NOT NULL REFERENCES auth_group(id), 
    permission_id INTEGER NOT NULL REFERENCES auth_permission(id)
);

-- Stores permissions
CREATE TABLE IF NOT EXISTS auth_permission (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    content_type_id INTEGER NOT NULL REFERENCES django_content_type(id), 
    codename VARCHAR(100) NOT NULL, 
    name VARCHAR(255) NOT NULL
);

-- Stores user groups
CREATE TABLE IF NOT EXISTS auth_group (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    name VARCHAR(150) NOT NULL UNIQUE
);

-- Custom user details
CREATE TABLE IF NOT EXISTS main_app_customuser (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    password VARCHAR(128) NOT NULL, 
    email VARCHAR(254) NOT NULL UNIQUE, 
    first_name VARCHAR(150) NOT NULL, 
    last_name VARCHAR(150) NOT NULL, 
    user_type VARCHAR(1) NOT NULL, 
    gender VARCHAR(1) NOT NULL, 
    is_superuser BOOL NOT NULL, 
    is_staff BOOL NOT NULL, 
    is_active BOOL NOT NULL, 
    date_joined DATETIME NOT NULL, 
    last_login DATETIME NULL
);

-- Link custom users to groups
CREATE TABLE IF NOT EXISTS main_app_customuser_groups (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    customuser_id INTEGER NOT NULL REFERENCES main_app_customuser(id), 
    group_id INTEGER NOT NULL REFERENCES auth_group(id)
);

-- Store courses
CREATE TABLE IF NOT EXISTS main_app_course (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    name VARCHAR(120) NOT NULL, 
    created_at DATETIME NOT NULL, 
    updated_at DATETIME NOT NULL
);

-- Store sessions
CREATE TABLE IF NOT EXISTS main_app_session (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    start_year DATE NOT NULL, 
    end_year DATE NOT NULL
);

-- Staff table linked to custom users and courses
CREATE TABLE IF NOT EXISTS main_app_staff (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    admin_id INTEGER NOT NULL UNIQUE REFERENCES main_app_customuser(id), 
    course_id INTEGER REFERENCES main_app_course(id)
);

-- Student table linked to custom users and courses
CREATE TABLE IF NOT EXISTS main_app_student (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    admin_id INTEGER NOT NULL UNIQUE REFERENCES main_app_customuser(id), 
    course_id INTEGER REFERENCES main_app_course(id), 
    session_id INTEGER REFERENCES main_app_session(id)
);

-- Subjects table
CREATE TABLE IF NOT EXISTS main_app_subject (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    name VARCHAR(120) NOT NULL, 
    course_id INTEGER NOT NULL REFERENCES main_app_course(id), 
    staff_id INTEGER NOT NULL REFERENCES main_app_staff(id)
);

-- Track student results
CREATE TABLE IF NOT EXISTS main_app_studentresult (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    test REAL NOT NULL, 
    exam REAL NOT NULL, 
    student_id INTEGER NOT NULL REFERENCES main_app_student(id), 
    subject_id INTEGER NOT NULL REFERENCES main_app_subject(id)
);

-- Notifications for students
CREATE TABLE IF NOT EXISTS main_app_notificationstudent (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    message TEXT NOT NULL, 
    student_id INTEGER NOT NULL REFERENCES main_app_student(id)
);

-- Notifications for staff
CREATE TABLE IF NOT EXISTS main_app_notificationstaff (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    message TEXT NOT NULL, 
    staff_id INTEGER NOT NULL REFERENCES main_app_staff(id)
);

-- Leave report for students
CREATE TABLE IF NOT EXISTS main_app_leavereportstudent (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    date VARCHAR(60) NOT NULL, 
    message TEXT NOT NULL, 
    status SMALLINT NOT NULL, 
    student_id INTEGER NOT NULL REFERENCES main_app_student(id)
);

-- Leave report for staff
CREATE TABLE IF NOT EXISTS main_app_leavereportstaff (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    date VARCHAR(60) NOT NULL, 
    message TEXT NOT NULL, 
    status SMALLINT NOT NULL, 
    staff_id INTEGER NOT NULL REFERENCES main_app_staff(id)
);

-- Attendance report linked to students and attendance
CREATE TABLE IF NOT EXISTS main_app_attendancereport (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    status BOOL NOT NULL, 
    student_id INTEGER NOT NULL REFERENCES main_app_student(id), 
    attendance_id INTEGER NOT NULL REFERENCES main_app_attendance(id)
);

-- Attendance table linked to subjects and sessions
CREATE TABLE IF NOT EXISTS main_app_attendance (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    date DATE NOT NULL, 
    subject_id INTEGER NOT NULL REFERENCES main_app_subject(id), 
    session_id INTEGER NOT NULL REFERENCES main_app_session(id)
);
