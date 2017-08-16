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
    factoryPrice = models.IntegerField(default=0)

    def __str__(self):
        return self.maker.makerName + " / " + self.modelName


class Elements(TimeStampedModel):
    currentMonth = models.TextField(default="")
    currentRate = models.IntegerField(default=0)

    def __set__(self):
        return self.currentMonth + " / " + str(self.currentRate)

    @staticmethod
    def getCurrentElements():
        return Elements.objects.all().first()