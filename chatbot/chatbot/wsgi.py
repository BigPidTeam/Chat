"""
WSGI config for chatbot project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/1.11/howto/deployment/wsgi/
"""

import os, sys

sys.path.append('/home/ubuntu/Chat/chatbot')
sys.path.append('/home/ubuntu/chatenv/lib/python3.5/site-packages')

from django.core.wsgi import get_wsgi_application

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "chatbot.settings")

application = get_wsgi_application()
