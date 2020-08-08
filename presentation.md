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

### Rendering Underwater in Crest Ocean Renderer

---

### What is Crest?

TODO: Add some good screenshots!

::: notes

Crest is an Ocean Rendering system written for the Unity game engine. There is an open-source implementation available for Unity's built-in render pipeline - in addition to URP and HDRP version of the asset available on Unity's asset store.

:::

## The Problems

- What effects should be applied? And how?
- When to apply effects?
- How to handle transition between effects!

---

### Why do you need "Underwater Rendering"?

Simple Problem: Being Underwater "looks" different to being above water.

::: notes

TODO: Show real-life image of how underwater looks different to being above water - and the complex features you have.

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

Most common solution: cut between views.

. . .

Crest users expect this to "just work".

::: notes

Not all Crest users have the resources available to implement the camera logic necessary to cut between "above" and "below" water views. It's an art to be able to pull that off in an AAA game.

TODO: Game examples: Shadow of the collus, call of duty, uncharted. Counter: Nautica?

:::

## Solution 1: The Skirt

---

### What is a Skirt?

- Current solution in `master` branch of Crest - used in URP release as well.

--- 

### The Idea


::: notes

TODO: reference Uncharted 3 paper, implemented by huw etc.

:::

---

### The Implementation

::: notes

TODO: writeup

:::

---

### The Problems

- Not Perfect!
- Assumes single-divide between "above" and "below" - top-down handled poorly.
- Handling VR is hard!
- Code can be hard to follow!
- Ocean surface shader re-applies fog!
- Hard to manage across BIRP, URP & HDRP


::: notes

TODO

:::

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


