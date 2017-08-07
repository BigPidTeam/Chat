from django.shortcuts import render
from django.http import JsonResponse
from answer.models import Test
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings
import json


def keyboard(request):
    test = Test.objects.all().first()
    test_label = test.test
    return JsonResponse({
        'type': 'buttons',
        'buttons': ['1', '2', test_label]
    })


@csrf_exempt
def message(request):
    test = Test.objects.all().first()
    message = ((request.body).decode('utf-8'))
    return_json_str = json.loads(message)
    return_str = return_json_str['content']

    return JsonResponse({

        'message': {
            'text': return_str,
            "photo": {
                "url": "http://ec2-13-124-156-121.ap-northeast-2.compute.amazonaws.com"+ test.testPhoto.url,
                "width": 640,
                "height": 480
            },
        },

        'keyboard': {
            'type': 'buttons',
            'buttons': ['galaxy', 'bega', 'sony']
        }
    })


    # 응답타입 체크 : content가 "삼성", "엘지" 이런거라면 check_type = maker
    # 코드로는 ex) check_is_maker(return_str)
    # return_str = return_json_str['content']
    # def check_is_maker(return_str)
    #   maker = Test.objects.all().value??()['test']
    #   for user_response in maker:
    #       if maker:
    #           return maker

    # if check_is_maker(user_response)
    # elif check_is_model(user_response)
    # ...