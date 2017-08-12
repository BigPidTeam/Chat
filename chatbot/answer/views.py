# coding=utf-8
from django.http import JsonResponse
from answer.models import Maker
from answer.models import PhoneModel
from django.views.decorators.csrf import csrf_exempt
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

    start = check_is_start(return_str)  # check is start state
    help = check_is_help(return_str)  # model check
    maker = check_is_maker(return_str)  # check is choice maker state
    model = check_is_model(return_str)  # model check

    # if start button check
    if start:
        id = list(map(str, list(Maker.objects.values_list('id', flat=True))))
        name = list(map(str, list(Maker.objects.values_list('makerName', flat=True))))
        result = [i + "(" + j + ")" for i, j in zip(name, id)]

        return JsonResponse({
            'message': {
                'text': "얼마고를 시작합니다. 핸드폰 기종을 선택하여 주세요!",
            },
            'keyboard': {
                'type': 'buttons',
                'buttons': result,
            },
        })

    elif maker[0]:
        obj_list = PhoneModel.objects.filter(maker__id=maker[1])
        id = list(map(str, list(obj_list.values_list('id', flat=True))))
        name = list(map(str, list(obj_list.values_list('modelName', flat=True))))
        result = [i + "(" + j + ")" for i, j in zip(name, id)]
        return JsonResponse({
            'message': {
                'text': return_str + "의 어떤 기종을 선택하시겠습니까?",
            },
            'keyboard': {
                'type': 'buttons',
                'buttons': result,
            },
        })

    elif model:
        return JsonResponse({
            'message': {
                'text': return_str + "의 용량을 선택하여 주세요. 아무 용량이나 상관 없다면 용량선택안함을 눌러주세요",
            },
            'keyboard': {
                'type': 'buttons',
                'buttons': ["1"]
            },
        })

    elif help:
        return JsonResponse({
            'message': {
                'text': "Scoop bot은 빅데이터를 활용한 중고 핸드폰 가격검색 챗봇입니다. 저희 Team Scoop은 중고시장을 활성화하여 소비자의 ~",
            },
            'keyboard': {
                'type': 'buttons',
                'buttons': ['시작하기', '도움말']
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
    if check_is_start(str) or check_is_help(str):
        return False, 0
    else:
        str_list = str.split('(')
        name = str_list[0]
        id = str_list[1][:1]
        makers = Maker.objects.values_list('makerName', flat=True)
        if name in makers:
            return True, id
        else:
            return False, id


# user input is maker button check
def check_is_model(str):
    models = PhoneModel.objects.values_list('modelName', flat=True)
    if str in models:
        return True
    else:
        return False


def check_is_help(str):
    if str == "도움말":
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