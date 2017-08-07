from django.contrib import admin
from answer.models import Test


class TestAdmin(admin.ModelAdmin):
    model = Test
    list_display = ('test', 'created', 'modified')


admin.site.register(Test, TestAdmin)