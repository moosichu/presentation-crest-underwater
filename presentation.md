---
pagetitle: Rendering Underwater in Crest Ocean Renderer
author-meta: Tom Read Cutting
css: css/style.css
references:
  - id: CrestGitHub
    title: 'Crest'
    issued:
      date-parts:
      - - 2020
    URL: https://github.com/crest-ocean/crest
nocite: |
  @CrestGitHub
---

---

### Rendering Underwater in Crest Ocean Renderer {#title data-background-image="img/crest-reversed-optimised.gif" data-background-size=contain}

## What is Crest?

::: notes

Crest is an Ocean Rendering system written for the Unity game engine. There is an open-source implementation available for Unity's built-in render pipeline - in addition to URP and HDRP version of the asset available on Unity's asset store.

:::

---

### {data-background-image="img/out_of_reach_treasure_royale.jpg" data-background-size=contain}

[Out of Reach: Treasure Royale](http://spaceboatstudios.com/)

---

### {data-background-image="img/of_ships_and_scoundrels.png" data-background-size=contain}

[Of Ships & Scoundrels](http://ofshipsandscoundrels.com/)

---

### {data-background-image="img/critter-cove.webp" data-background-size=contain}

[Critter Cove](https://www.play-crittercove.com)

---

### {data-background-image="img/windbound.png" data-background-size=contain}

[Windbound](https://windboundgame.com/)

---

### {data-background-image="img/morild_bridge_simulator.jpg" data-background-size=contain}

[Norild Navigator](https://www.morildinteraktiv.no/morild-navigator)


## The Problems

- What effects should be applied? And how?
- When to apply effects?
- How to handle transition between effects!

---

### Why do you need "Underwater Rendering"?

Simple Problem: Being Underwater "looks" different to being above water.

::: notes

Go to screenshot...

:::

### {data-background-image="img/real_life_meniscus.jpg" data-background-size=contain}


[Photo by Stijn Dijkstra from Pexels](https://www.pexels.com/photo/ocean-and-island-with-houses-during-day-2499791/)

::: notes

Aside from the differences in how the water surface appears depending on which direction you are looking at it from.

(Fresnel effect vs. Total Internal reflection and Schnell's Window)

You also have a whole bunch of effects which need to be applied - more fog, God Rays, floating particles and caustics.

Focus of isn't going to be on how to render all the visual features you get underwater - but instead on something more
subtle and harder - how do you *partially* apply these effects when the camera is only *partially* submerged.

:::

## How effects are applied

---

### Rendering Water Surface

Branch shader when rendering back-faces

. . .

- Branching in shader :(
- Handles transition!
- Single draw-calls
- Simple to implement!

---

### Fog

Apply fog when underwater.

. . .


Light penetration - darken screen as depth increases.


## Transitioning Between "Above" and "Below" Water

Most common solution: cut between views - very few games *actually* show a meniscus

. . .

Crest users expect underwater to "just work".

::: notes

Not all Crest users have the resources available to implement the camera logic necessary to cut between "above" and "below" water views. It's an art to be able to pull that off in an AAA game.

TODO: Game examples: Shadow of the collus, call of duty, uncharted. Counter: Nautica?

Games which do have meniscus: Ubisoft Games (Far Cry 3), Bethesda Games (Skyrim)

:::

## Solution 1: The Skirt

---

### What is a Skirt?

Current solution in `master` branch of Crest - used in URP release as well.

---

### The Idea {data-background-image="img/uncharted_3_skirt.jpg" data-background-size=contain}


[Water Technology of Uncharted, Ochoa & Holder, 2012](https://www.gdcvault.com/play/1015309/Water-Technology-of)


::: notes

Render polygonal "skirt" with an underwater fog shader.

Take skirt used on the cracked window of a giant sinking ship...

Apply it to the player camera!

:::

---

### The Implementation

::: notes

TODO: writeup

:::

---

### {data-background-image="img/skirt_fog.jpg" data-background-size=contain}

---

### {data-background-image="img/skirt_wireframe.jpg" data-background-size=contain}

---

### {data-background-image="img/skirt_ocean_gap.jpg" data-background-size=contain}

---

### {data-background-image="img/skirt_final_result.jpg" data-background-size=contain}

---

### {data-background-image="img/skirt_wireframe_with_ocean.jpg" data-background-size=contain}

---

### The Problems

- Not Perfect!
- Assumes single-divide between "above" and "below" - top-down handled poorly.
- Handling VR is hard!
- Code can be hard to follow!
- Ocean surface shader re-applies fog!
- Hard to manage across BIRP, URP & HDRP
- Shader params have to match *perfectly*


::: notes

TODO

:::

---

### {data-background-image="img/skirt_angle_gap.jpg" data-background-size=contain}

---

### {data-background-image="img/skirt_angle_gap_wireframe.jpg" data-background-size=contain}



## Solution 2: Post Process Effect

---

### Idea

"Simpler" and "More Robust" solution.

. . .

PR has been open since 20th of July... 2019!

. . .

185 commits, 44 files changed, ~1200 LOC

. . .

More LOC deleted than added!

---

### Still worthwhile?

Yes!

---

### The Challenge

Which pixels are "Underwater"?

---

### The Query

Is the pixel above or below the water surface?

---

### The solution?

Hard Problem: not a lot of games solve it!

Could not find *any* published material on this topic...

But *some* games do this. Same technique re-invented multiple times?

---

### The solution? (Cont.)

Assume water "horizon" intersects far-plane of camera-frustum at fixed world-space height.

. . .

True for Crest as we have a skirt

. . .

TODO: Show Screenshot!

---

### The Mask

Re-render water to mask-buffer, sample in PP shader.

```GLSL

bool isUnderwater = mask == UNDERWATER_MASK_WATER_SURFACE_BELOW || (isBelowHorizon && mask != UNDERWATER_MASK_WATER_SURFACE_ABOVE);

```

Mask can also be used to avoid rendering caustics on water surface.

. . .

If custom engine... could use stencil buffer.

---

### Works well but...

Weird artifacting :(

TODO:Show screenshot of horizon issue...

---

### Look at implementation

TODO: Show how code changed over time...

TODO: Show solutions that developed...

TODO: Show that still not perfect... - but close!

## Other concerns

---

### Supporting local water bodies!

Have to be careful about constructing list of ocean tiles to render to the mask!

TODO: Show code

## Future Work

- Volumetric Effects - Particles, Fog
- Using the stencil buffer?
- Transparency Windows (TODO: Get Screenshots)


## The End

::: notes

I hope you found this interesting!

:::

---

### Special Thanks

- Huw Bowles
- Dale

---

### Social Media

Subscribe to our [YouTube Channel](https://www.youtube.com/channel/UCahevy2N_tj_ZOdsByl9L-A)!

Find Crest on [GitHub](https://github.com/crest-ocean/crest) and the Unity Asset Store.

---

### Further Watching

- TODO: Add Crest Siggraph Talks!

---

### References

::: {#refs style='font-size: 0.5em'}
:::

### Q&A


