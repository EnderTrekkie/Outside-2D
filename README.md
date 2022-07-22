# Outside
## Overview

 Outside is an open-world 2d survival game where you are a dinosaur surviving by defeating other dinos. 

### Showcase Video

https://youtu.be/SC2bmszsuN4

## Functionality

Beating a foe also replenishes your hunger bar, which gets slowly converted into Health and Stamina. pressing R makes this conversion faster, but less efficient.

## Entities
### Trees

Trees provide cover from foes as you are less visible through its leafy branches, but only when you are still. Use these when you're low on health.

### Predators
Predators track towards you and damage you. Pressing space attacks the area in front of you. Positioning yourself is tricky.

### Prey
Prey are smaller creatures that run away from you, but usually you're faster.

## Stats
Defeating other dinos gives XP. Leveling grants a skill point which you can spend by pressing E.

The player's armor points allow him to resist attacks, and are thus more expensive, requiring 2 points instead of 1. If an enemy does less damage than the player's armor, he takes none.

Speed points make the player move faster, allowing for an easier time fleeing or pursuing.

Strength points increase damage dealt per hit.

Health points increase the number of hits the player can take before dying.

## Temperature
The game includes a temperature system where if the player becomes too hot or too cold (depending on the biome he's in), he takes damage. 

There are no penalties for being in a temperate climate. In fact, your temperature approaches normal in these areas.

In cold biomes like snowy forest, snowy plains, mountains, and glacier, the player suffers the cold. 

In hot biomes like wastes, savanna, or desert, the player heats up.



## Time

There is a day/night cycle, mainly for aesthetics. The only functionality in it is that the player doesn't heat up in the night.

## States

There are four states: `StartState`, `PlayState`, `MenuState`, and `DeadState`.

1. There's not much in the `StartState`, just a background and some text.

1. Most of the action happens in the `PlayState`, like fighting, exploring, and leveling.

1. The `MenuState` allows you to advance and become stronger. this is where you go to when you press E.

1. The `DeadState` is about as boring as the menu state. the game gets reset.

## Terrain Generation

I researched and used perlin noise to make an infinite open world. This generated both wet-dry and hot-cold biomes.
I used memoization to reduce the recomputation of the tiles on each frame render.
Each world has its own seed with deterministic terrain matching that seed. Game-saves are tricky, so I omitted those. Neither did I let the user specify a seed like in Minecraft.

Trees and entities are randomly generated and despawn when you're too far away.

## Things learned while developing
* Perlin noise
* simple AI (not just moving in straight lines)
* force-based movement
