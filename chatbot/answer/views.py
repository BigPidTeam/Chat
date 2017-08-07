from django.shortcuts import render
from django.http import JsonResponse
from answer.models import Test


def keyboard(request):

    test = Test.objects.all().first()
    text = test.test

    return JsonResponse({
        'type' : 'buttons',
        'buttons' : ['test1', 'test2', text]
    })