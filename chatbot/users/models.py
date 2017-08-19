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
    phoneModel = models.ForeignKey(PhoneModel, default=None)

    def __str__(self):
        return self.userKey

    def stateClear(self):
        self.modelChoice = False
        self.save()

    @staticmethod
    def createUser(user_key, phoneModel):
        newObj = User.objects.create(userKey=user_key, modelChoice=True, phoneModel=phoneModel)
        newObj.save()

    @staticmethod
    def setUserState(user_key, phoneModel):
        try:
            user = User.objects.get(userKey=user_key)
            user.phoneModel = phoneModel
            user.modelChoice = True
            user.save()
        except:
            User.createUser(user_key, phoneModel)

    @staticmethod
    def getUser(user_key):
        return User.objects.get(userKey=user_key)