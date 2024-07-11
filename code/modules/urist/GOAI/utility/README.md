
  A Primer On Utility AI  
==========================

The core decision engine of GOAI is an AI architecture/approach known as Utility AI.

The purpose of this document is to give you a general sense of the key concepts GOAI uses and why they are the way they are.


  Why Utility?  
----------------

A major motivator behind GOAI had been the frustration with SS13 AI's (the code, not the role) limitations.
Historically, what little AI SS13 had had been narrow and rigid, with a lot of assumptions baked in about its nature
(exclusively mobs, and mostly simple hostiles at that), with fixed state transitions.

That in turn means the AI very hard to extend; any additions must fit into the preconceived framework of the kinds of 
actions are allowed and in which order they may trigger.

What if we could add any action, at any time? 
What if we could have the AIs prioritize based on its needs, not on some fixed structure?
What if we could have a fully general framework for AI-of-anything - mobs, objects, squads, factions, events...?
What if all of that was simpler to work with than legacy AIs?
What if all of that had a fairly miniscule performance cost?

What if I told you we ABSOLUTELY CAN get all that?


  Utility in a nutshell  
-------------------------

We get all of the benefits via a fairly simple trick. 
The trick lies in *picking the highest-scored option from our Actions*.
Everything else - the whole complexity - is just in formulating and scoring Actions.

That's it. We feed a pile of actions in, we get a score for each, we pick whatever corresponds to the max score. That's our core decision engine.

The decision engine is declared as a datum, which means we can attach AI to anything from mobs, groups of mobs, terrain, objects, other datums...

This means what our AI can do is completely unrestricted, since there's no specific framework to contort ourselves into.
Adding or removing actions is trivial - just make the input list bigger or smaller.
In theory, we could even score each Action in parallel (although practically, that's inefficient for optimization reasons).

(TECHNICAL NOTE: this is processing through a simple array once for each AI decision tick - very fast, even without the added optimizations)


  Actions 101  
---------------

That's all well and good, but what does all that scoring nonsense actually *MEAN*?

Before we get to that, a quick primer on terminology we'll need.

- **ActionTemplate** is the abstract Thing We're Doing, e.g. Grab<someone?>, PickUp<something?>, Shoot<enemy?>, Walk<somewhere?>.
- **Context** fills in the generic stuff in the ActionTemplate - instead of Grab<someone?>, the Context says 'someone=Bob'.
- **Action = ActionTemplate + Context**, e.g. Grab<Bob>, Shoot<Alice>, PickUp<crowbar at (23,11,2)>
- We'll refer to creating an Action out of these two as *binding a Context to an ActionTemplate*.
- ActionTemplates define a whole bunch of details about the possible activity, such as the handler proc that will handle doing the thing if selected, extra args passed to the handler, priority and more.
- **ContextFetcher (CF)** is a generic (non-OOP) proc; ActionTemplates are associated with one or more of these. ContextFetchers (each) return a list of Contexts for a given ActionTemplate


  Scoring 101  
---------------

If we want to pick 'the best' Action, we need to compare them on even footing, apples-to-apples, for this to make any sense.

We do this by standardizing the score (***Utility***) of each Action to a <0, 1> range.

Each ActionTemplate is associated with zero or more **Considerations** - generic procs representing factors that make an Action more or less useful at a given moment.
This could be a distance to target (regardless of whether we prefer it to be low or high), our health, their health, item value, a dice roll, or more abstract logic - Considerations can be added fairly easily as needed.
Considerations, likewise, return a score between zero and one.

**Each Action starts at Utility=1**. We then feed it through its associated gauntlet of Considerations.
The value returned by each Consideration is treated as a *multiplier*:
e.g. if our first Consideration returns 0.8, then our running Utility becomes 0.8 (<- 1.0 x 0.8);
if a second Consideration ALSO returns 0.8, then after that step, our running score becomes 0.64 (<- 0.8 x 0.8).

As such, anything that is not an *ideal* state for a Consideration doesn't necessarily make us throw the considered Action out altogether, but it dampens our enthusiasm for it. 

(TECHNICAL NOTE: This also provides us with a really nice optimization point - since we want to pick the highest-scoring option, the moment our running score drops below the current best, 
we can drop it from further consideration and save ourselves some time. This is also why we start high and trim the score downwards.)

After all Considerations have been checked (assuming we hadn't discarded the option already), we get an output value between zero and one, 
with zero meaning "this is useless, never do this in this situation" and one meaning "hell yeah let's do it".

This is essentially a form of fuzzy logic, and a very powerful trick. Instead of simply checking if an Action is *allowed*, we have shades of grey in how *favorable* the Action is.
That in turn means even an unlikely candidate still has a fair chance if the situation is desperate - for example, we would prefer to save grenades for groups of enemies, but if 
it's our only weapon, the AI could still choose to throw it at a single foe to keep itself alive.

Note that we score *Actions*, not *ActionTemplates* - throwing a rock at a brick wall would have much lower Utility than throwing it at an angry assailant in front of it.


  Scoring 201 - Priority  
--------------------------

Finally, a slight, regrettable but *necessary* complication to this scheme:

**Priority** is an attribute on ActionTemplates that is used to divide actions into groups - reacting to immediate emergencies like bandaging a bleeding wound being high Priority 
and idle actions like fidgeting with an item while standing guard being low Priority.

Practically, Priority acts as a multiplier on the final output of the Considerations. Priority=1 Actions are worth their 'face value', Priority=2 Actions have their score doubled, P=4 quadrupled, etc.
In other words, at 'full power', a Priority=1 Action will only be preferred as much as a 'half power' Priority=2 Action.

That means that all the rest being equal, the AI is extremely unlikely to prefer messing around to something that will save its life or play their role in a scripted setup, 
but still leaves them a degree of autonomy in their downtime - without requiring any artificial 'override mode'.

The levels are a pure design convention, but as a broad rule-of-thumb:
- Priority = 1: idle/fluff actions, reduced priority
- Priority = 2: routine activity, e.g. patrol, go eat lunch, take a nap, casually search for useful items
- Priority = 4: elevated non-emergency activity, e.g. searching for enemies that have gone hiding after being alerted, pick up something needed soon but not NOW-now.
- Priority = 6: currently used for plan-following, semi-arbitrarily
- Priority = 8: generic life-and-death reactions - combat, hide
- Priority = 16: NO TIME TO DISCUSS DO THIS NOW things like emergency healing or panic
- Priority = 128: 'soft'-forced action; mainly for use-cases like allowing scripted scenes without dropping out of the AI engine


  Considerations 101  
----------------------

As it's your primary dial to turn as an AI designer, it's worth taking a slightly deeper dive into how Considerations work.

A Consideration at the core comprises two procs and two values.

1) ConsiderationInput proc
2) loMark value
3) hiMark value
4) ResponseCurve proc 

