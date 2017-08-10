# coding=utf-8
from django.shortcuts import render
from django.http import JsonResponse
from answer.models import Maker
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings
import json


# 카카오톡에서 keyboard 함수를 검색
def keyboard(request):
    return JsonResponse({  # JSON타입으로 반환
        'type': 'buttons',
        'buttons': ['시작하기', '도움말']  # 채팅에 접속하면 2개의 버튼이 존재
    })


@csrf_exempt
def message(request):  # 버튼을 누르면 message 함수로 이동
    message = ((request.body).decode('utf-8'))  # request.body 가 어느부분?
    return_json_str = json.loads(message)
    return_str = return_json_str['content']

    start = check_is_start(return_str)
    maker = check_is_maker(return_str)

    if start:  # 응답에 대한 미러링과 버튼 제공
        return JsonResponse({
            'message': {
                'text': "hello user, choice the maker",
            },
            'keyboard': {
                'type': 'buttons',
                'buttons': list(Maker.objects.values_list('makerName', flat=True)),  # 변수를 저장.
            },
            # 함수 삽입 가능여부. 안된다면 여기에 코드 전개가 가능한지 여부. (message와, keyboard를 사용하여)
            # 입력받은 변수를 저장해서 그 변수를 check_is_maker()의 인자로 보냄
        })


def check_is_maker(str):
    makers = Maker.objects.values_list('makerName', flat=True)
    if str in makers:
        return True
    else:
        return False


def check_is_start(str):
    if str == "시작하기":
        return True
    else:
        return False


    # elif return_str == '도움말':
    #     help()
    #
    # elif return_str == '삼성':  # 응답에 대한 미러링과 버튼 제공
    #     return JsonResponse({
    #         'message': {
    #             'text': return_str + "를 선택하셨습니다. " + return_str + "의 상세 모델을 선택하여 주세요.",
    #         },
    #
    #         # 시작하기/도움말 화면으로 이동(버튼)
    #         'keyboard': {
    #             'type': 'buttons',
    #             'buttons': ['갤럭시 s6', '갤럭시 s7', '갤럭시 s8', '돌아가기'],
    #             # keyboard(request) 초기화면으로 돌아가는것 알아보기
    #         },
    #     })
    #
    # elif return_str == '애플':  # 응답에 대한 미러링과 버튼 제공
    #     return JsonResponse({
    #         'message': {
    #             'text': return_str + "를 선택하셨습니다. " + return_str + "의 상세 모델을 선택하여 주세요.",
    #         },
    #
    #         # 시작하기/도움말 화면으로 이동(버튼)
    #         'keyboard': {
    #             'type': 'buttons',
    #             'buttons': ['아이폰 5', '아이폰 6', '아이폰 7'],
    #             # keyboard(request) 초기화면으로 돌아가는것 알아보기
    #         },
    #     })
    # elif return_str == 'LG':  # 응답에 대한 미러링과 버튼 제공
    #     return JsonResponse({
    #         'message': {
    #             'text': return_str + "를 선택하셨습니다. " + return_str + "의 상세 모델을 선택하여 주세요.",
    #         },
    #
    #         # 시작하기/도움말 화면으로 이동(버튼)
    #         'keyboard': {
    #             'type': 'buttons',
    #             'buttons': ['돌아가기'],
    #             # keyboard(request) 초기화면으로 돌아가는것 알아보기
    #         },
    #     })
    # elif return_str == '기타':  # 응답에 대한 미러링과 버튼 제공
    #     return JsonResponse({
    #         'message': {
    #             'text': return_str + "를 선택하셨습니다. " + return_str + "의 상세 모델을 선택하여 주세요.",
    #         },
    #
    #         # 시작하기/도움말 화면으로 이동(버튼)
    #         'keyboard': {
    #             'type': 'buttons',
    #             'buttons': ['돌아가기'],
    #             # keyboard(request) 초기화면으로 돌아가는것 알아보기
    #         },
    #     })
    # elif return_str == '갤럭시 s6':
    #     return JsonResponse({
    #
    #         'message': {
    #             'text': return_str + '의 평균가격은 452,300원입니다. ' + return_str + '의 최고가격은 772,100원입니다. '
    #                     + return_str + '의 최저가격은 191,600원입니다. ',
    #             "photo": {
    #                 "url": "http://ec2-13-124-156-121.ap-northeast-2.compute.amazonaws.com" + test.testPhoto.url,
    #                 # url을 image viewer url로 하면 더 깔끔할듯
    #                 "width": 640,
    #                 "height": 480
    #             },
    #         },
    #
    #         'keyboard': {
    #             'type': 'buttons',
    #             'buttons': ['다른기종 알아보기', '더 자세히 보기']
    #         }
    #     })
    # else:
    #     return JsonResponse({
    #         'message': {
    #             'text': return_str + "를 선택하셨습니다. 초기화면으로 돌아갑니다.",
    #         },
    #         'keyboard': {
    #             'type': 'buttons',
    #             'buttons': ['시작하기', '도움말'],  # 변수를 저장.
    #         },
    #         # 함수 삽입 가능여부. 안된다면 여기에 코드 전개가 가능한지 여부. (message와, keyboard를 사용하여)
    #         # 입력받은 변수를 저장해서 그 변수를 check_is_maker()의 인자로 보냄
    #     })


# def start(return_str):
#     return JsonResponse({
#         'message': {
#             'text': return_str + "를 선택하셨습니다. 핸드폰의 제조사를 선택하여 주세요",
#         },
#         'keyboard': {
#             'type': 'buttons',
#             'buttons': ['삼성', '애플', 'LG', '화웨이', '기타'],  # 변수를 저장.
#         },
#         # 함수 삽입 가능여부. 안된다면 여기에 코드 전개가 가능한지 여부. (message와, keyboard를 사용하여)
#         # 입력받은 변수를 저장해서 그 변수를 check_is_maker()의 인자로 보냄
#     })
#
#
# def help(return_str):
#     return JsonResponse({
#
#         'message': {
#             'text': return_str + "를 선택하셨습니다. 저희 앱의 목적은 중고핸드폰 가격을 예측하는 것입니다. ~~",
#         },
#
#         # 시작하기/도움말 화면으로 이동(버튼)
#         'keyboard': {
#             'type': 'buttons',
#             'buttons': ['돌아가기'],
#             # keyboard(request) 초기화면으로 돌아가는것 알아보기
#         },
#     })
#
#
#
# def check_is_model(return_str):  # 모델명 함수
#     return JsonResponse({  # JSON타입으로 반환
#         'type': 'buttons',
#         'buttons': ['시작하기', '도움말']  # 채팅에 접속하면 2개의 버튼이 존재
#     })
#
#     # 우선 버튼타입으로 제작 (아래 주석은 text 파일로 메시지를 입력받는 소스)
#     '''
#     else: # 응답에 대한 미러링과 사진, 텍스트 입력 제공
#         return JsonResponse({
#
#             'message': {
#                 'text': return_str,
#                 "photo": {
#                     "url": "http://ec2-13-124-156-121.ap-northeast-2.compute.amazonaws.com" + test.testPhoto.url,
#                     # url을 image viewer url로 하면 더 깔끔할듯
#                     "width": 640,
#                     "height": 480
#                 },
#             },
#
#             'keyboard': {
#                 'type': 'text'
#             }
#         })'''

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

