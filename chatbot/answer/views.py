from django.shortcuts import render
from django.http import JsonResponse
from answer.models import Test
from django.views.decorators.csrf import csrf_exempt
import json, datetime


def keyboard(request):
    test = Test.objects.all().first()
    return JsonResponse({
        'message': {
                'text': ['1', '2']
            },
            'keyboard': {
                'type': 'buttons',
                'buttons': ['galaxy', 'bega', 'sony']
            },
            "photo": {
                "url": 'https://www.google.co.kr/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0ahUKEwi0sv3zv8XVAhVGUZQKHfgiCXIQjRwIBw&url=http%3A%2F%2F33jaeseok.tistory.com%2F1199&psig=AFQjCNG4glDsECDsxwx-oOya2OElC2suwg&ust=1502208234269956',
                "width": 640,
                "height": 480
            }
    })


@csrf_exempt
def message(request):
    message = ((request.body).decode('utf-8'))
    return_json_str = json.loads(message)
    return_str = return_json_str['content']
    test = Test.objects.all().first()

    return JsonResponse({
        'message': {
                'text': return_str
            },
            'keyboard': {
                'type': 'buttons',
                'buttons': ['galaxy', 'bega', 'sony']
            },
            "photo": {
                "url": test.testPhoto.url,
                "width": 640,
                "height": 480
            }
    })


        # 응답타입 체크 : content가 "삼성", "엘지" 이런거라면 check_type = maker
        # 코드로는 ex) check_is_maker(user_response)
        # user_response = json_data['content']
        # def check_is_maker(user_response)
        #   maker = Test.objects.all().value??()['test']
        #   for user_response in maker:
        #       if maker:
        #           return maker

        # if check_is_maker(user_response)
        # elif check_is_model(user_response)
        # ...