# Swift Version

Built with Swift 5.1. We assume you have already registered for a user. Login.

### How this works

Once you're logged in, the iOS thing will ping the server every second. This is to replicate some user usages such as an expired access token upon request during an infinite scroll or simply having an expired refresh token.

If you change your password in the admin view, then you will be redirected to the LoginViewController.

### Technical Details

I'm new to frontend development, so, from past experience, I had to find a nice networking framework that I liked. After scouring the internet, I decided this one was the one: https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908

Many articles were talking about SCP and the MVVM methodology. For me, these hierarchies are neat (and I've noticed many downsides) but this one seemed to work well regarding code legibility and efficiency. It replicates the Moya framework which apparently seems to be highly regarded; however, taking a look at their Source directory, that repository is huge, so I'm sticking with this neat tutorial that provides an amazing architecture.
