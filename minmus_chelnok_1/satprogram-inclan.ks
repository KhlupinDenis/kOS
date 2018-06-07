require("liborbital","circularize.ks").
//require("minmus_u_1","mode1.ks").






function AlignToSun {
  lock steering to lookdirup(-Sun:position,Kerbin:position).
}

function nextmode {
  parameter newmode is satmode+1.
  set satmode to newmode.
  log "set satmode to " + newmode + "." to "mode.ks".
  AlignToSun().
}

function satprogram {
  local ti to 6.
  local tlan to 78.

  wait 10.
  clearscreen.
  print "Desired inclination: " + round(ti,2).
  print "Desired LAN: " + round(tlan,2).
  if satmode = 0 {
    local Hsat to 80000.
    LVprogram(Hsat,ti,tlan,80,57500,575).
    nextmode().
  }
  if satmode = 1 {
    startnextstage().
    panels on.
    wait 5.
    circularize().
    nextmode().
  }

  clearscreen.
  print "Desired inclination: " + round(ti,2) at (0,1).
  print "Reached inclination: " + round(orbit:inclination,2) at (0,2).
  print "Desired LAN: " + round(tlan,2) at (30,1).
  print "Reached LAN: " + round(orbit:lan,2) at (30,2).
//  until false AlignToSun().
  AlignToSun().
  if satmode = 2 {
    print "try to do maneuvr to minmus".
//require("minmus_u_1","mode1.ks").
   TransferToBody(Minmus,80000).
   nextmode().
  }
  if satmode = 3 {
    exenode().
    nextmode().
  }
  if satmode = 4 {
    warpfor(orbit:nextpatcheta).
    nextmode().
  }
  if satmode = 5 {
    wait until body:name = "Minmus". // убеждаемся, что действительно попали в сферу влияния Муны
    nextmode().
  }
  if satmode = 6 {
    warpfor(eta:periapsis - 30).
    nextmode().
  }
  if satmode = 7 {
    circularize().
    nextmode().
  }
  if satmode = 8 {
// начинаем посадку на Муну
    set Isp to 315.
    set tmax to 0.9.
    if lmode = 0 nextlmode().
    landing(landsight,85,5.7,Isp). 
    unlock steering.
    sas on.
    return.

//    Temperature().
//    MaterialBay().
//    Barometer().
//    ObserveMysteryGoo().
    wait 30.
    nextmode().
  }
  if satmode = 9 {
    nextmode().
  }
  if satmode = 10 {
    nextmode().
  }
  if satmode = 11 {
    nextmode().
  }
  if satmode = 12 {
    nextmode().
  }
  if satmode = 13 {
    nextmode().
  }
  if satmode = 14 {
    nextmode().
  }
// начинаем посадку
 if satmode = 15 {
   nextmode().
 }

}

set satmode to 0.
set lmode to 0.
local Hsat to altitude.
set LVmode to 0.
if exists("lmode.ks") { runpath("lmode.ks"). }
if exists("mode.ks") { runpath("mode.ks"). }
else nextmode(0).

satprogram().