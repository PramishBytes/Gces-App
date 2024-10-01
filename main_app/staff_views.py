import json
from django.contrib import messages
from django.core.files.storage import FileSystemStorage
from django.http import HttpResponse, JsonResponse, HttpResponseBadRequest
from django.shortcuts import get_object_or_404, redirect, render
from .models import Staff
from .forms import StaffEditForm

from django.urls import reverse
from django.views.decorators.csrf import csrf_exempt
from .forms import *
from .models import *

def staff_home(request):
    staff = get_object_or_404(Staff, admin=request.user)
    total_students = Student.objects.filter(course=staff.course).count()
    total_leave = LeaveReportStaff.objects.filter(staff=staff).count()
    subjects = Subject.objects.filter(staff=staff)
    total_subject = subjects.count()
    attendance_list = Attendance.objects.filter(subject__in=subjects)
    total_attendance = attendance_list.count()

    # Collect attendance data for each subject
    subject_list = []
    attendance_count_list = []
    for subject in subjects:
        attendance_count = Attendance.objects.filter(subject=subject).count()
        subject_list.append(subject.name)
        attendance_count_list.append(attendance_count)

    context = {
        'page_title': f'Staff Panel - {staff.admin.last_name} ({staff.course})',
        'total_students': total_students,
        'total_attendance': total_attendance,
        'total_leave': total_leave,
        'total_subject': total_subject,
        'subject_list': subject_list,
        'attendance_list': attendance_count_list
    }
    return render(request, 'staff_template/home_content.html', context)


def staff_take_attendance(request):
    staff = get_object_or_404(Staff, admin=request.user)
    subjects = Subject.objects.filter(staff_id=staff)
    sessions = Session.objects.all()
    context = {
        'subjects': subjects,
        'sessions': sessions,
        'page_title': 'Take Attendance'
    }
    return render(request, 'staff_template/staff_take_attendance.html', context)


@csrf_exempt
def get_students(request):
    subject_id = request.POST.get('subject')
    session_id = request.POST.get('session')
    try:
        subject = get_object_or_404(Subject, id=subject_id)
        session = get_object_or_404(Session, id=session_id)
        students = Student.objects.filter(course_id=subject.course.id, session=session)
        student_data = [{"id": student.id, "name": f"{student.admin.last_name} {student.admin.first_name}"} for student in students]
        return JsonResponse(student_data, safe=False)
    except Exception as e:
        return HttpResponseBadRequest(f"Error fetching students: {str(e)}")


@csrf_exempt
def save_attendance(request):
    student_data = request.POST.get('student_ids')
    date = request.POST.get('date')
    subject_id = request.POST.get('subject')
    session_id = request.POST.get('session')

    students = json.loads(student_data)
    try:
        session = get_object_or_404(Session, id=session_id)
        subject = get_object_or_404(Subject, id=subject_id)
        attendance = Attendance(session=session, subject=subject, date=date)
        attendance.save()

        for student_dict in students:
            student = get_object_or_404(Student, id=student_dict.get('id'))
            attendance_report = AttendanceReport(
                student=student, 
                attendance=attendance, 
                status=student_dict.get('status')
            )
            attendance_report.save()

        return HttpResponse("OK")
    except Exception as e:
        return HttpResponseServerError(f"Error saving attendance: {str(e)}")


def staff_update_attendance(request):
    staff = get_object_or_404(Staff, admin=request.user)
    subjects = Subject.objects.filter(staff_id=staff)
    sessions = Session.objects.all()
    context = {
        'subjects': subjects,
        'sessions': sessions,
        'page_title': 'Update Attendance'
    }
    return render(request, 'staff_template/staff_update_attendance.html', context)


@csrf_exempt
def get_student_attendance(request):
    attendance_date_id = request.POST.get('attendance_date_id')
    try:
        date = get_object_or_404(Attendance, id=attendance_date_id)
        attendance_data = AttendanceReport.objects.filter(attendance=date)
        student_data = [
            {
                "id": attendance.student.admin.id,
                "name": f"{attendance.student.admin.last_name} {attendance.student.admin.first_name}",
                "status": attendance.status
            } for attendance in attendance_data
        ]
        return JsonResponse(student_data, safe=False)
    except Exception as e:
        return HttpResponseBadRequest(f"Error fetching student attendance: {str(e)}")


