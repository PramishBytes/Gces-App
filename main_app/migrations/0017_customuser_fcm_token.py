# Generated by Django 3.1.1 on 2024-09-29 13:42

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('main_app', '0016_remove_customuser_fcm_token'),
    ]

    operations = [
        migrations.AddField(
            model_name='customuser',
            name='fcm_token',
            field=models.TextField(default=''),
        ),
    ]
