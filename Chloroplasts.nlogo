breed [co2s co2]
breed [o2s o2]
breed [h2os h2o]
breed [sugars sugar]
breed [photons photon]
breed [chloroplasts chloroplast]
breed [atps atp]
breed [panels panelp]
breed [carbon-complexes carbon-complex]
breed [flows flow]
breed [side-panels side-panel]
breed [key-labels key-label]
breed [breaks break]

co2s-own [for-key]
o2s-own [for-key]
h2os-own [bound-to for-key]
photons-own [bound-to for-key]
atps-own [pair my-chloroplast state for-key]
sugars-own [for-key]
key-labels-own [for-key]


panels-own [pair my-chloroplast state age]
carbon-complexes-own [my-chloroplast ]
patches-own [region]


globals [
  #-co2-molecules
  #-o2-molecules
  #-glucose-molecules-produced
]

to start-up
  setup
end


to setup
  clear-all
  ;import-world "Zoom.csv"
  ; import-drawing "Zoom.png"

  set #-co2-molecules initial-carbon-dioxide
  set #-o2-molecules 0
  set #-glucose-molecules-produced 0


  create-co2s initial-carbon-dioxide [setxy (-10 + random-float 20) random 20  set-shape-size ]


  create-sugars 1      [setxy 14.2 -5.5 set-shape-size set for-key 1]
  create-key-labels 1  [setxy 16 -6.8 set shape "empty" set label "sugar (glucose)"]
  create-breaks 1     [setxy 13.95 -3.8 set shape "break" set color gray + 2 set size 6.7]

  create-key-labels 1  [setxy 15.2 -7.6 set shape "empty" set label "molecule"]
  create-co2s 1        [setxy 14.2 -1.5 set-shape-size set for-key 1]
  create-key-labels 1  [setxy 16.2 -2.4 set shape "empty" set label "carbon dioxide"]
  create-breaks 1     [setxy 13.95 -0.0 set shape "break" set color gray + 2 set size 6.7]


  create-key-labels 1  [setxy 15.2 -3.1 set shape "empty" set label "molecule"]
  create-o2s 1         [setxy 14.2 1.4 set-shape-size set for-key 1]
  create-key-labels 1  [setxy 16.4 0.7 set shape "empty" set label "oxygen molecule"]
  create-breaks 1     [setxy 13.95 2.8 set shape "break" set color gray + 2 set size 6.7]

  create-h2os 1        [setxy 14.3 4.4 set-shape-size set for-key 1]
  create-key-labels 1  [setxy 16.1 3.7 set shape "empty" set label "water molecule"]
  create-breaks 1     [setxy 13.95 5.8 set shape "break" set color gray + 2 set size 6.7]


  create-key-labels 1 [setxy 14.3 7.5 set color yellow + 3 set size 0.6 set heading 135 set shape "ray" set for-key 1.2]
  create-key-labels 1  [setxy 14.5 6.5 set shape "empty" set label "light"]
  create-key-labels 1  [setxy 14.3 9 set shape "empty" set label-color black set label "KEY"]
  if initial-#-of-chloroplasts > 0 [make-initial-chloroplasts]
  make-system-boundary
  make-flows
  reset-ticks
end

to set-shape-size
  let new-size 2.5
  if breed = sugars [set shape "sugar" set color black set size new-size ]
  if breed = chloroplasts [set color [0 200 0 150] set shape "circle" set size 4 ]
  if breed = h2os [set shape "h20"  set color black set size new-size ]
  if breed = co2s [set shape "co2" set color black set size new-size ]
  if breed = o2s [set shape "o2" set color black set size new-size ]
  if breed = photons [set color yellow + 3 set size 0.6 set heading 135 set shape "ray"]
end

to make-initial-chloroplasts
  let angle-increment 0
  let off-set random 360
  let divider 360 / initial-#-of-chloroplasts

  repeat initial-#-of-chloroplasts [
  create-chloroplasts 1 [

    set heading (off-set + (angle-increment * (divider)  + random (divider / 3) - random  (divider / 3)))
    fd (3.5 + random-float 3.5)
    set-shape-size
    ]
    set angle-increment angle-increment + 1
  ]

  ask chloroplasts [
    let atp-count 0
    let atp-offset random 60
    let this-chloroplast self
    let this-pair 0
    set heading 0


    repeat 3 [
      repeat 2 [
        hatch 1 [set breed atps set heading (atp-offset + (atp-count * 60)) set my-chloroplast this-chloroplast set hidden? true set pair this-pair set state 0]
        set atp-count atp-count + 1
      ]

      set this-pair this-pair + 1
    ]
  ]

