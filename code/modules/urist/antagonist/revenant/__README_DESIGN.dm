/*
===================================
=                                 =
=       BLUESPACE REVENANTS       =
=                                 =
===================================


This is a UristMcStation's own homebrewed-donut-steel gamemode/antag.

ELEVATOR PITCH VERSION: Procedurally generated, player-controlled humanoid SCP.

This wasn't an actual part of the original concept (this is actually originally a Vampire mode redesign!),
but for practical purposes, this is pretty much what a BSR amounts to.

Lore-wise, this is very flexible, but it's basically a walking, talking Anomaly.

Generally, it's someone who either had a run-in with either silly space magic nonsense, or fell into hyperspace, or whatever.

The handwaveyness is very much relevant - because the exact nature of what a BSR is and does is generated based on tags; it's almost a *roguelite* antag.


===  Designey/balancey things  ===


There's three core design concepts to them: *Powers*, *Hungers* and *Distortions*:

    - *DISTORTION* plays the role of an IC objective/incentive to action.
      A BSR is a little bit unreal, and they glitch reality out just by existing like a source of radiation (and even worse with Powers).
      This is bad for them and bad for the crew, because all sorts of nonsense will start happening if they hang out in one spot for too long.

    - *HUNGERS* are a counter to Distortion. It's some weird need that, if indulged, suppresses Distortion.
      This can be anything from eating bits of the station, through Great Value cult runes, to drinking blood.

    - *POWERS* are your stock extra abilities.
      The only quirk aside from procgen selection is that their cost is generally surplus Distortion.

The whole point of this exercise is to make this antag as hard to make boring as possible.
If you stealthantag too long, Distortion will build up and make you increasingly obvious.
To avoid that, you need to go and engage with the round. Win.
You can peaceantag, but your very existence messes things up, so there's still a conflict.


-- BALANCE --

Currently, you can expect somewhere around 10 mins of a grace period where if you do nothing at all and stand around in one place, you should generally be fine.
After that point, Distortions will start to appear unless you move around.

This means that an antag that SSDs/alt-tabs on roundstart will start 'smoking' by the 10-min mark.

A deliberate part of the design is that Distortion feeds on itself.

This means that for a BSR who does move around in that period,
while they do spread out the initial 10 minutes' worth of Distortion,
the reality-warping rate by the 10-min mark is significantly higher than at roundstart.

It's sublinear growth, so it's does not become too crazy too fast, but it does mean that you cannot just sprint around the station to maintain stability.
Eventually, you will start warping locations fast enough that you cannot outrun the Distortion.

Hungers, however, DO help - significantly.

The Distortion rate is not based on total Distortion but on unsuppressed Distortion.
That means that for any amount of Suppression >= Total Distortion, a BSR is entirely stable.
If Suppression = 50% Total Distortion, we're effectively halving the amount of Distortion for calculating reality warp.

However, every single Hunger power has an expiry date.
So, players are forced to continue being engaged with the systems.
Even if you wallpaper the station with Wards, they will deactivate - and Distortion keeps on growing steadily...
(plus, for Wards specifically, since they're a bit hands-off I've explicitly capped their max effectiveness :^))

*/
