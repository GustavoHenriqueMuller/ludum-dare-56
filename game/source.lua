require("class")

SOURCES = {}
Source = class()

function Source:init(name, volume, stop_on_play)
    self.name = name
    self.source = love.audio.newSource("sounds/" .. name .. ".ogg", "static")
    self.source:setVolume(volume)
    self.stop_on_play = stop_on_play

    SOURCES[name] = self
end

function Source:play()
    if self.source:isPlaying() and self.stop_on_play then
        self.source:stop()
    end

    self.source:play()
end