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

    elif model[0]:
        phoneModel = PhoneModel.objects.get(id=model[1])
        return JsonResponse({
            'message': {
                'text': phoneModel.modelName + "의 정보입니다. ~~",
            },
            'keyboard': {
                'type': 'buttons',
                'buttons': [phoneModel.modelName]
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
    try:
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
    except:
        return False, 0


# user input is maker button check
def check_is_model(str):
    try:
        if check_is_start(str) or check_is_help(str):
            return False, 0
        else:
            str_list = str.split('(')
            name = str_list[0]
            id = str_list[1][:1]
            models = PhoneModel.objects.values_list('modelName', flat=True)
            if name in models:
                return True, id
            else:
                return False, id
    except:
        return False, 0


def check_is_help(str):
    if str == "도움말":
        return True
    else:
        return False