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

### Rendering Underwater in Crest Ocean Renderer {#title data-background-image="img/crest-reversed-optimised.gif" data-background-size=contain style="color:white; text-shadow: 0px 0px 4px black;"}

## What is Crest?

::: notes

Crest is an Ocean Rendering system written for the Unity game engine. There is an open-source implementation available for Unity's built-in render pipeline - in addition to URP and HDRP version of the asset available on Unity's asset store.

:::

---

### {data-background-image="img/out_of_reach_treasure_royale.jpg" data-background-size=contain style="color:white;"}

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

Game examples: Shadow of the collus, call of duty, uncharted. Counter: Nautica?

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

Render a skirt - ocean has to render fog again in back faces and match skirt exactly.

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

. . .

If solved - everything "just works".

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

True for Crest as we extend-out way-beyond camera frustum!

---

### {data-background-image="img/camera_intersect_horizon.jpg" data-background-size=contain}

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

### {data-background-image="img/mark_horizon_flat_ocean.jpg" data-background-size=contain}

---

### {data-background-image="img/mark_horizon_location.jpg" data-background-size=contain}

---

### {data-background-image="img/mark_ocean_mask.jpg" data-background-size=contain}

---

### {data-background-image="img/mark_final_result.jpg" data-background-size=contain}



## Post-Process - The Correct Solution?

Works Well! But...

---

### Weird artifacting :(

---

### {data-background-image="img/horizon_line_issue.jpg" data-background-size=contain}

---

### The "Horizon-Line" Issue

- Really hard to repro - happens for a single-frame as camera is moving.
- Camera has to be at specific angles & positions to trigger it.
- Different sensitivity on different hardware.

. . .

- Each time we "solved" it - we had just made the repro case harder. :(

---

### The Cause?

Floating-point precision issues :/

. . .

Cannot "just-use" doubles in shader.

. . .

Probably for the best...

---

### Implementation 1 - Vertex Shader

```glsl
float2 pixelCS = input.uv * 2 - float2(1.0, 1.0);
float4 pixelWS =
  mul(_InvViewProjection, float4(pixelCS, 1.0, 1.0));
output.viewWS_farPlanePixelHeight =
  (pixelWS.xyzy/pixelWS.w);
output.viewWS_farPlanePixelHeight.xyz =
  _WorldSpaceCameraPos -
  output.viewWS_farPlanePixelHeight.xyz;
```

Check `pixelHeight` is less than ocean height in pixel shader...

---

### Implementation 2 - Calculate Ocean Height in Clip Space

[48872a990e48feb7c2e944f435b10a6bd3642343](https://github.com/crest-ocean/crest/pull/299/commits/48872a990e48feb7c2e944f435b10a6bd3642343)

```glsl
float3 oceanPosWS
  = float3(pixelWS.x, _OceanHeight, pixelWS.z);
float4 oceanPosCS
  = mul(_ViewProjection, float4(oceanPosWS, 1.0));
float oceanHeightCS = (oceanPosCS.y / oceanPosCS.w);
output.viewWS_oceanDistance.w
  = pixelCS.y - oceanHeightCS;
```

Pixel shader checks `oceanDistance < 0`.

---

### Implementation 3 - Move Calculation to Pixel Shader

[cb4b9ce6948b19f37201069dd2416037253eb720](https://github.com/crest-ocean/crest/pull/299/commits/cb4b9ce6948b19f37201069dd2416037253eb720)

Exactly the same as before... just done in pixel shader.

August, 2019

::: notes

This solution lasted *a while* and even shipped in Crest HDRP.

Everything seemed find for the first couple weeks, then the bugs started coming
in.

:::

---

### Implementation 4 - Calculate Horizon Line on CPU

~80 LOC, calculate normal and position of horizon line.

Implemented by Huw.

April, 2020

---

### Implementation 5 - Horizon Line Fudge

Dirty Hack!

Nudge horizon line up if below water, down if above water.

```CS
horizonSafetyMarginMultiplier /=
  Mathf.Lerp(1f, camera.aspect, angleFromWorldNormal);
resultPos +=
  resultNormal.normalized * horizonSafetyMarginMultiplier;
```

. . .

Assumption - camera at water-level, mask more likely to cover horizon.

Polished by Dale Eidd

::: notes

I did initial implementation, Dale polished it further and eliminated some bugs.

:::

### Journey Over?

Hopefully this one is!

## Other Concerns!

---

### Supporting local water bodies!

Have to be careful about constructing list of ocean tiles to render to the mask!

. . .

Always render "culled" tiles in post-process mask. Solved other problems as well!

::: notes

We still render a global "ocean" for local water bodies such as rivers and lakes,
but we just cull everything that isn't explicitly rendered. However - those tiles
still exist and can be rendered to the mask as a continuous surface.

:::

---

### VR

Have to support multi-pass, single-pass and single-pass instanced...

A bit easier in post-process shader, but mask needs to be instanced.

---

### Unity Bugs

Doesn't work with Post-Process stack in BIRP...


## Future Work

- Volumetric Effects - Particles, Fog, Crepuscular Rays
- Using the stencil buffer?
- Transparency Windows!

---

### {data-background-image="img/window_inside_out.jpg" data-background-size=contain}

::: notes

Have to render fog behind transparent material - so part of transparent material shader.

:::

---

### {data-background-image="img/window_outside_in.jpg" data-background-size=contain}


## The End

::: notes

I hope you found this interesting!

:::

---

### Special Thanks

- Huw Bowles
- Dale Eidd

---

### Social Media

Subscribe to our [YouTube Channel](https://www.youtube.com/channel/UCahevy2N_tj_ZOdsByl9L-A)!

Find Crest on [GitHub](https://github.com/crest-ocean/crest) and the Unity Asset Store.

---

### Further Materials

- [Crest: Novel Ocean Rendering Techniques in an Open Source Framework (2017)](http://advances.realtimerendering.com/s2017/)
- [Multi-resolution Ocean Rendering in Crest Ocean System (2019)](http://advances.realtimerendering.com/s2019/index.htm)

---

### References

::: {#refs style='font-size: 0.5em'}
:::

### Q&A