A **ConsiderationInput** proc - fetches... Some Value From Somewhere. 
These are provided as fairly generic AI 'building blocks'; for example, one fetches the health of our mob, another calculates our distance to a target, yet another reads an arbitrary var from the target, etc. 
This is another generic proc with a conventional interface, so you can easily contribute more ConsiderationInputs as needed.

By convention, ConsiderationInputs are declared as `/proc/consideration_input_*(action_template, context, requester, consideration_args)`

The value returned by a ConsiderationInput is a number, but it can be ANY number. As established earlier, Utility needs a number in the <0, 1> range, so this won't do.

We handle that by the power of the next three items combined.

The two bookmarks, **loMark** and **hiMark**, narrow down the region of interest for our variable by simply clamping the values.

For example, if hiMark = 10 and ConsiderationInput returned 100, this will be treated as if it returned 10.
Conversely, if loMark = 1 and ConsiderationInput returned 0, this will be treated as if it returned 1.


What happens in between those?

That's when we ***interpolate***. 

The type of interpolation is defined by the **ResponseCurve** proc.

The simplest, very common case is a Linear Interpolation (or LERP). Put simply, we fix our loMark as 0, our hiMark as 1, the halfway point between them is 0.5, etc. 

For example, if loMark = 0 and hiMark = 100, any number between 0 and 100 will be interpreted as a percentage (so e.g. 36 become 0.36).
At loMark = 0 and hiMark = 4, CI=3 corresponds to Utility of 75% (3/(4-0)), CI=1 is 25% (1/(4-0)).

A slight twist is the Antilinear ResponseCurve, which works the same, but with values *decreasing* from loMark at 1 to hiMark at 0.

This can be useful for cases like distance - the AI should generally favor things closer to itself. 
Another example would be healing - we don't particularly feel like using up our healing supplies to deal with a papercut, so higher health -> lesser Utility.

A range of ResponseCurves is available, including square or bell-curve-like, and more can be added. However, linear curves are one of the cheapest, highly reliable tools in our AI toolbox.

By convention, ResponseCurve procs are generic procs declared as `/proc/curve_*(var/input)`

