local score = 0

function play_sound(sound)
    local soundobj = hs.sound.getByName(sound)
    soundobj:play()
end

function show_on_screen(text)
    if not score_draw then
        local mainScreen = hs.screen.mainScreen()
        local mainRes = mainScreen:fullFrame()

        local score_text = hs.styledtext.new(text, {
            font = {name = "Impact", size = 120},
            color = {hex = "#FFFFFF", alpha = 1},
            backgroundColor = {hex = "#000000", alpha = 0.5},
            paragraphStyle = {alignment = "center"}
        })
        local timeframe = hs.geometry.rect((mainRes.w - 1200) / 2,
                                           (mainRes.h - 300) / 2, 1200, 200)
        score_draw = hs.drawing.text(timeframe, score_text)
        score_draw:setLevel(hs.drawing.windowLevels.overlay)
        score_draw:show()
        timer = hs.timer.doAfter(3, function()
            score_draw:delete()
            score_draw = nil
        end)
    else
        score_draw:delete()
        score_draw = nil
    end
end

function show_total(text)
    if not score_draw then
        local mainScreen = hs.screen.mainScreen()
        local mainRes = mainScreen:fullFrame()
        local todo = hs.styledtext.new(text, {
            font = {name = "Impact", size = 220},
            color = {hex = "#FF0000", alpha = 1},
            paragraphStyle = {alignment = "center"}
        })
        local timeframe = hs.geometry.rect((mainRes.w - 1200) / 2,
                                           (mainRes.h - 400) / 2, 1200, 300)
        score_draw = hs.drawing.text(timeframe, todo)
        score_draw:setLevel(hs.drawing.windowLevels.overlay)
        score_draw:show()
    else
        score_draw:delete()
        score_draw = nil
    end
end

function score_add_one()
    score = score + 1
    score = math.floor(score)
    play_sound('Glass')
    show_on_screen('Andrew:  ' .. score)
end

function score_add_ten()
    score = score + 10
    score = math.floor(score)
    play_sound('Submarine')
    show_on_screen('Andrew:  ' .. score)
end

function upload_score()
    res_code, res_text, res_table = hs.http.doRequest(
                                        'http://alexyin.net/andrew/upload.php?score=' .. score,
                                        'GET')
    -- print(res_code)
    -- print(res_text)
    -- print(res_table)
end

function download_score()
    res_code, res_text, res_table = hs.http.doRequest(
                                        'http://alexyin.net/andrew/download.php',
                                        'GET')

    score = res_text
end

hs.hotkey.bind("0", "f12", function() score_add_one() end)
hs.hotkey.bind("0", "f11", function() score_add_ten() end)

hs.hotkey.bind({"cmd"}, "f12", function()
    show_total('Total:  ' .. score)
    upload_score()
end)

hs.hotkey.bind({"ctrl"}, "f12", function()
    download_score()
    show_on_screen('Andrew:  ' .. score)
end)

