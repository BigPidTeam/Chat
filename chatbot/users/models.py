from django.db import models
from answer.models import PhoneModel


class TimeStampedModel(models.Model):
    created = models.DateTimeField(auto_now_add=True)
    modified = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True


class User(TimeStampedModel):
    userKey = models.TextField(default="")
    modelChoice = models.BooleanField(default=False)
    phoneModel = models.ForeignKey(PhoneModel, default=1)

    def __str__(self):
        return self.userKey