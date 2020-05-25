# Sample Server + Mobile App JWT

By: Andrew Chen Wang

Created: 2 March 2020

This application contains the Django server running with DRF and SimpleJWT in order to demonstrate how apps should communicate with JWT (an access and refresh token).

Detailed in each application is what I've done. PLEASE DO iOS development first and deploy your web app FIRST. Android local development is a pain in the bum... Just trust me and you can ignore some of those aforementioned weird XML stuff and just use your regular domain.

---
### Why use JWT?

JWT authentication is widely accepted as a safer version of authentication for end users rather than constantly sending a username and password. In this demonstration, I'm keeping my tokens (on the mobiles) in their respective device's safe storage unit, widely known as a keychain.

We use JWTs in case our user is inside of an unsafe network. These JWTs are encrypted but do not contain the user's password or username. So even if a token is stolen, since everyone should be using a HTTPS server (please... for the love of god), the theif can only do so much with the limited amount of time the access token can have (default is 5 minutes).

When implementing your own server, simply make sure you are using some basic security measures, such as using salted and hashed passwords (default in Django), reset password links are sent to emails rather than directly being able to do it through a view, and making sure you are not exposing ports on accident that can be susceptible to attacks.

Those are some basics and only SOME of the vulnerabilities that any server should have.

---
### How to setup

1. Clone or download this repository
2. To run the server, create a virtual environment `virtualenv venv && source venv/bin/activate`, install packages `pip install -r requirements.txt` -- the requirements.txt file is inside the server subdirectory -- and do `python manage.py migrate && python manage.py runserver`.
    - Again, make sure when you do this, you are inside the server directory on your terminal/cmd.
    - On Windows, you should do `venv\Scripts\activate` instead of `source venv/bin/activate`
3. To test on the mobiles, open either the `jwt-ios` or `jwt-android` subdirectory using their respective IDEs (iOS only works on Macs with Xcode! Android Studio works on any platform.).

A default user with the username `test` and password `test` have been created.

**When going into production (and testing for android), you'll want to change the urls in the code obviously. For Android, there are specific instructions on configuration for BOTH local and production.**

---
### FAQ

Why am I getting a 403 status code instead of a 401?
- For some reason, you MUST have the SimpleJWT authentication set first in your iterable in the REST_FRAMEWORK setting, before SessionAuthentication (or whatever other backends you use).

Why the negativity against Android?
- Deprecations, minSdks, steep learning curve (even for senior devs, it's still hard), outdated SO questions and tutorials, etc.
- Also, there is this heavy push to have OAuth connection to Google when developing for Android... I'll get a new repo up for those wishing for that kind of integration, but it's one hell of a push by Google.
- Deprecation. Deprecation. Deprecation. iOS is chill with this since the OS is proprietarily used for iOS only. If you want to put a mood meter for the iOS and Android dev subreddits, you'll see that Android breaks the meter.

---
### Technical Details

- Django 3.0.3 and DRF 3.11.0 + SimpleJWT 4.4.0
- Swift 5.1 for development
- Android MinSDK 22 Target 29 Kotin 1.3.70

---
### License

```
Copyright 2020 Andrew Chen Wang

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
