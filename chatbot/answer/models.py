from django.db import models


class TimeStampedModel(models.Model):
    created = models.DateTimeField(auto_now_add=True)
    modified = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True


class Maker(TimeStampedModel):
    makerName = models.TextField(default="")
    makerPhoto = models.ImageField(null=True, blank=True)

    def __str__(self):
        return self.makerName


class PhoneModel(TimeStampedModel):
    maker = models.ForeignKey(Maker, default=1)
    modelName = models.TextField(default="")
    modelPhoto = models.ImageField(null=True, blank=True)

    def __str__(self):
        return self.maker + " / " + self.modelName


class Capacity(TimeStampedModel):
    model = models.ForeignKey(PhoneModel, default=1)
    modelGB = models.TextField(default="")
    modelGBPhoto = models.ImageField(null=True, blank=True)

    def __str__(self):
        return self.model + " / " + self.modelGB