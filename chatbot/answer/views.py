from django.shortcuts import render
from django.http import JsonResponse
from answer.models import Test
from django.views.decorators.csrf import csrf_exempt
import json


def keyboard(request):

    test = Test.objects.all().first()
    text = test.test

    return JsonResponse({
        'type' : 'buttons',
        'buttons' : ['test1', 'test2', text]
    })


# @csrf_exempt
# def message(request):
#     if request.POST:
#         json_str = ((request.body).decode('utf-8'))
#         json_data = json.loads(json_str)
#
#         # 응답타입 체크 : content가 "삼성", "엘지" 이런거라면 check_type = maker
#         # 코드로는 ex) check_is_maker(user_response)
#         # user_response = json_data['content']
#         # def check_is_maker(user_response)
#         #   maker = Test.objects.all().value??()['test']
#         #   for user_response in maker:
#         #       if maker:
#         #           return maker
#
#         # if check_is_maker(user_response)
#         # elif check_is_model(user_response)
#         # ...
#
#         user_response = json_data['content']
#         test = Test.objects.all().first()
#         return JsonResponse({
#             'message': {
#                 'text': user_response
#             },
#             'keyboard': {
#                 'type': 'buttons',
#                 'buttons': ['galaxy', 'bega', 'sony']
#             },
#             "photo": {
#                 "url": test.testPhoto.url,
#                 "width": 640,
#                 "height": 480
#             },
#         })