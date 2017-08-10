from django.contrib import admin
from answer.models import Maker, PhoneModel


class MakerAdmin(admin.ModelAdmin):
    model = Maker
    list_display = ('makerName', 'created', 'modified')


class PhoneModelAdmin(admin.ModelAdmin):
    model = PhoneModel
    list_display = ('modelName', 'created', 'modified')


admin.site.register(Maker, MakerAdmin)
admin.site.register(PhoneModel, PhoneModelAdmin)