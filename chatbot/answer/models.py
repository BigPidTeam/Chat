from django.db import models


class TimeStampedModel(models.Model):
    created = models.DateTimeField(auto_now_add=True)
    modified = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True


class Maker(TimeStampedModel):
    makerName = models.TextField(default="")
    makerPhoto = models.ImageField(null=True, blank=True)


class PhoneModel(TimeStampedModel):
    modelName = models.TextField(default="")
    modelPhoto = models.ImageField(null=True, blank=True)