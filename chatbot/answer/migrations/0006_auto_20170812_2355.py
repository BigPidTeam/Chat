# -*- coding: utf-8 -*-
# Generated by Django 1.11.3 on 2017-08-12 14:55
from __future__ import unicode_literals

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('answer', '0005_auto_20170810_1502'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='capacity',
            name='model',
        ),
        migrations.DeleteModel(
            name='Capacity',
        ),
    ]
