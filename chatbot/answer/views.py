# coding=utf-8
from django.shortcuts import render
from django.http import JsonResponse
from answer.models import Maker
from answer.models import PhoneModel
from answer.models import Capacity
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings
import json


# conversation start
def keyboard(request):
    return JsonResponse({
        'type': 'buttons',
        'buttons': ['시작하기', '도움말'] # start button for user
    })


# response to user post type request
@csrf_exempt
def message(request):
    message = ((request.body).decode('utf-8'))
    return_json_str = json.loads(message)
    return_str = return_json_str['content']

    start = check_is_start(return_str) # check is start state
    maker = check_is_maker(return_str) # check is choice maker state
    model = check_is_model(return_str) # model check
    capacity = check_is_capacity(return_str) # capacity check

    test = Test.objects.all().first()

    # if start button check
    if start:
        return JsonResponse({
            'message': {
                'text': "얼마고를 시작합니다. 핸드폰 기종을 선택하여 주세요!",
            },
            'keyboard': {
                'type': 'buttons',
                'buttons': list(Maker.objects.values_list('makerName',  flat=True)),  # 변수를 저장.
            },
        })
    if maker:
        return JsonResponse({
            'message': {
                'text': return_str + "의 어떤 기종을 선택하시겠습니까?",
            },
            'keyboard': {
                'type': 'buttons',
                'buttons': list(PhoneModel.objects.values_list('modelName', flat=True)),  # 변수를 저장.
                # return_str의 값과 PhoneModel의 값을 비교하여 알맞는것만 출력
            },
        })
    if model:
        return JsonResponse({
            'message': {
                'text': return_str + "의 용량을 선택하여 주세요. 아무 용량이나 상관 없다면 용량선택안함을 눌러주세요",
            },
            'keyboard': {
                'type': 'buttons',
                'buttons': list(Capacity.objects.values_list('modelGB',flat = True)),  # 변수를 저장.
            },
        })
    if capacity:
        return JsonResponse({
            'message': {
                'text': return_str + "의 평균 가격은 503221 입니다. 최고가격은 82921 입니다. 최저가격은 29339입니다.",
            },
            "photo": {
                "url": "http://ec2-13-124-156-121.ap-northeast-2.compute.amazonaws.com" + test.testPhoto.url,
                "width": 640,
                "height": 480
            },
            'keyboard': {
                'type': 'buttons',
                'buttons':  ['시작하기', '도움말']
            },
        })

    else:
        return JsonResponse({
            'message': {
                'text': '다시시작합니다.',
            },
            'keyboard': {
                'type': 'buttons',
                'buttons': ['시작하기', '도움말']
            },
        })


# user input is start button check
def check_is_start(str):
    if str == "시작하기":
        return True
    else:
        return False


# user input is maker button check
def check_is_maker(str):
    makers = Maker.objects.values_list('makerName', flat=True)
    if str in makers:
        return True
    else:
        return False


# user input is maker button check
def check_is_model(str):
    models = PhoneModel.objects.values_list('modelName', flat=True)
    if str in models:
        return True
    else:
        return False


def check_is_capacity(str):
    capacities = Capacity.objects.values_list('modelGB', flat=True)
    if str in capacities:
        return True
    else:
        return False

# 코딩 아이디어 메모

# return JsonResponse({
#
#     'message': {
#         'text': return_str,
#         "photo": {
#             "url": "http://ec2-13-124-156-121.ap-northeast-2.compute.amazonaws.com" + test.testPhoto.url,
#             # url을 image viewer url로 하면 더 깔끔할듯
#             "width": 640,
#             "height": 480
#         },
#     },
#
#     'keyboard': {
#         'type': 'buttons',
#         'buttons': ['galaxy', 'bega', 'sony']
#     }
# })


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