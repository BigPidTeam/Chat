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
    mode_seller = check_is_seller(return_str)
    mode_buyer = check_is_buyer(return_str)

    # if start button check
    if start:
        result = list(Maker.objects.values_list('makerName', flat=True))
        return JsonResponse({
            'message': {
                'text': "얼마고를 시작합니다. 핸드폰 기종을 선택하여 주세요!",
            },
            'keyboard': {
                'type': 'buttons',
                'buttons': result,
            },
        })

    elif maker:
        selected_maker = Maker.objects.get(makerName=return_str)
        models = PhoneModel.objects.filter(maker=selected_maker)
        result = list(models.values_list('modelName', flat=True))
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
                'text': return_str + "의 정보입니다. ~~",
            },
            'keyboard': {
                'type': 'buttons',
                'buttons': ['가격 정보 보기', '모의 판매글 올리기'],
            },
        })

    elif help:
        return JsonResponse({
            'message': {
                'text': "얼마고는 빅데이터를 활용한 중고 핸드폰 가격검색 챗봇입니다. 저희 Team Scoop은 중고시장을 활성화하여 소비자의 ~",
            },
            'keyboard': {
                'type': 'buttons',
                'buttons': ['시작하기', '도움말']
            },
        })

    elif mode_buyer:
        pass

    elif mode_seller:
        return JsonResponse({
            'message': {
                'text': '판매 모의 글을 올려보세요.',
            },
            'keyboard': {
                'type': 'text'
            },
        })

    else:
        return JsonResponse({
            'message': {
                'text': '다시 시작합니다.',
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


# user input is help button check
def check_is_help(str):
    if str == "도움말":
        return True
    else:
        return False


# user input is seller mode check
def check_is_seller(str):
    if str == "모의 판매글 올리기":
        return True
    else:
        return False


# user input is buyer mode check
def check_is_buyer(str):
    if str == "가격 정보 보기":
        return True
    else:
        return False