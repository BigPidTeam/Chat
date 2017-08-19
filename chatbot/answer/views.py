# coding=utf-8
from django.http import JsonResponse
from answer.models import Maker, PhoneModel, Elements
from users.models import User
from django.views.decorators.csrf import csrf_exempt
from modules import prediction_rank
from modules import prediction_price
import jpype
import json


model_name = ""


# conversation start
def keyboard(request):
    return JsonResponse({
        'type': 'buttons',
        'buttons': ['시작하기', '도움말'] # start button for user
    })


# response to user post type request
@csrf_exempt
def message(request):
    jpype.attachThreadToJVM()
    message = ((request.body).decode('utf-8'))

    return_json_str = json.loads(message)
    return_str = return_json_str['content']
    user_key = return_json_str['user_key']

    start = check_is_start(return_str)  # check is start state
    help = check_is_help(return_str)  # model check
    maker = check_is_maker(return_str)  # check is choice maker state
    model = check_is_model(return_str)  # model check
    mode_seller = check_is_seller(return_str)
    mode_buyer = check_is_buyer(return_str)
    mode_buyer_rank = check_is_rank(return_str)

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
        phoneModel = PhoneModel.objects.get(modelName=return_str)
        User.setUserState(user_key, phoneModel)
        return JsonResponse({
            'message': {
                'text': return_str + "을 구매하길 원하신다면 '가격 정보 보기'를, 판매하길 원하신다면 '모의 판매글 올리기'를 선택해주세요.",
                "photo": {
                    "url": "http://ec2-13-124-156-121.ap-northeast-2.compute.amazonaws.com:8000" + phoneModel.modelPhoto.url,
                    "width": 640,
                    "height": 480
                },
            },
            'keyboard': {
                'type': 'buttons',
                'buttons': ['가격 정보 보기', '모의 판매글 올리기'],
            },
        })

    elif help:
        return JsonResponse({
            'message': {
                'text': "얼마고는 팀 스쿱의 프로젝트 챗봇으로, 빅데이터를 활용한 중고폰 적정가격을 제안해주는 챗봇입니다. " +
                        "팀 스쿱은 중고거래 활성화 및 공정거래 문화 확립에 기여하고자 노력합니다.",
            },
            'keyboard': {
                'type': 'buttons',
                'buttons': ['시작하기', '도움말']
            },
        })

    elif mode_buyer:
        return JsonResponse({
            'message': {
                'text': '원하는 중고 핸드폰의 상태를 입력해주세요.',
            },
            'keyboard': {
                'type': 'buttons',
                'buttons': ['A', 'B', 'C']
            },
        })

    elif mode_seller:
        return JsonResponse({
            'message': {
                'text': '판매 모의 글을 올려보세요.',
            },
            'keyboard': {
                'type': 'text'
            },
        })

    elif mode_buyer_rank:
        user = User.getUser(user_key)
        if user.modelChoice:
            rank = return_str
            elements = Elements.getCurrentElements()
            phoneModel = user.phoneModel
            price = prediction_price.getPrice(phoneModel.modelName, elements.currentMonth, rank,
                                              phoneModel.factoryPrice, elements.currentRate)
            user.stateClear()
            return JsonResponse({
                'message': {
                    'text': "적정 가격 조회 결과 입니다. (오차범위 약 ± 10%)" + "\n\n" +
                            "제품 등급 : " + rank + "등급" + "\n" +
                            "적정 가격 : " + str(price) + "원" + "\n" +
                            "적정 가격 상한선 : " + str(int(price + (price * 0.1))) + "원" + "\n" +
                            "적정 가격 하한선 : " + str(int(price - (price * 0.1))) + "원" + "\n",
                },
                'keyboard': {
                    'type': 'buttons',
                    'buttons': ['시작하기', '도움말']
                },
            })
    else:
        user = User.getUser(user_key)
        if user.modelChoice:
            rank = prediction_rank.getItemClass(return_str)
            elements = Elements.getCurrentElements()
            phoneModel = user.phoneModel
            price = prediction_price.getPrice(phoneModel.modelName, elements.currentMonth, rank,
                                              phoneModel.factoryPrice, elements.currentRate)
            user.stateClear()
            return JsonResponse({
                'message': {
                    'text': "모의 판매 시뮬레이션 결과 입니다. (오차범위 약 ± 10%)" + "\n\n" +
                            "제품 등급 : " + rank + "등급" + "\n" +
                            "적정 가격 : " + str(price) + "원" + "\n" +
                            "적정 가격 상한선 : " + str(int(price + (price * 0.1)))  + "원" + "\n" +
                            "적정 가격 하한선 : " + str(int(price - (price * 0.1)))  + "원" + "\n",
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


# user input is buyer mode, rank check
def check_is_rank(str):
    if str == "A":
        return True
    elif str == "B":
        return True
    elif str == "C":
        return True
    else:
        return False