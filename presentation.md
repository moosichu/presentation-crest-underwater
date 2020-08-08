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

## The Problem

---

### Why do you need "Underwater Rendering"?

Simple Problem: Being Underwater "looks" different to being above water.

::: notes

TODO: Show real-life image of how underwater looks different to being above water - and the complex features you have.

:::

---

### Transitioning Between "Above" and "Below" Water

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


::: notes

TODO

:::

## Solution 2: Post Process Effect

---

### Idea

"Simpler" and "More Robust" solution.

. . .

PR has been open since 20th of July... 2019!

---

### Still worthwhile?

Yes!

TODO: Continue presentation outline.


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