The ResponseCurve will, by definition, return a value in the <0, 1> range that we need.


  Actions in action  
---------------------

We've gone through scoring, we've picked the highest-scored Action - now what?

The AI creates an **ActionTracker** object; the tracker handles bookkeeping for an Action and manages its execution. 

This mainly means the run-state (Pending/Done/Failed/Running), the start time (so we can cancel stuck Actions). 

While the ActionTracker is in a non-terminal state (so Pending or Running), the ActionTracker will *call the Action's Handler proc every Action tick*.
Action ticks as of writing happen every half-second (or 500 ms) since the Action is initialized by default.

The Action proc inside the ActionTracker is non-blocking; the AI can do other things in the background (notably, **automated movement**!), although it will not start another Action.

(TECHNICAL BUZZWORDS: this is effectively something like a Future/Promise in an async runtime)

Optionally, an ActionTracker can also store persistent Action-execution-local variables as arbitrary key/value pairs in a **Blackboard**.
This can be useful for carrying data over between execution ticks (for example, caching values).

The Handler will receive the ActionTracker as an argument and will be expected to handle setting the state to Done/Failed as appropriate, set timeouts, etc.

The assumption is that each handler knows best what its own 'goal state' is and will check if it's been satisfied, setting the Action to Done.
Likewise, it has access to its own state, so it's best equipped to decide when to time out.

**IMPORTANT NOTE TO CONTRIBUTORS:** There is NO mechanism for timing out Actions externally at the moment, so a bad handler script can hang the AI!

The handler receives additional parameters. The whole signature, broadly speaking, is:
1) ActionTracker managing us (always required)
2) Optionally, Context arguments from the keys in the selected Action's Context, if any
3) Optionally, hardcoded arguments from the ActionTemplate (the 'args' list attribute), if any (with Context taking precedence on conflict)

Once the Action is Done (or Cancelled), the Action is removed and a new Action is selected. Rinse and repeat.


  ContextFetchers  
-------------------

With the core loop out of the way, we can loop back to detail the last important concept - **ContextFetchers**.

As a **recap**: a Context specifies what an Action applies *TO*. For movement, this might be the a location to move to. For enemies - our target. For items - a specific choice of item.

A ContextFetcher is, once more, a simple, 'function-style' proc, conventionally declared as `/proc/ctxfetcher_*(parent, requester, context_args)`.

A ContextFetcher always returns *an array of assocs* (i.e. list(list()), with the inner list being assoc).

The inner list represents a single potential Context, with different keys specifying various details of that context. The outer list aggregates all Contexts to consider.

For example, if we're trying to heal ourselves, our return value might look like this: `list(list(item=bandage, target=l_arm), list(item=bandage, target=r_arm), list(item=ointment, target=r_arm))`

You can see that both items to use and targets are shared by pairs of Contexts here - that's why we need each Context to specify *multiple* keys to get the full picture.

Like ConsiderationInputs, ContextFetchers are a basic, fairly generic AI building block and a whole selection of common ones are already included.
This includes fetching adjacent turfs (with filtering for contents if desired), visible enemies, things in view, fetching from other AI components such as Memories and more.


  RECAP  
=========

Utility AI selects the highest-scored Action from all available Actions.

We generate Action datums by scanning through available ActionTemplates. For each ActionTemplate datum, we call a ContextFetcher proc, which returns a list of Contexts.

For all pairs of ActionTemplate + Context, we start with Utility=1 and run them through a series of Considerations which may or may not curb our enthusiasm for choosing that combo.

We wind up with a score between 0 and 1 inclusive. We multiply that by the ActionTemplate's Priority value and get a final score as a floating-point number and pick the highest.

Thanks to this simple model, we can add or remove ActionTemplates on the fly - we do not need to recompile the game to update the AI with new capabilities!

ActionTemplates, ContextFetchers and ConsiderationInputs are all highly modular, simple interfaces which means users can easily extend the framework with new building blocks.

All of this can be wired up to damn near anything - provided we've got the handler procs to do what we want with it.


  Further reading  
-------------------

This is just a basic, if comprehensive, tour of Utility AI in GOAI. 

Some more advanced topics will be covered in separate documents. These topics include:

- SerDe - AI specs are written as JSON files, not as code! If you're happy with the building blocks provided, no recompiles needed!
- SmartObjects - where the ActionTemplates actually *come from*
- GOAP Planner integration (allows GOAIs to plan ahead and deal with complex scenarios)
- AI Brains and their components (Memory, Personality, Relationships, Needs...)
- AI Subsystems (including Senses)
