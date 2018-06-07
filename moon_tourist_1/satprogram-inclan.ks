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
  local ti to 0.
  local tlan to 0.
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
   TransferToBody(Mun).
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
    wait until body:name = "Mun". // убеждаемся, что действительно попали в сферу влияния Муны
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
//    Temperature().
//    MaterialBay().
//    Barometer().
//    ObserveMysteryGoo().
    wait 30.
    nextmode().
  }
  if satmode = 9 {
    print "prepare transfer to Kerbin".
    TransferToBody(Kerbin,1200000).
    nextmode().
  }
  if satmode = 10 {
    print "go to kerbin!!!".
    exenode().
    nextmode().
  }
  if satmode = 11 {
    warpfor(orbit:nextpatcheta).
    wait until body:name = "Kerbin".
    warpfor(eta:periapsis - 300).
    nextmode().
  }
  if satmode = 12 {
    perinode(35000).
    nextmode().
  }
  if satmode = 13 {
    exenode().
    nextmode().
  }
  if satmode = 14 {
    warpfor(eta:periapsis - 200).
    nextmode().
  }
// начинаем посадку
 if satmode = 15 {
   // jgecrftvcz lj 100 km
    lock steering to srfretrograde.
    warpheight(100000).
    wait 1.
    lock throttle to 1. 
    until velocity:orbit:mag < 2000
      {
      startnextstage_exenode().
      }
    lock throttle to 0.
    wait 1.
    stage.
    wait 1.
    stage.
    wait until alt:radar < 5000 and velocity:surface:mag < 250.
    chutes on.
    unlock steering.
    wait until status="landed" or status="splashed".
    return 0.

   nextmode().
 }

}

local satmode to 0.
local Hsat to altitude.
set LVmode to 0.
if exists("mode.ks") { runpath("mode.ks"). }
else nextmode(0).

satprogram().