end

to make-flows
  create-flows 1 [set heading 90 set hidden? true]
end

to make-system-boundary
    ask patches [
    if ((pxcor < -9 or pxcor > 10) and (pycor = max-pycor or pycor = min-pycor)) or (pycor = max-pycor or pycor = min-pycor) or (pxcor = -10 or pxcor = 10 ) or (pycor = 0 and pxcor < -10 ) or (pxcor = min-pxcor or pxcor = max-pxcor) [
      sprout 1 [set breed side-panels set shape "square" set size 1.2 set color [180 180 180]]
    ]

    if ((pxcor = -9) or ((pxcor >= -9 and pxcor < 10) and pycor = max-pycor)) [set region 3]
    if (pxcor >  -9 and pxcor < 10 and pycor != max-pycor)    [set region 4]

    if ((pxcor = 10) or ((pxcor >= -9 and pxcor < 10) and pycor = min-pycor)) [set region 5]
    if (pxcor > 10)    [set region 6]


    if region = 4 [sprout 1  [set shape "square" set size 1.2 set color sky + 2 stamp die]]
    if region = 6 [sprout 1  [set shape "square" set size 1.0 set color gray stamp die]]
     ]
end




to do-photon-flow

  if intensity-of-light > random 100 [
  ask n-of 1 patches with [region = 3] [
    sprout 1  [
      set breed photons
        set-shape-size
        set hidden? true
    ]

  ]
  ]
  ask photons [
    if for-key != 1 [fd 0.15 set bound-to 0]
    if for-key != 1 and region = 5 [die]
    if pxcor >= -9.6 [set hidden? false]
  ]

end

to do-water-flow
  if waterflow-through-leaf > random 100 and random 3 = 0 [
    ask n-of 1 patches with [region = 3 and pycor < max-pycor]  [
      sprout 1 [
        set breed h2os
        set-shape-size
        set hidden? true
        create-link-from one-of flows [ tie set hidden? true ]
      ]
    ]
  ]
  ask h2os [
    if for-key != 1 [fd 0.01 rt random 10 lt random 10]
    if (pxcor >= 10 and for-key != 1 ) [die]
    if for-key = 1 [set hidden? false]
    if pxcor >= -9.6 [set hidden? false]
    if pycor > (max-pycor - .4) [set hidden? true]
    if pycor < (min-pycor + .4) [set hidden? true]
  ]

end


to do-sugar-flow
    ask sugars [
    if for-key != 1 [fd 0.005 rt random 10 lt random 10]
    if (pxcor >= 10 and for-key != 1 )[die]
    if for-key = 1 [set hidden? false]
  ]
end


to do-gas-flow
  ask co2s with [for-key != 1] [
    fd 0.08 rt random-float 0.005 lt random-float 0.005
    if xcor > 10 [set xcor -9]
    if xcor < -9 [set xcor 10]
  ]
  ask o2s with [for-key != 1]  [fd 0.05]
end


to go

 if (not auto-stop? or ticks < stop-at) [
  ask turtles with [breed = co2s or breed = o2s or breed = h2os or breed = sugars or breed = photons] [
    ifelse region = 4 or for-key = 1 [set hidden? false][set hidden? true]
  ]
  do-photon-flow
  do-water-flow
  do-sugar-flow
  do-gas-flow
  ask flows [fd 0.05]
  ask side-panels [set hidden? false]


  update-atps
  update-chloroplasts
  update-counts

  tick
  ]
end


