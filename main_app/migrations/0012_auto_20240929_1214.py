# Generated by Django 3.1.1 on 2024-09-29 11:14

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('main_app', '0011_auto_20240929_1214'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='feedbackstudent',
            name='student',
        ),
        migrations.DeleteModel(
            name='FeedbackStaff',
        ),
        migrations.DeleteModel(
            name='FeedbackStudent',
        ),
    ]
