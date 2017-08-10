from django.contrib import admin
from answer.models import Maker, PhoneModel, Capacity


class MakerAdmin(admin.ModelAdmin):
    model = Maker
    list_display = ('makerName', 'created', 'modified')


class PhoneModelAdmin(admin.ModelAdmin):
    model = PhoneModel
    list_display = ('modelName', 'created', 'modified')


class CapacityAdmin(admin.ModelAdmin):
    model = Capacity
    list_display = ('modelGB', 'created', 'modified')


admin.site.register(Maker, MakerAdmin)
admin.site.register(PhoneModel, PhoneModelAdmin)
admin.site.register(Capacity, CapacityAdmin)