to update-atps


  ask atps with [state = 0] [
    let this-pair pair
    let this-chloroplasts my-chloroplast
    let h2os-near-me h2os in-radius 2
    let photons-near-me photons in-radius 2
    let total-atps atps with [pair = this-pair and my-chloroplast = this-chloroplasts  and state = 0]
    let other-charged-atps atps with [pair != this-pair and my-chloroplast = this-chloroplasts  and state = 1]
    if any? photons-near-me and any? h2os-near-me and not any? other-charged-atps  [
      if count h2os-near-me >= 2 and count total-atps = 2 [

        ask one-of h2os-near-me  [die]
        ask one-of other h2os-near-me [die]

        hatch 1 [set breed o2s set shape "o2" set size 2 set heading random 360]
        set hidden? false set state 1
        ask total-atps [set hidden? false set state 1]
    ]
    ]
  ]
  ask atps [ask photons in-radius 2 [die]]

  ask atps with [state = 1] [
    let this-pair pair
    let this-chloroplasts my-chloroplast
    let total-atps atps with [not hidden? and pair = this-pair and my-chloroplast = this-chloroplasts  and state = 1]

     ; show count total-atps
    if count total-atps = 2 [
      let co2s-near-me co2s in-radius 2
     ; show count co2s-near-me
      if count co2s-near-me >= 2 [

      let other-atps one-of other total-atps

      ask one-of co2s-near-me [
        set heading [heading] of myself
        setxy ([xcor] of myself) ([ycor] of myself)
        set breed carbon-complexes
        set my-chloroplast this-chloroplasts
        set shape "carbon-complexes"

        ask one-of other co2s-near-me [
          set heading [heading] of other-atps
          setxy ([xcor] of other-atps) ([ycor] of other-atps)
          set breed carbon-complexes
          set my-chloroplast this-chloroplasts
          set shape "carbon-complexes"
        ]
        hatch 1 [set breed o2s set shape "o2" set size 2 set heading random 360]
      ]
      ask total-atps [set state -1]

    ]

    ]
  ]
  ask atps with [state = 1] [set hidden? false set color (orange + 3 + random-float 1) set shape (word "electric-" random 10)]
  ask atps with [state != 1] [set hidden? true]


end

to  update-chloroplasts
    ask chloroplasts [
    let this-chloroplast self
    let my-carbon-complexes carbon-complexes with [my-chloroplast = this-chloroplast]
    if count my-carbon-complexes = 6 [
      ask my-carbon-complexes with [my-chloroplast = this-chloroplast] [die]
      hatch 1 [set breed sugars set shape "sugar" set color black set heading random 360 set size 2 create-link-from one-of flows [ tie set hidden? true ]]
     set #-glucose-molecules-produced #-glucose-molecules-produced + 1
      ask atps with [my-chloroplast = this-chloroplast] [set hidden? true set state 0]
    ]

  ]
end


to update-counts
  set #-co2-molecules count co2s with [for-key != 1]
 set #-o2-molecules count o2s  with [for-key != 1]


end
@#$#@#$#@
GRAPHICS-WINDOW
342
10
930
409
-1
-1
21
1
14
1
1
1
0
1
1
1
-9
18
-9
9
1
1
1
ticks
30

BUTTON
6
10
108
45
setup/reset
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
5
120
189
153
initial-carbon-dioxide
initial-carbon-dioxide
0
200
100
1
1
NIL
HORIZONTAL

BUTTON
115
10
220
45
go/pause
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
4
153
189
186
waterflow-through-leaf
waterflow-through-leaf
0
50
25
1
1
NIL
HORIZONTAL

SLIDER
5
188
188
221
intensity-of-light
intensity-of-light
0
100
50
1
1
NIL
HORIZONTAL

SLIDER
6
85
188
118
initial-#-of-chloroplasts
initial-#-of-chloroplasts
0
6
3
1
1
NIL
HORIZONTAL

MONITOR
192
100
337
137
carbon dioxide molecules
#-co2-molecules
17
1
9

MONITOR
192
142
337
179
oxygen molecules
#-o2-molecules
17
1
9

MONITOR
192
185
336
222
sugar molecules produced
#-glucose-molecules-produced
17
1
9

PLOT
11
226
339
428
Number of molecules
time
NIL
0
2000
0
100
true
true
"" ""
PENS
"CO2" 1 0 -16777216 true "" "plotxy ticks #-co2-molecules"
"O2" 1 0 -2674135 true "" "plotxy ticks #-o2-molecules"
"sugar" 1 0 -7500403 true "" "plotxy ticks #-glucose-molecules-produced"

MONITOR
226
10
292
47
time
ticks
0
1
9

SLIDER
6
50
189
83
stop-at
stop-at
100
5000
2000
100
1
time
HORIZONTAL

SWITCH
196
52
321
85
auto-stop?
auto-stop?
0
1
-1000
@#$#@#$#@
## WHAT IS IT?

The simulation shows the relationship between the inputs and outputs in the chloroplasts of plant, that can help explain how they convert water and carbon dioxide to glucose and water with the help of energy absorbed from light.

The multistep process shown occurring in a chloroplast in this simulation represents a series of more complex sub steps in a series of chemical reactions involved in a process referred to as photosynthesis. This includes the light reactions and the Calvin cycle. 

