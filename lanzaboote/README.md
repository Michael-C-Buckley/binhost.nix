# Lanzaboote "bin"

This is a pre-built set of packages I'm using for myself.
If you don't know why you want this, don't use it and instead support the [Official Release](https://github.com/nix-community/lanzaboote).

I use it to stop weaker devices from attempting to ever build Lanzaboote in the event of a nix cache miss or depedency change.
It also has the benefit of weakening my dependency graph (which never seems to stop growing).

## Threat Model
This is a binary package I prepared on my system. While convenient to consume, you should consider this as a secure booter or aspirant:

- Chain of Trust
- Breakage

I could have tampered with the binary controlling a pivotal aspect of your system.
Additionally, issues with secure boot problems can brick a system if done incorrectly.

