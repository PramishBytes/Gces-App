# Generated by Django 3.1.1 on 2024-10-01 05:12

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('main_app', '0019_auto_20241001_0552'),
    ]

    operations = [
        migrations.AlterField(
            model_name='attendancereport',
            name='student',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='main_app.student'),
        ),
    ]
