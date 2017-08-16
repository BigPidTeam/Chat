from django.contrib import admin
from answer.models import Maker, PhoneModel, Elements


class MakerAdmin(admin.ModelAdmin):
    model = Maker
    list_display = ('makerName', 'created', 'modified', 'id')


class PhoneModelAdmin(admin.ModelAdmin):
    model = PhoneModel
    list_display = ('modelName', 'created', 'modified', 'id')


class ElementsAdmin(admin.ModelAdmin):
    model = Elements
    list_display = ('currentMonth', 'currentRate', 'modified', 'id')


admin.site.register(Maker, MakerAdmin)
admin.site.register(PhoneModel, PhoneModelAdmin)
admin.site.register(Elements, ElementsAdmin)