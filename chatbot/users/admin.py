from django.contrib import admin
from users.models import User


class UserAdmin(admin.ModelAdmin):
    model = User
    list_display = ('userKey', 'created', 'modified', 'id', 'modelChoice', 'phoneModel')


admin.site.register(User, UserAdmin)