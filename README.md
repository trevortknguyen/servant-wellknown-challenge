# Servant Wellknown Challenge for LetsEncrypt (for Heroku)

This project intends to facilitate obtaining certificates from [CertBot](https://certbot.eff.org/) using the
[HTTP challenge method](https://certbot.eff.org/docs/challenges.html).

More specifically, it's for people who want to do the manual SSL certificates on Heroku and would like to
deploy a container to meet the HTTP challenge.

That may not make much sense if you're like me, knowing not much about cybersecurity. Here's the use case.

You want to have a website and you're putting it on something like Heroku. Heroku offers an automated certificate
management if you're paying them money for a Hobby dyno. This is a good idea if you're doing anything relatively
important because you don't want your site to be unavailable when users visit. However, for some things, you want SSL,
but don't need the Hobby dyno. Good news! There's LetsEncrypt, which provides certificates for free.

But what does that actually mean? You'll need a certificate for your system and LetsEncrypt will generate one for you.
You could generate it yourself, but then you would have a self-signed certificate, which isn't very trustworthy and only
really useful for local development. You want a certificate from a certificate authority.

In order for LetsEncrypt to generate a certificate it is ideally a command line program on the Heroku machine. You can
technically do this, but I decided not to. A method to run the command line program on your local machine means you tell
LetsEncrypt (really, CertBot) where your server is. It asks "Okay, if it's really your server, put this weird string in
this weird place, and when you've done that we'll talk."

You get something that looks like this:

```
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
NOTE: The IP of this machine will be publicly logged as having requested this
certificate. If you're running certbot in manual mode on a machine that is not
your server, please ensure you're okay with that.

Are you OK with your IP being logged?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: Y

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Create a file containing just this data:

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy

And make it available on your web server at this URL:

http://xxxxxxxxxxxxx.xxxxx.xx/.well-known/acme-challenge/xxxxxxxxxxxxxxxxxxxxxxxxxuxxxxxxxxxxxxxxxxx

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```


Yes, but what if we're not really running something we can edit like that? In my case, I was running a Heroku button for
the Slack auto invite tool. It's written in Python and I don't want remember how to add a route in Flask. Once you leave
Python, you don't want to go back.

So here are my requirements: I need something that can be easily deployed in place of my project serving the esoteric
challenge string. That way I can put my project back. I like deploying Docker containers, so this is what I did.

You'll need to set some environmental variables. If you have a `.envrc` file, it will need to look like this:

```
export HEROKU_APPNAME=xxxxxxxx-xxxxxxx-xxxxxxx
export CHALLENGE_FILENAME=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
export CHALLENGE_DATA=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
```

After setting those and making sure you're logged into the Heroku CLI, you can run the `./deploy.sh` script.

# Weaknesses

This requires you to take your server offline, but if you're not okay with that, why are you cheaping out on a
free Heroku dyno?

# Acknowledgements

https://medium.com/should-designers-code/how-to-set-up-ssl-with-lets-encrypt-on-heroku-for-free-266c185630db

