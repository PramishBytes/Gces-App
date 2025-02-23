CREATE TABLE IF NOT EXISTS "django_migrations" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "app" varchar(255) NOT NULL, "name" varchar(255) NOT NULL, "applied" datetime NOT NULL);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS "django_content_type" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "app_label" varchar(100) NOT NULL, "model" varchar(100) NOT NULL);
CREATE UNIQUE INDEX "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" ("app_label", "model");
CREATE TABLE IF NOT EXISTS "auth_group_permissions" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "group_id" integer NOT NULL REFERENCES "auth_group" ("id") DEFERRABLE INITIALLY DEFERRED, "permission_id" integer NOT NULL REFERENCES "auth_permission" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE UNIQUE INDEX "auth_group_permissions_group_id_permission_id_0cd325b0_uniq" ON "auth_group_permissions" ("group_id", "permission_id");
CREATE INDEX "auth_group_permissions_group_id_b120cbf9" ON "auth_group_permissions" ("group_id");
CREATE INDEX "auth_group_permissions_permission_id_84c5c92e" ON "auth_group_permissions" ("permission_id");
CREATE TABLE IF NOT EXISTS "auth_permission" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "content_type_id" integer NOT NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "codename" varchar(100) NOT NULL, "name" varchar(255) NOT NULL);
CREATE UNIQUE INDEX "auth_permission_content_type_id_codename_01ab375a_uniq" ON "auth_permission" ("content_type_id", "codename");
CREATE INDEX "auth_permission_content_type_id_2f476e4b" ON "auth_permission" ("content_type_id");
CREATE TABLE IF NOT EXISTS "auth_group" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(150) NOT NULL UNIQUE);
CREATE TABLE IF NOT EXISTS "main_app_customuser_groups" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "customuser_id" integer NOT NULL REFERENCES "main_app_customuser" ("id") DEFERRABLE INITIALLY DEFERRED, "group_id" integer NOT NULL REFERENCES "auth_group" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE IF NOT EXISTS "main_app_customuser_user_permissions" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "customuser_id" integer NOT NULL REFERENCES "main_app_customuser" ("id") DEFERRABLE INITIALLY DEFERRED, "permission_id" integer NOT NULL REFERENCES "auth_permission" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE IF NOT EXISTS "main_app_course" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(120) NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE IF NOT EXISTS "main_app_session" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "start_year" date NOT NULL, "end_year" date NOT NULL);
CREATE TABLE IF NOT EXISTS "main_app_studentresult" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "test" real NOT NULL, "exam" real NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "student_id" integer NOT NULL REFERENCES "main_app_student" ("id") DEFERRABLE INITIALLY DEFERRED, "subject_id" integer NOT NULL REFERENCES "main_app_subject" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE IF NOT EXISTS "main_app_notificationstudent" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "message" text NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "student_id" integer NOT NULL REFERENCES "main_app_student" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE IF NOT EXISTS "main_app_notificationstaff" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "message" text NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "staff_id" integer NOT NULL REFERENCES "main_app_staff" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE IF NOT EXISTS "main_app_leavereportstudent" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date" varchar(60) NOT NULL, "message" text NOT NULL, "status" smallint NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "student_id" integer NOT NULL REFERENCES "main_app_student" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE IF NOT EXISTS "main_app_leavereportstaff" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date" varchar(60) NOT NULL, "message" text NOT NULL, "status" smallint NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "staff_id" integer NOT NULL REFERENCES "main_app_staff" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE UNIQUE INDEX "main_app_customuser_groups_customuser_id_group_id_6dd2b9a7_uniq" ON "main_app_customuser_groups" ("customuser_id", "group_id");
CREATE INDEX "main_app_customuser_groups_customuser_id_9d75aa94" ON "main_app_customuser_groups" ("customuser_id");
CREATE INDEX "main_app_customuser_groups_group_id_9ee498f4" ON "main_app_customuser_groups" ("group_id");
CREATE UNIQUE INDEX "main_app_customuser_user_permissions_customuser_id_permission_id_0bd2d638_uniq" ON "main_app_customuser_user_permissions" ("customuser_id", "permission_id");
CREATE INDEX "main_app_customuser_user_permissions_customuser_id_b28fdeb1" ON "main_app_customuser_user_permissions" ("customuser_id");
CREATE INDEX "main_app_customuser_user_permissions_permission_id_595e7ce3" ON "main_app_customuser_user_permissions" ("permission_id");
CREATE INDEX "main_app_studentresult_student_id_e57bb0c5" ON "main_app_studentresult" ("student_id");
CREATE INDEX "main_app_studentresult_subject_id_6abff4dc" ON "main_app_studentresult" ("subject_id");
CREATE INDEX "main_app_notificationstudent_student_id_dcbe1f25" ON "main_app_notificationstudent" ("student_id");
CREATE INDEX "main_app_notificationstaff_staff_id_4170f50c" ON "main_app_notificationstaff" ("staff_id");
CREATE INDEX "main_app_leavereportstudent_student_id_2d19cc01" ON "main_app_leavereportstudent" ("student_id");
CREATE INDEX "main_app_leavereportstaff_staff_id_9c69ba31" ON "main_app_leavereportstaff" ("staff_id");
CREATE TABLE IF NOT EXISTS "main_app_admin" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "admin_id" integer NOT NULL UNIQUE REFERENCES "main_app_customuser" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE IF NOT EXISTS "django_admin_log" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "action_time" datetime NOT NULL, "object_id" text NULL, "object_repr" varchar(200) NOT NULL, "change_message" text NOT NULL, "content_type_id" integer NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NOT NULL REFERENCES "main_app_customuser" ("id") DEFERRABLE INITIALLY DEFERRED, "action_flag" smallint unsigned NOT NULL CHECK ("action_flag" >= 0));
CREATE INDEX "django_admin_log_content_type_id_c4bce8eb" ON "django_admin_log" ("content_type_id");
CREATE INDEX "django_admin_log_user_id_c564eba6" ON "django_admin_log" ("user_id");
CREATE TABLE IF NOT EXISTS "django_session" ("session_key" varchar(40) NOT NULL PRIMARY KEY, "session_data" text NOT NULL, "expire_date" datetime NOT NULL);
CREATE INDEX "django_session_expire_date_a5c62663" ON "django_session" ("expire_date");
CREATE TABLE IF NOT EXISTS "main_app_attendance" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date" date NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "session_id" integer NOT NULL REFERENCES "main_app_session" ("id") DEFERRABLE INITIALLY DEFERRED, "subject_id" integer NOT NULL REFERENCES "main_app_subject" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE INDEX "main_app_attendance_session_id_b5e3071a" ON "main_app_attendance" ("session_id");
CREATE INDEX "main_app_attendance_subject_id_4de67085" ON "main_app_attendance" ("subject_id");
CREATE TABLE IF NOT EXISTS "main_app_staff" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "admin_id" integer NOT NULL UNIQUE REFERENCES "main_app_customuser" ("id") DEFERRABLE INITIALLY DEFERRED, "course_id" integer NULL REFERENCES "main_app_course" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE INDEX "main_app_staff_course_id_b4d19096" ON "main_app_staff" ("course_id");
CREATE TABLE IF NOT EXISTS "main_app_student" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "admin_id" integer NOT NULL UNIQUE REFERENCES "main_app_customuser" ("id") DEFERRABLE INITIALLY DEFERRED, "course_id" integer NULL REFERENCES "main_app_course" ("id") DEFERRABLE INITIALLY DEFERRED, "session_id" integer NULL REFERENCES "main_app_session" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE INDEX "main_app_student_course_id_8a4c712f" ON "main_app_student" ("course_id");
CREATE INDEX "main_app_student_session_id_8f220969" ON "main_app_student" ("session_id");
CREATE TABLE IF NOT EXISTS "main_app_subject" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(120) NOT NULL, "updated_at" datetime NOT NULL, "created_at" datetime NOT NULL, "course_id" integer NOT NULL REFERENCES "main_app_course" ("id") DEFERRABLE INITIALLY DEFERRED, "staff_id" integer NOT NULL REFERENCES "main_app_staff" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE INDEX "main_app_subject_course_id_e94ba4e3" ON "main_app_subject" ("course_id");
CREATE INDEX "main_app_subject_staff_id_f1d6d399" ON "main_app_subject" ("staff_id");
CREATE TABLE IF NOT EXISTS "main_app_customuser" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "password" varchar(128) NOT NULL, "last_login" datetime NULL, "is_superuser" bool NOT NULL, "first_name" varchar(150) NOT NULL, "last_name" varchar(150) NOT NULL, "is_staff" bool NOT NULL, "is_active" bool NOT NULL, "date_joined" datetime NOT NULL, "email" varchar(254) NOT NULL UNIQUE, "user_type" varchar(1) NOT NULL, "gender" varchar(1) NOT NULL, "profile_pic" varchar(100) NOT NULL, "address" text NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "fcm_token" text NOT NULL);
CREATE TABLE IF NOT EXISTS "main_app_attendancereport" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "status" bool NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "attendance_id" integer NOT NULL REFERENCES "main_app_attendance" ("id") DEFERRABLE INITIALLY DEFERRED, "student_id" integer NOT NULL REFERENCES "main_app_student" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE INDEX "main_app_attendancereport_attendance_id_8102922e" ON "main_app_attendancereport" ("attendance_id");
CREATE INDEX "main_app_attendancereport_student_id_0957b64c" ON "main_app_attendancereport" ("student_id");
