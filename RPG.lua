--- [[adding lib for timming https://atelier801.com/topic?f=6&t=875052]]

Timers = {hasPassed = {}, amount = {}, start = {}, current = 0}
function newTimer(a, b)
     if Timers.hasPassed[a] == nil then
          print("Created timer (ID : " .. a .. ")")
          table.insert(Timers.hasPassed, a, false)
          table.insert(Timers.start, a, Timers.current)
          table.insert(Timers.amount, a, b)
          return a
     end
end
function removeTimer(a)
     print("Removed timer (ID : " .. a .. ")")
     Timers.hasPassed[a] = nil
     Timers.amount[a] = nil
     Timers.start[a] = nil
end
function resetTimer(a, b)
     if b ~= nil then
          Timers.amount[a] = b
     end
     Timers.start[a] = Timers.current
     Timers.hasPassed[a] = false
end
function processTimers(c, d)
     Timers.current = Timers.current + 500
     for e, f in pairs(Timers.hasPassed) do
          if Timers.current > Timers.start[e] + Timers.amount[e] and not Timers.hasPassed[e] then
               Timers.hasPassed[e] = true
          end
     end
end
-- End of Timers

-- [[ Simple global variables]]

local player = {}

--- [[End global Variables]]

--- [[Disable messages]]

for i, command in ipairs({"perfil", "p", "stats", "profile"}) do
     system.disableChatCommandDisplay(command, true)
end

--- [[End disable messages]]

--- [[ Disable some things]]
function disableSomeStuff()
     tfm.exec.disableAutoNewGame(true)
     tfm.exec.disableAllShamanSkills(true)
     tfm.exec.disableAutoNewGame(true)
     tfm.exec.disableAutoScore(true)
     tfm.exec.disableAutoShaman(true)
     tfm.exec.disableAutoTimeLeft(true)
end

--- [[ End Disable]]

--- [[ eventNewPlayer]]
function eventNewPlayer(n)
     if not player[n] then
          player[n] = {}
          player[n].exp = 100
          player[n].lvl = 1
          player[n].cookie = 0
          player[n].energy = 100
     end
     exp = player[n].exp
     lvl = player[n].lvl
     energy = player[n].energy
     menu()
end
--- [[ End eventNewPlayer]]

--- [[UI game]]

function menu()
     --- Simple menu show lvl, exp and energy
     ui.addTextArea(
          1,
          '<p align="center"><font color="#03fcfc">Level: ' ..
               lvl .. '<font color="#03fcfc"> Exp: ' .. exp .. '<font color="#03fcfc"> Energy: ' .. energy .. "</p>",
          nil,
          366,
          49
     )
     --- show ui for game
     ui.addTextArea(2, '<a href="event:training">Training!</a>', nil, 644, 215)
end

--- [[Insert new data for statistics]]
function insertData(n)
end

function updateMsg(n)
     exp = player[n].exp
     lvl = player[n].lvl
     energy = player[n].energy
     ui.addTextArea(
          1,
          '<p align="center"><font color="#03fcfc">Level: ' ..
               lvl .. '<font color="#03fcfc"> Exp: ' .. exp .. '<font color="#03fcfc"> Energy: ' .. energy .. "</p>",
          nil,
          366,
          49
     )
end
--- [[End new data for statistics]]

function eventTextAreaCallback(id, n, cb)
     if cb == "training" then
          if player[n].energy > 0 then
               checkExp(n)
          else
               print("Low energy")
          end
     end
end

--- [[Core game functions]]

function checkExp(n)
     if player[n].exp >= 100 then
          player[n].lvl = player[n].lvl + 1
          player[n].exp = 0
          updateMsg(n)
     else
          player[n].exp = player[n].exp + 1
          player[n].energy = player[n].energy - 1
          updateMsg(n)
     end
end

--- [[End core game functions]]

function eventLoop(elapsedTime, remainingTime)
     if Timers.hasPassed[recargeEnergy] then
          resetTimer(1, 20000) --- reset timmer
          print("Recargin energy!")
          for name in pairs(tfm.get.room.playerList) do
               if player[name].energy < 100 then
                    player[name].energy = player[name].energy + 1
                    updateMsg(name)
               else
                    return
               end
          end
     end
     processTimers(current, remaining)
end

--- [[ Main function ]]

function main()
     tfm.exec.newGame()
     disableSomeStuff()

     recargeEnergy = newTimer(1, 5000) --- Timer for recargue energy
     for name, player in pairs(tfm.get.room.playerList) do
          eventNewPlayer(name)
     end
end

--- [[End Main]]

main()
