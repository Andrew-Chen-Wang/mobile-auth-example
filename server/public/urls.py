from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
    path('api/token/access/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/both/', TokenRefreshView.as_view(), name='token_refresh')
]

"""
- For the first view, you send the refresh token to get a new access token.
- For the second view, you send the client credentials (username and password)
  to get BOTH a new access and refresh token.
"""