@csrf_exempt
def update_attendance(request):
    student_data = request.POST.get('student_ids')
    date = request.POST.get('date')
    students = json.loads(student_data)

    try:
        attendance = get_object_or_404(Attendance, id=date)

        for student_dict in students:
            student = get_object_or_404(Student, admin_id=student_dict.get('id'))
            attendance_report = get_object_or_404(AttendanceReport, student=student, attendance=attendance)
            attendance_report.status = student_dict.get('status')
            attendance_report.save()

        return HttpResponse("OK")
    except Exception as e:
        return HttpResponseServerError(f"Error updating attendance: {str(e)}")


def staff_apply_leave(request):
    form = LeaveReportStaffForm(request.POST or None)
    staff = get_object_or_404(Staff, admin_id=request.user.id)
    context = {
        'form': form,
        'leave_history': LeaveReportStaff.objects.filter(staff=staff),
        'page_title': 'Apply for Leave'
    }
    if request.method == 'POST' and form.is_valid():
        try:
            leave_report = form.save(commit=False)
            leave_report.staff = staff
            leave_report.save()
            messages.success(request, "Application for leave submitted.")
            return redirect(reverse('staff_apply_leave'))
        except Exception as e:
            messages.error(request, f"Could not apply for leave: {str(e)}")
    return render(request, "staff_template/staff_apply_leave.html", context)


def staff_view_profile(request):
    staff = get_object_or_404(Staff, admin=request.user)
    form = StaffEditForm(request.POST or None, request.FILES or None, instance=staff)
    context = {'form': form, 'page_title': 'View/Update Profile'}
    
    if request.method == 'POST' and form.is_valid():
        try:
            admin = staff.admin
            # Update user profile details
            admin.first_name = form.cleaned_data.get('first_name')
            admin.last_name = form.cleaned_data.get('last_name')
            admin.address = form.cleaned_data.get('address')
            admin.gender = form.cleaned_data.get('gender')

            password = form.cleaned_data.get('password')
            profile_pic = request.FILES.get('profile_pic')

            if password:
                admin.set_password(password)
            if profile_pic:
                fs = FileSystemStorage()
                filename = fs.save(profile_pic.name, profile_pic)
                admin.profile_pic = fs.url(filename)

            admin.save()
            staff.save()

            messages.success(request, "Profile updated successfully.")
            return redirect(reverse('staff_view_profile'))
        except Exception as e:
            messages.error(request, f"Error updating profile: {str(e)}")

    return render(request, "staff_template/staff_view_profile.html", context)


@csrf_exempt
def staff_fcmtoken(request):
    token = request.POST.get('token')
    try:
        staff_user = get_object_or_404(CustomUser, id=request.user.id)
        staff_user.fcm_token = token
        staff_user.save()
        return HttpResponse("True")
    except Exception as e:
        return HttpResponse("False")


def staff_view_notification(request):
    staff = get_object_or_404(Staff, admin=request.user)
    notifications = NotificationStaff.objects.filter(staff=staff)
    context = {
        'notifications': notifications,
        'page_title': "View Notifications"
    }
    return render(request, "staff_template/staff_view_notification.html", context)


def staff_add_result(request):
    staff = get_object_or_404(Staff, admin=request.user)
    subjects = Subject.objects.filter(staff=staff)
    sessions = Session.objects.all()
    context = {
        'page_title': 'Result Upload',
        'subjects': subjects,
        'sessions': sessions
    }

    if request.method == 'POST':
        try:
            student_id = request.POST.get('student_list')
            subject_id = request.POST.get('subject')
            test = request.POST.get('test')
            exam = request.POST.get('exam')

            student = get_object_or_404(Student, id=student_id)
            subject = get_object_or_404(Subject, id=subject_id)
            
            result, created = StudentResult.objects.get_or_create(student=student, subject=subject)
            result.exam = exam
            result.test = test
            result.save()
            
            message = "Scores Updated" if not created else "Scores Saved"
            messages.success(request, message)
        except Exception as e:
            messages.error(request, f"Error processing form: {str(e)}")

    return render(request, "staff_template/staff_add_result.html", context)


@csrf_exempt
def fetch_student_result(request):
    try:
        subject_id = request.POST.get('subject')
        student_id = request.POST.get('student')

        student = get_object_or_404(Student, id=student_id)
        subject = get_object_or_404(Subject, id=subject_id)

        result = StudentResult.objects.get(student=student, subject=subject)
        result_data = {
            'exam': result.exam,
            'test': result.test
        }
        return JsonResponse(result_data)
    except Exception as e:
        return HttpResponseBadRequest(f"Error fetching result: {str(e)}")
