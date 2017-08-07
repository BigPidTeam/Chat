from django.shortcuts import render
from django.http import JsonResponse
from answer.models import Test
from django.views.decorators.csrf import csrf_exempt
import json, datetime


def keyboard(request):

    test = Test.objects.all().first()
    text = test.test

    return JsonResponse({
        'type' : 'buttons',
        'buttons' : ['test1', 'test2', text]
    })


@csrf_exempt
def answer(request):
    return JsonResponse({
        'message': {
            'text': ' 중식 메뉴입니다.'
        },
        'keyboard': {
            'type': 'buttons',
            'buttons': ['상록원', '그루터기', '아리수', '기숙사식당', '교직원식당']
        }

    })

# @csrf_exempt
# def answer(request):
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
#         return JsonResponse({
#             'message': {
#                 'text': user_response
#             },
#             'keyboard': {
#                 'type': 'buttons',
#                 'buttons': ['galaxy', 'bega', 'sony']
#             }
#             # "photo": {
#             #     "url": test.testPhoto.url,
#             #     "width": 640,
#             #     "height": 480
#             # },
#         })