The simulation shows something that appears to look like electrical energy and white dots within the chloroplasts (the green circles) getting built up when water molecules are converted to oxygen molecules. This accumulation can be seeing occurring before each new carbon dioxide molecule is disassembled and its atoms rearranged to form new moleucles. This represents some of the electrical potential that is built up as hydrogen ions are removed from water in the light reactions and ATP is produced. These light reactions produce oxygen gas before a glucose molecule is fully formed. Gradual rearrangement of additional carbon dioxide molecules is shown occurring before a fully formed glucose molecule is produced. This represents some of the gradual rearrangement of carbon and oxygen atoms from carbon dioxide and hydrogen atoms from water that occurs in the Calvin cycle, though the intermediate arrangements of those carbon atoms at each sub step in the process is different than those shown in the simulation.  


## HOW TO USE IT

1. Adjust the slider parameters (see below), or use the default settings.
2. Press the SETUP/RESET button.
3. Press the GO/PAUSE button to begin the model run.

INITIAL-#-OF-CHLOROPLASTS - is a slider that controls the number of chloroplasts complexes (big green circles) put into the model when SETUP/RESET is pressed. 

INITIAL-CARBON-DIOXIDE - is a slider that controls the initial number of carbon dioxide molecules put into the model when SETUP/RESET is pressed.

WTATERFLOW-THROUGH-LEAF - is a slider that controls the rate at which water molecules flow into the leaf cell (from the left side of the model). Its affects can be adjusted as the model is running. 

INTENSITY-OF-LIGHT - is a slider that controls the rate at which photons flow into the leaf cell from the top and left side of the model. Its affects can be adjusted as the model is running. 

TIME - is a monitor that reports the amount of simulated time that has elapsed in a model run.

CARBON DIOXIDE MOLECULES - is a monitor that reports number of carbon dioxide molecules currently in the model (in the leaf)

OXYGEN MOLECULES - is a monitor that reports number of oxygen molecules currently in the model (in the leaf).  Oxygen molecules are not released from the leaf in this model after they are produced.

SUGAR MOLECULES PRODUCED - is a monitor that reports number of sugar molecules produced by the leaf.  Sugar molecules flow out of the world to the right as if they are dissolved in water, after they are produced.  They removed from the world view when the reach the right side of the model.

NUMBER OF MOLECULES - is a graph of total number of molecules of carbon dioxide remaining in the world, number of oxygen molecules produced (and still in the world), and the number of sugar molecules produces (which includes both those in the world and those that were removed when they reached the right side of the model).


## THINGS TO TRY

Compare how the outputs(oxygen produced, and sugar produced) in investigation B as are affected when a single independent variable Light, carbon dioxide, water, number of chloroplasts)for a given length of simulation run.


## CREDITS AND REFERENCES

Developed by Michael Novak and Bill Penuel.

This version of the model is part of the OpenSciEd Middle School instructional units developed with funding from the Carnegie Corporation of New York.  http://www.openscied.org/. 

The original model it was developed form, was part of the iHub/nextgenstorylines High School Evolution developed with funding through grants from the National Science Foundation, the Gordon and Betty Moore Foundation, Denver Public Schools to Northwestern University and the University of Colorado Boulder.

For more information about this project, see the nextgenstorylines website:
http://www.nextgenstorylines.org/how-do-small-changes-make-big-impacts-on-ecosystems-part-2/


## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Novak, M. and Penuel, B. (2016).  NetLogo Chloroplasts and Food Model. 


Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.


## COPYRIGHT AND LICENSE

This model is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 License. It can run in a browser as an .html file without a local installation of NetLogo. To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.


NetLogo itself is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Copyright 2015 Uri Wilensky.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

break
false
15
Line -1 true 0 165 300 165

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

carbon-complexes
true
0
Circle -2674135 true false 129 59 40
Circle -7500403 true true 124 95 42
Circle -1 true false 164 56 16
Circle -1 true false 159 99 16

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

co2
true
0
Circle -2674135 true false 94 131 38
Circle -7500403 true true 129 129 42
Circle -2674135 true false 169 132 38

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

electric-0
true
0
Line -7500403 true 150 0 135 30
Line -7500403 true 150 60 165 105
Line -7500403 true 165 105 150 120
Line -7500403 true 150 120 165 135
Line -7500403 true 150 150 165 135
Line -7500403 true 150 60 150 45
Line -7500403 true 150 45 135 30
Circle -1 true false 145 64 10

electric-1
true
0
Line -7500403 true 150 0 165 60
Line -7500403 true 165 60 135 90
Line -7500403 true 135 90 150 120
Line -7500403 true 150 120 150 150

electric-2
true
0
Line -7500403 true 150 0 165 30
Line -7500403 true 150 75 135 90
Line -7500403 true 135 90 135 120
Line -7500403 true 135 120 165 135
Line -7500403 true 150 150 165 135
Line -7500403 true 150 75 135 45
Line -7500403 true 135 45 165 30

electric-3
true
0
Line -7500403 true 150 0 150 15
Line -7500403 true 165 60 150 90
Line -7500403 true 165 105 150 120
Line -7500403 true 150 120 135 135
Line -7500403 true 150 150 135 135
Line -7500403 true 165 60 135 45
Line -7500403 true 135 45 150 15
Line -7500403 true 150 90 165 105

electric-4
true
0
Line -7500403 true 150 0 150 15
Line -7500403 true 135 75 150 90
Line -7500403 true 165 120 150 105
Line -7500403 true 165 120 150 135
Line -7500403 true 150 150 150 135
Line -7500403 true 135 75 165 45
Line -7500403 true 165 45 150 15
Line -7500403 true 150 90 150 105

electric-5
true
0
Line -7500403 true 150 0 150 15
Line -7500403 true 135 60 165 75
Line -7500403 true 150 120 135 90
Line -7500403 true 150 120 135 135
Line -7500403 true 150 150 135 135
Line -7500403 true 135 60 135 30
Line -7500403 true 135 30 150 15
Line -7500403 true 165 75 135 90
Circle -1 true false 135 100 12

electric-6
true
0
Line -7500403 true 150 0 165 15
Line -7500403 true 165 75 150 90
Line -7500403 true 150 90 165 105
Line -7500403 true 135 120 165 105
Line -7500403 true 150 150 135 120
Line -7500403 true 165 75 150 45
Line -7500403 true 150 45 165 15

electric-7
true
0
Line -7500403 true 150 0 165 30
Line -7500403 true 150 60 135 75
Line -7500403 true 135 75 165 105
Line -7500403 true 150 135 165 105
Line -7500403 true 150 150 150 135
Line -7500403 true 150 60 150 45
Line -7500403 true 150 45 165 30
Circle -1 true false 145 55 10

electric-8
true
0
Line -7500403 true 150 0 165 15
Line -7500403 true 135 60 150 90
Line -7500403 true 150 90 165 120
Line -7500403 true 150 135 165 120
Line -7500403 true 150 150 150 135
Line -7500403 true 135 60 150 45
Line -7500403 true 150 45 165 15

electric-9
true
0
Line -7500403 true 150 0 135 15
Line -7500403 true 165 60 150 90
Line -7500403 true 150 90 135 105
Line -7500403 true 135 105 165 135
Line -7500403 true 150 150 165 135
Line -7500403 true 165 60 150 45
Line -7500403 true 150 45 135 15

empty
false
0

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

h20
true
0
Circle -1 true false 124 157 16
Circle -1 true false 161 158 16
Circle -2674135 true false 135 134 32

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

o2
true
0
Circle -2674135 true false 113 131 38
Circle -2674135 true false 149 132 38

panel
true
0
Rectangle -7500403 true true 105 0 195 30

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

ray
true
0
Polygon -7500403 true true 150 0 105 90 195 90
Rectangle -7500403 true true 141 90 156 300

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true -15 -15 300 300

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

sugar
true
0
Circle -2674135 true false 120 191 38
Circle -2674135 true false 26 166 38
Circle -2674135 true false 132 59 38
Circle -2674135 true false 190 103 38
Circle -1 true false 220 131 16
Circle -1 true false 149 145 16
Circle -1 true false 45 214 16
Circle -1 true false 74 138 16
Circle -7500403 true true 84 159 42
Circle -7500403 true true 54 189 42
Circle -7500403 true true 84 114 42
Circle -7500403 true true 124 95 42
Circle -7500403 true true 158 124 42
Circle -7500403 true true 150 168 42
Circle -1 true false 42 106 16
Circle -1 true false 113 165 16
Circle -1 true false 72 225 16
Circle -1 true false 16 192 16
Circle -1 true false 164 56 16
Circle -1 true false 159 99 16
Circle -1 true false 185 176 16
Circle -1 true false 213 209 16
Circle -2674135 true false 175 198 38
Circle -2674135 true false 57 91 38

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0
-0.2 0 0 1
0 1 1 0
0.2 0 0 1
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@

@#$#@#$#@
