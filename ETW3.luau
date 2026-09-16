-- Hn1 + Grab Kill + TP Grab sem duplo Grab + console silencioso
-- Auto Event corrigido: chamada SummonEvent:FireServer(nomeDoEvento) restaurada.
-- Interface ampliada: hub 190x250, botoes 30px, fontes maiores.
-- bm2 - payload Lua devirtualizado e decodificado
-- Anti-tamper do ofuscador removido; GameId e whitelist originais do payload preservados.
-- Strings e fluxo da VM recuperados; nomes originais destruídos pelo ofuscador foram reconstruídos semanticamente quando possível.
-- Upvalues virtualizados agora são células Lua capturadas diretamente, sem tabela global de IDs/refcounts.


-- ================================================================
--                  EDITE A WHITELIST AQUI
-- ================================================================
-- Para adicionar alguém:
--     UserId, -- Nome
--
-- Exemplo:
--     1234567890, -- NovoUsuario
--
local WHITELIST = {
        197955820, -- ygorchunaibo 01
        8300163932, -- ELIAS56979 02
        9516014431, -- GOOD_MACR0 03
        9212911672, -- jgmmhgl 04
        9473330269, -- AVENGERS_ORG 05
        9508212224, -- VILAO_UF 06
        3507569900, -- Uchiha_Legad 07
        8081614931, -- CursedSwaan 08
        4164365779, -- Pessoa 09
        7018096014, -- Pessoa 10
        6070899844, -- Pessoa 11
        10663803052, -- Pessoa 12
        10697324672, -- Pessoa 13
        8096881984, -- Pessoa 14
        3632035761, -- Pessoa 15
        10397238620, -- Pessoa 16
        7013674312, -- Pessoa 17
        3080601393, -- Pessoa 18
        7471067357, -- Pessoa 19
        2055872416, -- Pessoa 20
        9515388641, -- Pessoa 21
        8543449356, -- Pessoa 22
        5414663953, -- Pessoa 23
        4001797380, -- Pessoa 24
        2838149488, -- Pessoa 25
        8765953542, -- Pessoa 26
        3424154009, -- Pessoa 27
        9516014431, -- Pessoa 28
        9269302700, -- Pessoa 29
        3507569900, -- Pessoa 30
        9473330269, -- Pessoa 31
        9508212224, -- Pessoa 32
        10657240698, -- Pessoa 33
        6090098954, -- Pessoa 34
        8570509038, -- Pessoa 35

        -- ADICIONE NOVOS IDS AQUI:
        -- 1234567890, -- Seu nome
        -- 9876543210, -- Nome da amiga
}
-- ================================================================

local environment = getfenv and getfenv() or _ENV
local unpackValues = unpack or table.unpack
local selectValues = select

-- Uma célula representa um upvalue compartilhado entre closures.
-- O garbage collector do próprio Lua substitui o gerenciamento manual de referências da VM.
local function allocateCell(initialValue)
    return { value = initialValue }
end

local function makeClosure(fn, captures, argc)
    assert(type(fn) == "function", "missing reconstructed function")
    if argc == -1 then
        return function(...) return fn(captures, ...) end
    elseif argc == 0 then
        return function() return fn(captures) end
    elseif argc == 1 then
        return function(a1) return fn(captures, a1) end
    elseif argc == 2 then
        return function(a1,a2) return fn(captures, a1,a2) end
    elseif argc == 3 then
        return function(a1,a2,a3) return fn(captures, a1,a2,a3) end
    elseif argc == 4 then
        return function(a1,a2,a3,a4) return fn(captures, a1,a2,a3,a4) end
    elseif argc == 5 then
        return function(a1,a2,a3,a4,a5) return fn(captures, a1,a2,a3,a4,a5) end
    elseif argc == 6 then
        return function(a1,a2,a3,a4,a5,a6) return fn(captures, a1,a2,a3,a4,a5,a6) end
    end
end

local function makeClosure3(fn,caps) return makeClosure(fn,caps,3) end
local function makeClosure6(fn,caps) return makeClosure(fn,caps,6) end
local function makeClosure1(fn,caps) return makeClosure(fn,caps,1) end
local function makeClosure0(fn,caps) return makeClosure(fn,caps,0) end
local function makeClosure5(fn,caps) return makeClosure(fn,caps,5) end
local function makeClosure4(fn,caps) return makeClosure(fn,caps,4) end
local function makeClosure2(fn,caps) return makeClosure(fn,caps,2) end
local function makeClosureVarargs(fn,caps) return makeClosure(fn,caps,-1) end

-- Strings internas já incorporadas diretamente no código.
local decodedStringCache = setmetatable({}, { __index = function(_, key) return key end })
local function decodePlainString(text) return text end

-- Funções reconstruídas do bytecode virtualizado. Os nomes originais não existem mais.
local fn_task_wait
local fn_remove_player_button
local fn_toggle_esp_ui
local fn_resize_scroll_canvas
local fn_toggle_fake_emote_ui
local fn_play_fake_emote
local fn_character_walkspeed
local fn_find_character_event
local fn_reset_character_physics
local fn_platform_stand_cleanup
local fn_character_tracking
local fn_style_button
local fn_tween_position
local fn_fire_remote
local fn_animation_timer
local fn_remove_text_button
local fn_create_removed_map_floor
local fn_resize_scroll_canvas_alt
local fn_cleanup_esp
local fn_on_character_added
local fn_toggle_all_players
local fn_player_button_click
local fn_update_esp_display
local fn_update_toggle_display
local fn_floor_worker
local fn_set_background_color
local fn_destroy_instance
local fn_auto_eat_worker
local fn_map_position_worker
local fn_create_player_highlight
local fn_unanchor_worker
local fn_fire_spin_event
local fn_destroy_instance_alt
local fn_copy_discord_link
local fn_resize_canvas_y
local fn_create_text_button
local fn_toggle_only_eat
local fn_toggle_unanchor
local fn_toggle_floor
local fn_anti_void_worker
local fn_toggle_anti_void
local fn_toggle_aim_lock
local fn_toggle_safe_zone
local fn_tween_ui
local fn_save_position
local fn_set_visible
local fn_teleport_saved_position
local fn_auto_event_reward
local fn_aim_worker
local fn_character_animation_setup
local fn_resize_scroll_canvas_2
local fn_toggle_tp_attack
local fn_resize_scroll_canvas_3
local fn_toggle_tp_grab
local fn_tp_grab_worker
local fn_all_players_worker
local fn_create_player_button
local fn_protected_worker
local fn_callback_no_strings_1
local fn_event_animation_config
local fn_resize_scroll_canvas_4
local fn_toggle_auto_event
local fn_callback_no_strings_2
local fn_callback_no_strings_3
local fn_safe_zone_worker
local fn_main

fn_task_wait = function(capturedCells, arg1, arg2, arg3)
    local t = nil
    local u, l, C, w, K
    local result
    C=capturedCells[1].value
    u=arg1
    K=capturedCells[2].value
    t=C[K]
    if t then
        C=environment.task
        t=C.wait
        K=0.5
        C=t(K)
        t=capturedCells[5].value
        C=t(u)
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_remove_player_button = function(capturedCells, player)
    local t = nil
    local u, Z, O, l, y, V, D, g, S, Y, C, A
    local w, K
    local result
    C="pairs"
    u=player
    S="GetChildren"
    t=environment.pairs
    w=capturedCells[1].value
    S=w.GetChildren
    Y={S(w)}
    w={t(unpackValues(Y))}
    C=w[1]
    l=w[3]
    K=w[2]
    w=C
    while true do
        l,S=w(K,l)
        if l then
            g=S.IsA
            y="TextButton"
            g=g(S,y)
            V=g
            if g then
                y=S.Text
                Z=u.DisplayName
                g=y==Z
                V=g
            end
            if V then
                t=S.Destroy
                t=t(S)
            end
        else
            break
        end
    end
    t=capturedCells[4].value
    K=t(u)
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_toggle_esp_ui = function(capturedCells, arg1, arg2, arg3)
    local t = nil
    local u, l, y, V, g, S, Y, C, w, K
    local result
    t=capturedCells[1].value
    C="Visible"
    l=capturedCells[1].value
    K=l.Visible
    u=not K
    t.Visible=u
    t=capturedCells[4].value
    C="Text"
    S=capturedCells[1].value
    K=t
    Y=S.Visible
    l=Y
    if Y then
        Y="ESP : ON"
        l=Y
    end
    u=l
    if l then
    else
        Y=capturedCells[3].value
        l="ESP : OFF"
        u=l
    end
    t=K
    t[C]=u
    t=capturedCells[4].value
    K=t
    C="BackgroundColor3"
    S=capturedCells[1].value
    Y=S.Visible
    l=Y
    if Y then
        S=environment.Color3
        V="fromRGB"
        g=58
        Y=S.fromRGB
        y=32
        V=32
        S=Y(V,g,y)
        l=S
    end
    u=l
    if l then
    else
        w=environment.Color3
        Y="fromRGB"
        S=38
        l=w.fromRGB
        V=41
        Y=36
        w=l(Y,S,V)
        u=w
    end
    t=K
    t[C]=u
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_resize_scroll_canvas = function(capturedCells, arg1)
    local t = nil
    local u, Z, O, l, y, V, D, g, p, S, Y, C
    local A, w, K
    local entry
    local result
    t=capturedCells[1].value
    C="CanvasSize"
    K=environment.UDim2
    u=K.new
    Y=0
    l=0
    w=0
    g=capturedCells[4].value
    V=g.AbsoluteContentSize
    S=V.Y
    K=u(l,w,Y,S)
    t.CanvasSize=K
    t=capturedCells[5].value
    C="Size"
    K=environment.UDim2
    g="math"
    u=K.new
    Y=0
    w=115
    l=0
    V=environment.math
    S=V.min
    O=capturedCells[4].value
    Z=O.AbsoluteContentSize
    y=Z.Y
    Z=25
    g=y+Z
    y=105
    V={S(g,y)}
    K=u(l,w,Y,unpackValues(V))
    t.Size=K
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_toggle_fake_emote_ui = function(capturedCells, arg1, arg2)
    local t = nil
    local u, l, y, V, g, S, Y, C, w, K
    local result
    t=capturedCells[1].value
    C="Visible"
    l=capturedCells[1].value
    K=l.Visible
    u=not K
    t.Visible=u
    t=capturedCells[4].value
    K=t
    C="Text"
    S=capturedCells[1].value
    Y=S.Visible
    l=Y
    if Y then
        Y="Fake Emote : ON"
        l=Y
    end
    u=l
    if l then
    else
        Y=capturedCells[3].value
        l="Fake Emote : OFF"
        u=l
    end
    t=K
    t[C]=u
    t=capturedCells[4].value
    C="BackgroundColor3"
    K=t
    S=capturedCells[1].value
    Y=S.Visible
    l=Y
    if Y then
        S=environment.Color3
        Y=S.fromRGB
        V=32
        y=32
        g=58
        S=Y(V,g,y)
        l=S
    end
    u=l
    if l then
    else
        w=environment.Color3
        Y="fromRGB"
        S=38
        l=w.fromRGB
        V=41
        Y=36
        w=l(Y,S,V)
        u=w
    end
    t=K
    t[C]=u
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_play_fake_emote = function(capturedCells, emoteName, animationId)
    local t = nil
    local u, l, V, S, Y, C, w, K
    local result
    u=emoteName
    K=animationId
    C=capturedCells[1].value
    w=capturedCells[2].value
    t=C.Character
    l=t
    C=l
    if l then
        w="FindFirstChildOfClass"
        w=l.FindFirstChildOfClass
        Y="Humanoid"
        w=w(l,Y)
        C=w
    end
    w=C
    if w then
        C=environment.Instance
        t=C.new
        Y="Animation"
        C=t(Y)
        Y=C
        t="AnimationId"
        C=u
        Y.AnimationId=C
        t=w.LoadAnimation
        t=t(w,Y)
        S=t
        t="Looped"
        C=false
        S.Looped=C
        t=S.Play
        t=t(S)
        t=S.AdjustSpeed
        t=t(S,K)
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_character_walkspeed = function(capturedCells, arg1, arg2, arg3, arg4, arg5)
    local t = nil
    local u, l, C, K
    local result
    C=capturedCells[1].value
    t=C.Character
    if t then
        C=capturedCells[1].value
        t=C.Character
        C=t.FindFirstChildOfClass
        u=C(t,"Humanoid")
        if u then
            -- A velocidade escolhida fica guardada nesta celula.
            -- Enquanto for nil, o script nao altera o WalkSpeed.
            C=capturedCells[4].value
            if C ~= nil then
                u.WalkSpeed=C
            end
        end
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_find_character_event = function(capturedCells, arg1, arg2, arg3, arg4, arg5)
    local t = nil
    local u, l, Y, C, w, K
    local result
    t=environment.workspace
    K=capturedCells[1].value
    u=K.Name
    C=t.FindFirstChild
    C=C(t,u)
    u=C
    t=not u
    if t then
        C={}
        result = C or {}
    else
        t="FindFirstChild"
        t=u.FindFirstChild
        C="Events"
        t=t(u,C)
        K=t
        t=not K
        if t then
            C={}
            result = C or {}
        else
            C={K}
            result = C or {}
        end
    end
    return unpackValues(result or {})
end
fn_reset_character_physics = function(capturedCells, character)
    local t = nil
    local u, l, S, Y, C, w, K
    local result
    u=capturedCells[1].value
    C=u
    if u then
        K=capturedCells[2].value
        u=not K
        C=u
    end
    if C then
        C=capturedCells[3].value
        t=C.Character
        u=t
        C=u
        if u then
            K=u.FindFirstChild
            l="HumanoidRootPart"
            K=K(u,l)
            C=K
        end
        if C then
            t=u.HumanoidRootPart
            K=t
            t="CFrame"
            C=capturedCells[6].value
            K.CFrame=C
            t="AssemblyLinearVelocity"
            l=environment.Vector3
            C=l.zero
            K.AssemblyLinearVelocity=C
            t="AssemblyAngularVelocity"
            l=environment.Vector3
            C=l.zero
            K.AssemblyAngularVelocity=C
        end
    else
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_platform_stand_cleanup = function(capturedCells, arg1, arg2)
    local t = nil
    local u, l, V, S, Y, C, w, K
    local entry, block_01, block_02, block_03, block_04, block_05, block_06, block_07
    local result
    t=environment.pairs
    l=capturedCells[1].value
    w={t(l)}
    K=w[3]
    u=w[2]
    C=w[1]
    l=C
    while true do
        K,Y=l(u,K)
        if K then
            t=Y.Disconnect
            t=t(Y)
        else
            break
        end
    end
    t={}
    capturedCells[1].value=t
    K=capturedCells[2].value
    u=K.Character
    K=u
    if u then
        w=u.FindFirstChildOfClass
        Y="Humanoid"
        w=w(u,Y)
        K=w
    end
    if K then
        K=u.FindFirstChildOfClass
        l="Humanoid"
        K=K(u,l)
        l="PlatformStand"
        w=false
        K.PlatformStand=w
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_character_tracking = function(capturedCells)
    local t = nil
    local u, l, V, g, S, Y, C, w, K
    local result
    C=environment.table
    t=C.insert
    u=capturedCells[3].value
    l=capturedCells[4].value
    w="RenderStepped"
    Y="Connect"
    K=l.RenderStepped
    w=capturedCells[5].value
    Y=K.Connect
    l={Y(K,w)}
    C=t(u,unpackValues(l))
    C=environment.table
    t=C.insert
    u=capturedCells[3].value
    l=capturedCells[4].value
    w="Stepped"
    Y="Connect"
    K=l.Stepped
    w=capturedCells[5].value
    Y=K.Connect
    l={Y(K,w)}
    C=t(u,unpackValues(l))
    C=environment.table
    t=C.insert
    u=capturedCells[3].value
    l=capturedCells[4].value
    w="Heartbeat"
    Y="Connect"
    K=l.Heartbeat
    w=capturedCells[5].value
    Y=K.Connect
    l={Y(K,w)}
    C=t(u,unpackValues(l))
    C=capturedCells[6].value
    K=capturedCells[1].value
    t=C.Character
    u=t
    if u then
        t=u.FindFirstChild
        C="HumanoidRootPart"
        t=t(u,C)
        K=t
        t=u.FindFirstChildOfClass
        C="Humanoid"
        t=t(u,C)
        l=t
        if K then
            C=environment.table
            t=C.insert
            w=capturedCells[3].value
            Y="GetPropertyChangedSignal"
            Y=K.GetPropertyChangedSignal
            S="CFrame"
            Y=Y(K,S)
            g="Connect"
            V=capturedCells[5].value
            g=Y.Connect
            S={g(Y,V)}
            C=t(w,unpackValues(S))
            C=environment.table
            t=C.insert
            w=capturedCells[3].value
            Y="GetPropertyChangedSignal"
            Y=K.GetPropertyChangedSignal
            S="Position"
            Y=Y(K,S)
            V=capturedCells[5].value
            g=Y.Connect
            S={g(Y,V)}
            C=t(w,unpackValues(S))
        end
        if l then
            t="PlatformStand"
            C=true
            l.PlatformStand=C
        end
    else
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_style_button = function(capturedCells, button, arg2, arg3, arg4, arg5, arg6)
    local t = nil
    local u, l, V, S, Y, C, w, K
    local entry
    local result
    u=button
    t="BorderSizePixel"
    C=0
    u.BorderSizePixel=C
    t="AutoButtonColor"
    C=false
    u.AutoButtonColor=C
    w="Enum"
    t="Font"
    l=environment.Enum
    K=l.Font
    C=K.GothamMedium
    u.Font=C
    t="TextColor3"
    K=environment.Color3
    Y=255
    l="fromRGB"
    w=255
    C=K.fromRGB
    l=255
    K=C(l,w,Y)
    u.TextColor3=K
    C=environment.Instance
    t=C.new
    K="UICorner"
    C=t(K)
    K=C
    t="CornerRadius"
    l=environment.UDim
    w="new"
    Y=3
    C=l.new
    w=0
    l=C(w,Y)
    K.CornerRadius=l
    t="Parent"
    C=u
    l="Instance"
    K.Parent=C
    C=environment.Instance
    t=C.new
    l="UIStroke"
    C=t(l)
    l=C
    t="Color"
    w=environment.Color3
    Y="fromRGB"
    S=54
    C=w.fromRGB
    Y=52
    V=58
    w=C(Y,S,V)
    l.Color=w
    t="Thickness"
    C=1
    l.Thickness=C
    t="Parent"
    C=u
    l.Parent=C
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_tween_position = function(capturedCells, arg1, arg2, arg3)
    local t = nil
    local u, Z, O, l, y, V, g, S, Y, C, w, K
    local entry
    local result
    w="TweenInfo"
    t=capturedCells[1].value
    u=capturedCells[2].value
    l=environment.TweenInfo
    K=l.new
    w=0.5
    V=environment.Enum
    S=V.EasingStyle
    V="Quint"
    y="Enum"
    C="Create"
    Y=S.Quint
    g=environment.Enum
    V=g.EasingDirection
    S=V.In
    l=K(w,Y,S)
    w="Position"
    S=environment.UDim2
    V="new"
    Z=-20
    Y=S.new
    g=400
    V=1
    y=1
    C=t.Create
    S=Y(V,g,y,Z)
    K={[w]=S}
    C=C(t,u,l,K)
    t=C.Play
    t=t(C)
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_fire_remote = function(capturedCells)
    -- Remote usado pelo Auto Event: ReplicatedStorage.Events.SummonEvent
    local remote = capturedCells[1] and capturedCells[1].value
    local eventName = capturedCells[2] and capturedCells[2].value

    if remote and eventName then
        remote:FireServer(eventName)
    end

    return
end
fn_animation_timer = function(capturedCells, animationTrack, arg2)
    local t = nil
    local u, l, V, S, Y, C, w, K
    local result
    K=capturedCells[1].value
    C=K
    u=animationTrack
    if K then
        w=u.Animation
        l=w.AnimationId
        w="rbxassetid://16493275190"
        K=l==w
        C=K
    end
    if C then
        C=environment.tick
        K=C()
        C=.1
        t=K+C
        capturedCells[4].value=t
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_remove_text_button = function(capturedCells, button, arg2)
    local t = nil
    local u, Z, O, l, y, V, D, g, S, Y, C, A
    local w, K
    local result
    u=button
    S="GetChildren"
    t=environment.pairs
    w=capturedCells[1].value
    S=w.GetChildren
    Y={S(w)}
    w={t(unpackValues(Y))}
    l=w[3]
    K=w[2]
    C=w[1]
    w=C
    while true do
        l,S=w(K,l)
        if l then
            y="TextButton"
            g=S.IsA
            g=g(S,y)
            V=g
            if g then
                y=S.Text
                Z=u.DisplayName
                g=y==Z
                V=g
            end
            if V then
                t=S.Destroy
                t=t(S)
            end
        else
            break
        end
    end
    t=environment.pairs
    V="GetChildren"
    Y=capturedCells[4].value
    V=Y.GetChildren
    S={V(Y)}
    Y={t(unpackValues(S))}
    K=Y[1]
    w=Y[3]
    l=Y[2]
    while true do
        w,S=K(l,w)
        if w then
            g=S.IsA
            y="TextButton"
            g=g(S,y)
            V=g
            if g then
                y=S.Text
                Z=u.DisplayName
                g=y==Z
                V=g
            end
            if V then
                t=S.Destroy
                t=t(S)
            end
        else
            break
        end
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_create_removed_map_floor = function(capturedCells, arg1, arg2, arg3, arg4, arg5)
    local t = nil
    local u, Z, O, l, y, V, D, g, p, S, Y, C
    local A, w, K, U
    local entry, block_01, block_02, block_03, block_04, block_05, block_06, block_07, block_08, block_09, block_10, block_11, block_12, block_13, block_14, block_15, block_16, block_17, block_18, block_19
    local result
    C=capturedCells[1].value
    t=not C
    capturedCells[1].value=t
    C=capturedCells[1].value
    if C then
        C=capturedCells[2].value
        u="Text"
        K="Remove Map : ON"
        C.Text=K
        C=capturedCells[2].value
        u="BackgroundColor3"
        l=environment.Color3
        V="fromRGB"
        S=32
        K=l.fromRGB
        w=32
        Y=58
        l=K(w,Y,S)
        Y="workspace"
        C.BackgroundColor3=l
        C=environment.pairs
        S="GetChildren"
        w=environment.workspace
        S=w.GetChildren
        Y={S(w)}
        w={C(unpackValues(Y))}
        u=w[1]
        K=w[2]
        l=w[3]
        while true do
            l,Y=u(K,l)
            if l then
                t = 5926340 -- valor que o registrador t tinha ao entrar neste bloco;
                y="GetPlayerFromCharacter"
                g=capturedCells[5].value
                y=g.GetPlayerFromCharacter
                y=y(g,Y)
                V=not y
                C=V
                if V then
                    t = 5713120 -- valor que o registrador t tinha ao entrar neste bloco;
                    O=environment.workspace
                    Z=O.Terrain
                    y=Y~=Z
                    V=y
                    if y then
                        t = 6441327 -- valor que o registrador t tinha ao entrar neste bloco;
                        D="IsA"
                        A="Camera"
                        D=Y.IsA
                        D=D(Y,A)
                        O=not D
                        y=O
                        if O then
                            D=Y.FindFirstChild
                            A="Events"
                            D=D(Y,A)
                            O=not D
                            y=O
                        end
                        V=y
                    else
                    end
                    C=V
                else
                end
                if C then
                    V=capturedCells[4].value
                    C="Parent"
                    S=capturedCells[6].value
                    Y.Parent=S
                end
            else
                break
            end
        end
        u=environment.Instance
        C=u.new
        K="Part"
        u=C(K)
        C="Name"
        K="RemovedMapFloor"
        u.Name=K
        C="Size"
        l=environment.Vector3
        S=100000
        K=l.new
        w=100000
        Y=1
        l=K(w,Y,S)
        u.Size=l
        C="Position"
        l=environment.Vector3
        S=0
        K=l.new
        Y=-1
        w=0
        l=K(w,Y,S)
        u.Position=l
        C="Anchored"
        K=true
        u.Anchored=K
        C="Color"
        l=environment.Color3
        K=l.fromRGB
        S=25
        w=5
        Y=5
        l=K(w,Y,S)
        u.Color=l
        C="Parent"
        K=environment.workspace
        u.Parent=K
    else
        C=capturedCells[2].value
        u="Text"
        K="Remove Map : OFF"
        C.Text=K
        C=capturedCells[2].value
        u="BackgroundColor3"
        l=environment.Color3
        w="fromRGB"
        S=41
        K=l.fromRGB
        Y=38
        w=36
        l=K(w,Y,S)
        C.BackgroundColor3=l
        C=environment.pairs
        w=capturedCells[6].value
        S=w.GetChildren
        Y={S(w)}
        w={C(unpackValues(Y))}
        l=w[3]
        u=w[1]
        K=w[2]
        while true do
            l,Y=u(K,l)
            if l then
                V="workspace"
                C="Parent"
                S=environment.workspace
                Y.Parent=S
            else
                break
            end
        end
        C=environment.workspace
        K="RemovedMapFloor"
        u=C.FindFirstChild
        u=u(C,K)
        if u then
            u=environment.workspace
            C=u.RemovedMapFloor
            u=C.Destroy
            u=u(C)
        end
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_resize_scroll_canvas_alt = function(capturedCells, arg1, arg2, arg3, arg4)
    local t = nil
    local u, Z, O, l, y, V, D, g, p, S, Y, C
    local A, w, K
    local entry
    local result
    t=capturedCells[1].value
    C="CanvasSize"
    K=environment.UDim2
    u=K.new
    l=0
    w=0
    Y=0
    g=capturedCells[4].value
    V=g.AbsoluteContentSize
    S=V.Y
    K=u(l,w,Y,S)
    t.CanvasSize=K
    t=capturedCells[5].value
    C="Size"
    K=environment.UDim2
    l="new"
    g="math"
    u=K.new
    V=environment.math
    Y=0
    l=0
    w=115
    S=V.min
    O=capturedCells[4].value
    Z=O.AbsoluteContentSize
    y=Z.Y
    Z=25
    g=y+Z
    y=105
    V={S(g,y)}
    K=u(l,w,Y,unpackValues(V))
    t.Size=K
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_cleanup_esp = function(capturedCells, player, arg2, arg3, arg4, arg5)
    local t = nil
    local u, l, C, w, K
    local result
    u=player
    C=capturedCells[1].value
    t=C[u]
    if t then
        K=capturedCells[1].value
        C=K[u]
        t=C.highlight
        if t then
            K=capturedCells[1].value
            C=K[u]
            t=C.highlight
            C=t.Destroy
            C=C(t)
        end
        K=capturedCells[1].value
        C=K[u]
        t=C.billboard
        if t then
            K=capturedCells[1].value
            C=K[u]
            t=C.billboard
            C=t.Destroy
            C=C(t)
        end
        K=capturedCells[1].value
        C=K[u]
        t=C.connection
        if t then
            K=capturedCells[1].value
            C=K[u]
            t=C.connection
            C=t.Disconnect
            C=C(t)
        end
        C=nil
        t=capturedCells[1].value
        t[u]=C
    else
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_on_character_added = function(capturedCells, character, arg2, arg3)
    local t = nil
    local u, l, V, S, Y, C, w, K
    local result
    u=allocateCell()
    u.value=character
    C=u.value
    K=capturedCells[1].value
    t=C==K
    if t then
        C={}
        result = C or {}
        return unpackValues(result or {})
    else
        K=capturedCells[2].value
        l=u.value
        C=K[l]
        t=not C
        if t then
            C={}
            result = C or {}
            return unpackValues(result or {})
        else
            K=allocateCell()
            t=makeClosure3(fn_create_player_highlight,{capturedCells[3];u;capturedCells[4];capturedCells[5],capturedCells[6],capturedCells[2];capturedCells[7]})
            K.value=t
            C=u.value
            t=C.Character
            if t then
                t=K.value
                w=u.value
                l=w.Character
                C=t(l)
            end
            C=u.value
            t=C.CharacterAdded
            l=makeClosure3(fn_task_wait,{capturedCells[2];u;capturedCells[4];capturedCells[5],K})
            C="Connect"
            K=nil
            u=nil
            C=t.Connect
            C=C(t,l)
            C={}
            result = C or {}
            return unpackValues(result or {})
        end
    end
end
fn_toggle_all_players = function(capturedCells, arg1, arg2, arg3, arg4)
    local t = nil
    local u, Z, O, l, y, V, D, g, p, S, Y, C
    local A, w, K
    local result
    C=capturedCells[1].value
    t=not C
    capturedCells[1].value=t
    C=capturedCells[2].value
    u="Text"
    S=capturedCells[1].value
    w=S
    if S then
        V=capturedCells[3].value
        S="All Player : ON"
        w=S
    end
    K=w
    if w then
    else
        S=capturedCells[4].value
        V="All Player : OFF"
        w="All Player : OFF"
        K=w
    end
    C[u]=K
    C=capturedCells[2].value
    u="BackgroundColor3"
    S=capturedCells[1].value
    w=S
    if S then
        V=environment.Color3
        S=V.fromRGB
        y=58
        Z=32
        g=32
        V=S(g,y,Z)
        w=V
    end
    K=w
    if w then
    else
        Y=environment.Color3
        g=41
        S="fromRGB"
        V=38
        w=Y.fromRGB
        S=36
        Y=w(S,V,g)
        K=Y
    end
    C[u]=K
    C=environment.pairs
    S="GetPlayers"
    w=capturedCells[5].value
    S=w.GetPlayers
    Y={S(w)}
    w={C(unpackValues(Y))}
    K=w[2]
    u=w[1]
    l=w[3]
    while true do
        l,Y=u(K,l)
        if l then
            S=capturedCells[6].value
            C=Y~=S
            if C then
                C=capturedCells[1].value
                if C then
                    C=capturedCells[7].value
                    S=true
                    C[Y]=S
                    C=capturedCells[8].value
                    S=C(Y)
                else
                    S=nil
                    C=capturedCells[7].value
                    C[Y]=S
                    C=capturedCells[9].value
                    S=C(Y)
                end
            else
            end
        else
            break
        end
    end
    u="pairs"
    S="GetChildren"
    C=environment.pairs
    w=capturedCells[10].value
    S=w.GetChildren
    Y={S(w)}
    w={C(unpackValues(Y))}
    u=w[1]
    K=w[2]
    l=w[3]
    while true do
        l,Y=u(K,l)
        if l then
            t = 6797260 -- valor que o registrador t tinha ao entrar neste bloco;
            V=Y.IsA
            Z=capturedCells[4].value
            g="TextButton"
            V=V(Y,g)
            C=V
            if V then
                g=capturedCells[2].value
                V=Y~=g
                C=V
            end
            if C then
                t = 10056544 -- valor que o registrador t tinha ao entrar neste bloco;
                V=t
                C="BackgroundColor3"
                Z=capturedCells[1].value
                g=Z
                if Z then
                    O=environment.Color3
                    D="fromRGB"
                    p=32
                    Z=O.fromRGB
                    D=32
                    A=58
                    O=Z(D,A,p)
                    g=O
                end
                S=g
                if g then
                else
                    y=environment.Color3
                    Z="fromRGB"
                    O=38
                    g=y.fromRGB
                    Z=36
                    D=41
                    y=g(Z,O,D)
                    S=y
                end
                Y[C]=S
            else
            end
        else
            break
        end
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_player_button_click = function(capturedCells, player, arg2, arg3)
    local t = nil
    local u, l, V, g, S, Y, C, w, K
    local result
    u=allocateCell()
    u.value=player
    C=u.value
    K=capturedCells[1].value
    t=C==K
    if t then
        C={}
        result = C or {}
        return unpackValues(result or {})
    else
        t=capturedCells[2].value
        l=u.value
        K=l.DisplayName
        l=capturedCells[5].value
        C=t(K,l)
        K=allocateCell()
        K.value=C
        t=K.value
        C="LayoutOrder"
        l=1
        t.LayoutOrder=l
        t=K.value
        C="Size"
        w=environment.UDim2
        Y="new"
        g=18
        S=-4
        l=w.new
        Y=1
        V=0
        w=l(Y,S,V,g)
        t.Size=w
        t=K.value
        C="TextSize"
        l=8
        t.TextSize=l
        t=capturedCells[6].value
        if t then
            t=K.value
            C="BackgroundColor3"
            w=environment.Color3
            Y="fromRGB"
            S=58
            V=32
            l=w.fromRGB
            Y=32
            w=l(Y,S,V)
            t.BackgroundColor3=w
        end
        C=K.value
        t=C.MouseButton1Click
        C="Connect"
        l=makeClosure3(fn_set_background_color,{capturedCells[7];u,K,capturedCells[3];capturedCells[4];capturedCells[8],capturedCells[9]})
        C=t.Connect
        K=nil
        u=nil
        C=C(t,l)
        C={}
        result = C or {}
        return unpackValues(result or {})
    end
end
fn_update_esp_display = function(capturedCells, arg1, arg2)
    local t = nil
    local u, Z, O, l, y, V, D, g, S, Y, C, w
    local K
    local entry, block_01, block_02, block_03, block_04, block_05, block_06, block_07, block_08, block_09, block_10, block_11
    local result
    u=capturedCells[1].value
    K=capturedCells[2].value
    C=u[K]
    t=not C
    if t then
        C={}
        result = C or {}
        return unpackValues(result or {})
    else
        t=capturedCells[3].value
        C="FindFirstChild"
        C=t.FindFirstChild
        u="HumanoidRootPart"
        C=C(t,u)
        u=C
        if u then
            K=u.Size
            Y=capturedCells[5].value
            C=K.Y
            K=350
            t=C/K
            K=t
            t=capturedCells[6].value
            C="TextSize"
            w=environment.math
            Y="clamp"
            S=160
            V=12
            l=w.clamp
            Y=K*S
            S=6
            w=l(Y,S,V)
            t.TextSize=w
        end
        C=environment.math
        t=C.floor
        l=capturedCells[7].value
        K=l.Health
        C=t(K)
        t=capturedCells[6].value
        K=C
        C="Text"
        Y=capturedCells[2].value
        w=Y.DisplayName
        S=" | hp:"
        Y=S..K
        l=w..Y
        t.Text=l
        C=65
        t=K>=C
        if t then
            t=capturedCells[6].value
            C="TextColor3"
            w=environment.Color3
            Y="fromRGB"
            V=0
            l=w.fromRGB
            S=255
            Y=0
            w=l(Y,S,V)
            t.TextColor3=w
        else
            C=40
            t=K>=C
            if t then
                t=capturedCells[6].value
                C="TextColor3"
                w=environment.Color3
                l=w.fromRGB
                Y=255
                S=255
                V=0
                w=l(Y,S,V)
                t.TextColor3=w
            else
                C=25
                t=K>=C
                if t then
                    t=capturedCells[6].value
                    C="TextColor3"
                    w=environment.Color3
                    Y="fromRGB"
                    S=165
                    l=w.fromRGB
                    V=0
                    Y=255
                    w=l(Y,S,V)
                    t.TextColor3=w
                else
                    t=capturedCells[6].value
                    C="TextColor3"
                    w=environment.Color3
                    l=w.fromRGB
                    Y=255
                    V=0
                    S=0
                    w=l(Y,S,V)
                    t.TextColor3=w
                end
            end
        end
        t=capturedCells[8].value
        C="StudsOffset"
        w=environment.Vector3
        l=w.new
        Y=0
        y=capturedCells[9].value
        g=y.Size
        V=g.Y
        g=3
        S=V*g
        V=0
        w=l(Y,S,V)
        t.StudsOffset=w
        C={}
        result = C or {}
        return unpackValues(result or {})
    end
end
fn_update_toggle_display = function(capturedCells, arg1, arg2, arg3)
    local t = nil
    local u, l, Y, C, w, K
    local result
    t=capturedCells[1].value
    C=capturedCells[2].value
    l=capturedCells[1].value
    w=capturedCells[2].value
    K=l[w]
    u=not K
    t[C]=u
    C=capturedCells[1].value
    u=capturedCells[2].value
    t=C[u]
    if t then
        t=capturedCells[3].value
        C="Text"
        K=capturedCells[2].value
        l=": ON"
        u=K..l
        t.Text=u
        t=capturedCells[3].value
        C="BackgroundColor3"
        K=environment.Color3
        u=K.fromRGB
        Y=32
        w=58
        l=32
        K=u(l,w,Y)
        t.BackgroundColor3=K
    else
        t=capturedCells[3].value
        C="Text"
        K=capturedCells[2].value
        l=": OFF"
        u=K..l
        t.Text=u
        t=capturedCells[3].value
        C="BackgroundColor3"
        K=environment.Color3
        l="fromRGB"
        Y=41
        w=38
        u=K.fromRGB
        l=36
        K=u(l,w,Y)
        t.BackgroundColor3=K
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_floor_worker = function(capturedCells)
    local t = nil
    local u, Z, O, l, y, V, D, X, g, p, S, Y
    local C, A, w, K, U
    local entry, block_01, block_02, block_03, block_04, block_05, block_06, block_07, block_08, block_09
    local result
    while true do
        u=capturedCells[1].value
        C=u
        if u then
            K=capturedCells[2].value
            u=K.Parent
            C=u
        end
        if C then
            C=capturedCells[5].value
            t=C.Character
            u=t
            C=u
            if u then
                K=u.FindFirstChild
                l="HumanoidRootPart"
                K=K(u,l)
                C=K
            end
            if C then
                C=u.HumanoidRootPart
                t=C.Position
                K=t
                t="GetExtentsSize"
                w="Instance"
                t=u.GetExtentsSize
                t=t(u)
                C=environment.Instance
                l=t
                t=C.new
                w="Part"
                C=t(w)
                w=allocateCell()
                w.value=C
                t=w.value
                C="Size"
                S=environment.Vector3
                V="new"
                y="math"
                Y=S.new
                g=environment.math
                V=g.max
                Z=l.X
                O=1.5
                y=Z*O
                Z=5
                g=V(y,Z)
                V=1
                Z=environment.math
                y=Z.max
                D=l.Z
                A=1.5
                O=D*A
                D=5
                Z={y(O,D)}
                S=Y(g,V,unpackValues(Z))
                t.Size=S
                t=w.value
                C="Position"
                S=environment.Vector3
                Y=S.new
                Z=capturedCells[4].value
                V=K.X
                g=0
                y=K.Z
                S=Y(V,g,y)
                t.Position=S
                t=w.value
                C="Anchored"
                Y=true
                t.Anchored=Y
                t=w.value
                C="Transparency"
                Y=1
                t.Transparency=Y
                t=w.value
                C="Parent"
                Y=environment.workspace
                t.Parent=Y
                C=environment.task
                Y="delay"
                S=makeClosure4(fn_destroy_instance,{w})
                t=C.delay
                w=nil
                Y=0.5
                C=t(Y,S)
            end
            C=environment.task
            t=C.wait
            u=nil
            K=.05
            C=t(K)
        else
            break
        end
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_set_background_color = function(capturedCells, color, arg2, arg3)
    local t = nil
    local u, l, Y, C, w, K
    local result
    C=capturedCells[1].value
    u=capturedCells[2].value
    t=C[u]
    if t then
        u=nil
        t=capturedCells[1].value
        C=capturedCells[2].value
        t[C]=u
        t=capturedCells[3].value
        C="BackgroundColor3"
        K=environment.Color3
        u=K.fromRGB
        Y=41
        l=36
        w=38
        K=u(l,w,Y)
        t.BackgroundColor3=K
        t=capturedCells[6].value
        u=capturedCells[2].value
        C=t(u)
    else
        u=true
        t=capturedCells[1].value
        C=capturedCells[2].value
        t[C]=u
        t=capturedCells[3].value
        C="BackgroundColor3"
        K=environment.Color3
        l="fromRGB"
        w=58
        Y=32
        u=K.fromRGB
        l=32
        K=u(l,w,Y)
        t.BackgroundColor3=K
        t=capturedCells[7].value
        u=capturedCells[2].value
        C=t(u)
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_destroy_instance = function(capturedCells, instance, arg2, arg3, arg4)
    local t = nil
    local C
    local result
    t=capturedCells[1].value
    if t then
        t=capturedCells[1].value
        C="Destroy"
        C=C(t)
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_auto_eat_worker = function(capturedCells, arg1, arg2, arg3, arg4, arg5)
    local t = nil
    local u, l, C, w, K
    local result
    while true do
        t=capturedCells[1].value
        if t then
            t=capturedCells[2].value
            C=t()
            u=C
            if u then
                t="FindFirstChild"
                t=u.FindFirstChild
                C="Grab"
                t=t(u,C)
                K=t
                t="FindFirstChild"
                t=u.FindFirstChild
                C="Eat"
                t=t(u,C)
                C=K
                l=t
                if K then
                    C=l
                end
                if C then
                    t=K.FireServer
                    t=t(K)
                    t=l.FireServer
                    t=t(l)
                end
            else
            end
            C=environment.task
            u=nil
            t=C.wait
            K=.01
            C=t(K)
        else
            break
        end
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_map_position_worker = function(capturedCells, arg1, arg2, arg3, arg4)
    local t = nil
    local k, G, u, m, Z, O, l, f, y, V, D, r
    local X, g, E, s, B, p, S, h, Y, C, A, w
    local K, U, N
    local result
    l=capturedCells[1].value
    Y=capturedCells[2].value
    K=l.Parent
    u=not K
    C=u
    if u then
    else
        t = 16417114 -- valor que o registrador t tinha ao entrar neste bloco;
        K=t
        w=capturedCells[4].value
        l=not w
        u=l
        if l then
        else
            t = 9585450 -- valor que o registrador t tinha ao entrar neste bloco;
            V=capturedCells[4].value
            S=V.Parent
            Y=not S
            l=Y
            if Y then
            else
                V=environment.tick
                g=V()
                V=capturedCells[5].value
                S=g-V
                V=.9
                Y=S>=V
                l=Y
            end
            u=l
        end
        t=K
        C=u
    end
    if C then
        t=capturedCells[6].value
        if t then
            t=capturedCells[7].value
            C="CFrame"
            u=capturedCells[8].value
            t.CFrame=u
            t=capturedCells[9].value
            if t then
                t=capturedCells[9].value
                C="PlatformStand"
                u=true
                t.PlatformStand=u
            end
        else
            t=capturedCells[7].value
            C="CFrame"
            u=capturedCells[10].value
            t.CFrame=u
        end
        t=capturedCells[7].value
        C="AssemblyLinearVelocity"
        K=environment.Vector3
        u=K.zero
        t.AssemblyLinearVelocity=u
        t=capturedCells[7].value
        C="AssemblyAngularVelocity"
        K=environment.Vector3
        u=K.zero
        t.AssemblyAngularVelocity=u
        C=false
        t=false
        capturedCells[11].value=t
        capturedCells[12].value=C
        u=capturedCells[13].value
        if u then
            u=capturedCells[13].value
            K=u.Destroy
            K=K(u)
            u=nil
            capturedCells[13].value=u
        end
        K=capturedCells[14].value
        if K then
            l="Disconnect"
            K=capturedCells[14].value
            l=K.Disconnect
            l=l(K)
        end
        C={}
        result = C or {}
        return unpackValues(result or {})
    else
        K=environment.pairs
        g="GetDescendants"
        S=capturedCells[15].value
        g=S.GetDescendants
        V={g(S)}
        S={K(unpackValues(V))}
        l=S[1]
        Y=S[3]
        w=S[2]
        while true do
            Y,S=l(w,Y)
            if Y then
                g="BasePart"
                V=S.IsA
                V=V(S,g)
                if V then
                    V="CanCollide"
                    g=false
                    S.CanCollide=g
                end
                K=nil
            else
                break
            end
        end
        w=environment.tick
        Y=w()
        w=capturedCells[16].value
        l=Y-w
        w=.1
        K=l>w
        if K then
            K=environment.tick
            l=K()
            capturedCells[16].value=l
            w=capturedCells[4].value
            K=w.Position
            S=capturedCells[4].value
            Y=S.CFrame
            V=capturedCells[2].value
            D=423886864581
            w=Y.LookVector
            S=capturedCells[17].value
            Y=S.Character
            if Y then
                S=Y.GetExtentsSize
                S=S(Y)
                g=Y.GetPivot
                g=g(Y)
                V=g.Position
                y=V.Y
                O=S.Y
                D=2
                Z=O/D
                g=y-Z
                Z="GetExtentsSize"
                y=capturedCells[15].value
                Z=y.GetExtentsSize
                Z=Z(y)
                D="GetPivot"
                O=capturedCells[15].value
                D=O.GetPivot
                D=D(O)
                y=D.Position
                p=capturedCells[7].value
                A=p.Position
                D=A.Y
                p=y.Y
                k=Z.Y
                N=2
                U=k/N
                A=p-U
                O=D-A
                A=environment.Vector3
                D=A.new
                p=K.X
                U=g+O
                k=K.Z
                A=D(p,U,k)
                D=capturedCells[7].value
                p="CFrame"
                k=environment.CFrame
                U=k.new
                G=capturedCells[7].value
                r=G.Size
                m=r.Y
                r=2
                E=m/r
                h=w*E
                N=A-h
                k=U(N,A)
                D.CFrame=k
                D=capturedCells[13].value
                if D then
                    D=capturedCells[13].value
                    p="Position"
                    k=environment.Vector3
                    U=k.new
                    h="X"
                    E=0.5
                    N=A.X
                    h=g-E
                    E=A.Z
                    k=U(N,h,E)
                    D.Position=k
                end
                V=nil
            else
            end
            t = 7261463 -- valor que o registrador t tinha ao entrar neste bloco;
            S=capturedCells[18].value
            V=S()
            S=V
            if V then
                y=V.FindFirstChild
                Z="Grab"
                y=y(V,Z)
                S=y
            end
            if S then
                S=V.Grab
                Z=true
                g=S.FireServer
                y=false
                O="弯腰抓取"
                g=g(S,y,Z,K,O)
            end
        else
        end
        C={}
        result = C or {}
        return unpackValues(result or {})
    end
end
fn_create_player_highlight = function(capturedCells, player, arg2, arg3)
    local t = nil
    local u, Z, O, l, y, V, D, g, p, S, Y, C
    local A, w, K
    local entry, block_01, block_02, block_03, block_04
    local result
    u=allocateCell()
    u.value=player
    t=capturedCells[1].value
    K=capturedCells[2].value
    C=t(K)
    C=environment.Instance
    t=C.new
    K="Highlight"
    C=t(K)
    K=C
    t="OutlineColor"
    l=environment.Color3
    w="fromRGB"
    S=255
    C=l.fromRGB
    Y=255
    w=255
    l=C(w,Y,S)
    K.OutlineColor=l
    t="FillTransparency"
    C=1
    K.FillTransparency=C
    t="Parent"
    C=u.value
    K.Parent=C
    t=u.value
    C="FindFirstChild"
    l="Head"
    C=t.FindFirstChild
    C=C(t,l)
    l=allocateCell()
    l.value=C
    t=u.value
    C="FindFirstChildOfClass"
    w="Humanoid"
    C=t.FindFirstChildOfClass
    C=C(t,w)
    w=allocateCell()
    w.value=C
    Y=l.value
    C=Y
    if Y then
        Y=w.value
        C=Y
    end
    if C then
        C=environment.Instance
        t=C.new
        Y="BillboardGui"
        C=t(Y)
        Y=allocateCell()
        Y.value=C
        t=Y.value
        C="Size"
        V=environment.UDim2
        S=V.new
        O=24
        y=48
        Z=0
        g=0
        V=S(g,y,Z,O)
        t.Size=V
        t=Y.value
        C="AlwaysOnTop"
        S=true
        t.AlwaysOnTop=S
        t=Y.value
        C="Parent"
        S=l.value
        t.Parent=S
        C=environment.Instance
        t=C.new
        S="TextLabel"
        C=t(S)
        S=allocateCell()
        S.value=C
        t=S.value
        C="Size"
        g=environment.UDim2
        y="new"
        D=24
        O=0
        Z=32
        V=g.new
        y=0
        g=V(y,Z,O,D)
        t.Size=g
        t=S.value
        C="Position"
        g=environment.UDim2
        y="new"
        Z=8
        O=0
        V=g.new
        y=0
        D=0
        g=V(y,Z,O,D)
        t.Position=g
        t=S.value
        C="BackgroundTransparency"
        V=1
        t.BackgroundTransparency=V
        t=S.value
        C="TextColor3"
        g=environment.Color3
        O=255
        V=g.fromRGB
        Z=255
        y=255
        g=V(y,Z,O)
        t.TextColor3=g
        t=S.value
        C="TextStrokeTransparency"
        V=0
        t.TextStrokeTransparency=V
        t=S.value
        Z="Enum"
        C="Font"
        y=environment.Enum
        g=y.Font
        V=g.GothamBold
        t.Font=V
        t=S.value
        C="Parent"
        V=Y.value
        t.Parent=V
        C=capturedCells[5].value
        t=C.RenderStepped
        C="Connect"
        V=makeClosure2(fn_update_esp_display,{capturedCells[6],capturedCells[2],u;capturedCells[3],capturedCells[4];S,w;Y;l})
        C=t.Connect
        C=C(t,V)
        V=C
        S=nil
        t=capturedCells[7].value
        C=capturedCells[2].value
        y="highlight"
        Z="billboard"
        O=Y.value
        D="connection"
        g={[y]=K,[Z]=O,[D]=V}
        Y=nil
        t[C]=g
    end
    l=nil
    w=nil
    C={}
    u=nil
    result = C or {}
    return unpackValues(result or {})
end
fn_unanchor_worker = function(capturedCells)
    local t = nil
    local u, l, S, Y, C, w, K
    local result
    while true do
        t=capturedCells[1].value
        if t then
            C=capturedCells[2].value
            K=capturedCells[3].value
            t=C.Character
            u=t
            if u then
                C="HumanoidRootPart"
                t=u.FindFirstChild
                t=t(u,C)
                K=t
                C=K
                if K then
                    l=K.Anchored
                    C=l
                end
                if C then
                    t="Anchored"
                    C=false
                    K.Anchored=C
                end
            else
            end
            C=environment.task
            t=C.wait
            K=.03
            u=nil
            C=t(K)
        else
            break
        end
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_fire_spin_event = function(capturedCells, arg1, arg2)
    local t = nil
    local u, l, C, K
    local entry, block_01, block_02, block_03, block_04
    local result
    t=capturedCells[1].value
    K=capturedCells[2].value
    C="FindFirstChild"
    u="Events"
    C=t.FindFirstChild
    C=C(t,u)
    u=C
    if u then
        t="FindFirstChild"
        C="SpinEvent"
        t=u.FindFirstChild
        t=t(u,C)
        K=t
        if K then
            t=K.FireServer
            t=t(K)
        end
    else
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_destroy_instance_alt = function(capturedCells)
    local t = nil
    local C
    local entry
    local result
    t=capturedCells[1].value
    C="Destroy"
    C=C(t)
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_copy_discord_link = function(capturedCells, arg1, arg2, arg3, arg4)
    local t = nil
    local u, l, C, K
    local entry
    local result
    t=environment.setclipboard
    u="https://discord.gg/GrPQCcrU5"
    C=t(u)
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_resize_canvas_y = function(capturedCells, arg1, arg2, arg3, arg4)
    local t = nil
    local u, Z, O, l, y, V, g, S, Y, C, w, K
    local entry
    local result
    t=capturedCells[1].value
    C="CanvasSize"
    K=environment.UDim2
    u=K.new
    w=0
    l=0
    Y=0
    g=capturedCells[4].value
    V=g.AbsoluteContentSize
    S=V.Y
    K=u(l,w,Y,S)
    t.CanvasSize=K
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_create_text_button = function(capturedCells, text, parent)
    local t = nil
    local u, l, V, g, S, Y, C, w, K
    local entry
    local result
    u=text
    C=environment.Instance
    t=C.new
    l="TextButton"
    C=t(l)
    K=parent
    l=C
    t="Size"
    w=environment.UDim2
    V=0
    Y="new"
    g=30
    S=-6
    C=w.new
    Y=1
    w=C(Y,S,V,g)
    l.Size=w
    t="Text"
    C=u
    l.Text=C
    t="BackgroundColor3"
    w=environment.Color3
    C=w.fromRGB
    S=38
    Y=36
    V=41
    w=C(Y,S,V)
    l.BackgroundColor3=w
    t="TextSize"
    C=12
    l.TextSize=C
    t="Parent"
    C=K
    l.Parent=C
    t=capturedCells[3].value
    C=t(l)
    C={l}
    result = C or {}
    return unpackValues(result or {})
end
fn_toggle_only_eat = function(capturedCells, arg1, arg2)
    local t = nil
    local u, Z, l, y, V, g, S, Y, C, w, K
    local result
    C=capturedCells[1].value
    t=not C
    capturedCells[1].value=t
    C=capturedCells[2].value
    u="Text"
    S=capturedCells[1].value
    w=S
    if S then
        S="Only Eat : ON"
        w=S
    end
    K=w
    if w then
    else
        S=capturedCells[4].value
        w="Only Eat : OFF"
        K=w
    end
    C[u]=K
    C=capturedCells[2].value
    u="BackgroundColor3"
    S=capturedCells[1].value
    w=S
    if S then
        V=environment.Color3
        g="fromRGB"
        Z=32
        y=58
        S=V.fromRGB
        g=32
        V=S(g,y,Z)
        w=V
    end
    K=w
    if w then
    else
        Y=environment.Color3
        w=Y.fromRGB
        V=38
        S=36
        g=41
        Y=w(S,V,g)
        K=Y
    end
    C[u]=K
    C=capturedCells[1].value
    if C then
        u=environment.task
        C=u.spawn
        K=makeClosure5(fn_auto_eat_worker,{capturedCells[1],capturedCells[5],capturedCells[3],capturedCells[4]})
        u=C(K)
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_toggle_unanchor = function(capturedCells)
    local t = nil
    local u, Z, l, y, V, g, S, Y, C, w, K
    local result
    C=capturedCells[1].value
    t=not C
    capturedCells[1].value=t
    C=capturedCells[2].value
    u="Text"
    S=capturedCells[1].value
    w=S
    if S then
        S="Unanchor : ON"
        w=S
    end
    K=w
    if w then
    else
        S=capturedCells[4].value
        w="Unanchor : OFF"
        K=w
    end
    C[u]=K
    C=capturedCells[2].value
    u="BackgroundColor3"
    S=capturedCells[1].value
    w=S
    if S then
        V=environment.Color3
        g="fromRGB"
        Z=32
        y=58
        S=V.fromRGB
        g=32
        V=S(g,y,Z)
        w=V
    end
    K=w
    if w then
    else
        Y=environment.Color3
        S="fromRGB"
        g=41
        w=Y.fromRGB
        S=36
        V=38
        Y=w(S,V,g)
        K=Y
    end
    C[u]=K
    C=capturedCells[1].value
    if C then
        u=environment.task
        C=u.spawn
        K=makeClosure0(fn_unanchor_worker,{capturedCells[1];capturedCells[5],capturedCells[3],capturedCells[4]})
        u=C(K)
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_toggle_floor = function(capturedCells, arg1, arg2, arg3)
    local t = nil
    local u, Z, l, y, V, g, S, Y, C, w, K
    local result
    C=capturedCells[1].value
    t=not C
    capturedCells[1].value=t
    C=capturedCells[2].value
    u="Text"
    S=capturedCells[1].value
    w=S
    if S then
        S="Floor : ON"
        w=S
    end
    K=w
    if w then
    else
        S=capturedCells[4].value
        w="Floor : OFF"
        K=w
    end
    C[u]=K
    C=capturedCells[2].value
    u="BackgroundColor3"
    S=capturedCells[1].value
    w=S
    if S then
        V=environment.Color3
        S=V.fromRGB
        g=32
        Z=32
        y=58
        V=S(g,y,Z)
        w=V
    end
    K=w
    if w then
    else
        Y=environment.Color3
        w=Y.fromRGB
        V=38
        g=41
        S=36
        Y=w(S,V,g)
        K=Y
    end
    C[u]=K
    C=capturedCells[1].value
    if C then
        u=environment.task
        C=u.spawn
        K=makeClosure0(fn_floor_worker,{capturedCells[1],capturedCells[5];capturedCells[3];capturedCells[4];capturedCells[6]})
        u=C(K)
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_anti_void_worker = function(capturedCells, arg1, arg2, arg3, arg4)
    local t = nil
    local u, Z, O, l, y, V, g, S, Y, C, w, K
    local result
    C=capturedCells[1].value
    t=C.Character
    u=t
    t=not u
    if t then
        C={}
        result = C or {}
    else
        t="FindFirstChild"
        t=u.FindFirstChild
        C="HumanoidRootPart"
        t=t(u,C)
        K=t
        t=not K
        if t then
            C={}
            result = C or {}
        else
            t="AssemblyLinearVelocity"
            l=environment.Vector3
            C=l.zero
            K.AssemblyLinearVelocity=C
            t="AssemblyAngularVelocity"
            l=environment.Vector3
            C=l.zero
            K.AssemblyAngularVelocity=C
            t="CFrame"
            l=environment.CFrame
            Y=capturedCells[2].value
            S=100
            C=l.new
            w=0
            g=K.Size
            V=g.Y
            Y=S+V
            S=0
            l=C(w,Y,S)
            C={}
            K.CFrame=l
            result = C or {}
        end
    end
    return unpackValues(result or {})
end
fn_toggle_anti_void = function(capturedCells, arg1, arg2, arg3, arg4, arg5)
    local t = nil
    local u, Z, l, y, V, g, S, Y, C, w, K
    local result
    C=capturedCells[1].value
    t=not C
    capturedCells[1].value=t
    C=capturedCells[2].value
    u="Text"
    S=capturedCells[1].value
    w=S
    if S then
        S="Anti Void : ON"
        w=S
    end
    K=w
    if w then
    else
        S=capturedCells[4].value
        w="Anti Void : OFF"
        K=w
    end
    C[u]=K
    C=capturedCells[2].value
    u="BackgroundColor3"
    S=capturedCells[1].value
    w=S
    if S then
        V=environment.Color3
        S=V.fromRGB
        y=58
        Z=32
        g=32
        V=S(g,y,Z)
        w=V
    end
    K=w
    if w then
    else
        Y=environment.Color3
        w=Y.fromRGB
        S=36
        V=38
        g=41
        Y=w(S,V,g)
        K=Y
    end
    C[u]=K
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_toggle_aim_lock = function(capturedCells, arg1, arg2)
    local t = nil
    local u, Z, l, y, V, g, S, Y, C, w, K
    local result
    C=capturedCells[1].value
    t=not C
    capturedCells[1].value=t
    C=capturedCells[2].value
    u="Text"
    S=capturedCells[1].value
    w=S
    if S then
        S="Aim Lock : ON"
        w=S
    end
    K=w
    if w then
    else
        S=capturedCells[4].value
        w="Aim Lock : OFF"
        K=w
    end
    C[u]=K
    C=capturedCells[2].value
    u="BackgroundColor3"
    S=capturedCells[1].value
    w=S
    if S then
        V=environment.Color3
        Z=32
        S=V.fromRGB
        y=58
        g=32
        V=S(g,y,Z)
        w=V
    end
    K=w
    if w then
    else
        Y=environment.Color3
        w=Y.fromRGB
        V=38
        g=41
        S=36
        Y=w(S,V,g)
        K=Y
    end
    C[u]=K
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_toggle_safe_zone = function(capturedCells, arg1, arg2, arg3, arg4)
    local t = nil
    local u, l, y, V, g, S, Y, C, w, K
    local result
    C=capturedCells[1].value
    t=not C
    capturedCells[1].value=t
    C=capturedCells[1].value
    if C then
        t = 11779366 -- valor que o registrador t tinha ao entrar neste bloco;
        C=capturedCells[2].value
        u="Text"
        K="Safe Zone : ON"
        C.Text=K
        C=capturedCells[2].value
        u="BackgroundColor3"
        l=environment.Color3
        w="fromRGB"
        S=32
        Y=58
        K=l.fromRGB
        w=32
        l=K(w,Y,S)
        C.BackgroundColor3=l
        l=capturedCells[5].value
        K=l.Character
        C=K
        if K then
            l=capturedCells[5].value
            K=l.Character
            l="FindFirstChild"
            l=K.FindFirstChild
            w="HumanoidRootPart"
            l=l(K,w)
            C=l
        end
        if C then
            l=capturedCells[5].value
            K=l.Character
            u=K.HumanoidRootPart
            C=u.CFrame
            capturedCells[6].value=C
        end
        u=capturedCells[7].value
        K=u()
    else
        t = 11994866 -- valor que o registrador t tinha ao entrar neste bloco;
        u=capturedCells[2].value
        K="Text"
        l="Safe Zone : OFF"
        u.Text=l
        u=capturedCells[2].value
        K="BackgroundColor3"
        w=environment.Color3
        V=41
        Y="fromRGB"
        S=38
        l=w.fromRGB
        Y=36
        w=l(Y,S,V)
        u.BackgroundColor3=w
        u=capturedCells[8].value
        K=u()
        l=capturedCells[6].value
        u=l
        if l then
            t = 14983175 -- valor que o registrador t tinha ao entrar neste bloco;
            S=capturedCells[5].value
            Y=S.Character
            l=Y
            if Y then
                S=capturedCells[5].value
                Y=S.Character
                V="HumanoidRootPart"
                S=Y.FindFirstChild
                S=S(Y,V)
                l=S
            end
            u=l
        else
        end
        if u then
            l=capturedCells[5].value
            K=l.Character
            u=K.HumanoidRootPart
            K="CFrame"
            l=capturedCells[6].value
            u.CFrame=l
        end
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_tween_ui = function(capturedCells, arg1, arg2, arg3)
    local t = nil
    local u, Z, O, l, y, V, g, S, Y, C, w, K
    local entry
    local result
    t=capturedCells[1].value
    u=capturedCells[2].value
    l=environment.TweenInfo
    w="new"
    g="Enum"
    K=l.new
    V=environment.Enum
    w=0.5
    g="EasingStyle"
    C="Create"
    S=V.EasingStyle
    Y=S.Quint
    g=environment.Enum
    y="EasingDirection"
    C=t.Create
    V=g.EasingDirection
    S=V.In
    l=K(w,Y,S)
    w="Position"
    S=environment.UDim2
    V="new"
    g=400
    Z=-20
    Y=S.new
    V=1
    y=1
    S=Y(V,g,y,Z)
    K={[w]=S}
    C=C(t,u,l,K)
    t="Play"
    u=C
    t=u.Play
    t=t(u)
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_save_position = function(capturedCells, arg1, arg2)
    local t = nil
    local u, Z, O, l, y, V, D, X, g, p, S, Y
    local C, A, w, K, U
    local result
    C=capturedCells[1].value
    t=C.Character
    u=t
    t=not u
    if t then
        C={}
        result = C or {}
    else
        C="HumanoidRootPart"
        t=u.FindFirstChild
        t=t(u,C)
        K=t
        t=not K
        if t then
            C={}
            result = C or {}
        else
            t=K.Position
            capturedCells[4].value=t
            C=capturedCells[5].value
            l="Size"
            Y=environment.UDim2
            w=Y.new
            S=0
            V=160
            y=45
            g=0
            Y=w(S,V,g,y)
            C.Size=Y
            C=capturedCells[6].value
            l="Position"
            Y=environment.UDim2
            S="new"
            g=0
            w=Y.new
            V=10
            S=0
            y=4
            Y=w(S,V,g,y)
            C.Position=Y
            C=capturedCells[6].value
            l="TextSize"
            w=13
            C.TextSize=w
            C=capturedCells[7].value
            l="Position"
            Y=environment.UDim2
            S="new"
            V=10
            w=Y.new
            y=22
            g=0
            S=0
            Y=w(S,V,g,y)
            C.Position=Y
            C=capturedCells[7].value
            l="TextSize"
            w=11
            C.TextSize=w
            C=capturedCells[6].value
            l="Text"
            w="Position Saved"
            C.Text=w
            C=capturedCells[7].value
            l="Text"
            Y=environment.string
            w=Y.format
            S="X:%d Y:%d Z:%d"
            g=environment.math
            V=g.floor
            Z=capturedCells[4].value
            y=Z.X
            Z="math"
            g=V(y)
            y=environment.math
            V=y.floor
            O=capturedCells[4].value
            Z=O.Y
            O="math"
            y=V(Z)
            Z=environment.math
            V=Z.floor
            D=capturedCells[4].value
            O=D.Z
            Z={V(O)}
            Y=w(S,g,y,unpackValues(Z))
            C.Text=Y
            V="TweenInfo"
            C=capturedCells[8].value
            w=capturedCells[5].value
            S=environment.TweenInfo
            Y=S.new
            O="Enum"
            V=0.5
            Z=environment.Enum
            y=Z.EasingStyle
            g=y.Quint
            O=environment.Enum
            Z=O.EasingDirection
            y=Z.Out
            S=Y(V,g,y)
            V="Position"
            y=environment.UDim2
            Z="new"
            A=-20
            g=y.new
            Z=1
            O=-20
            D=1
            l="Create"
            y=g(Z,O,D,A)
            l=C.Create
            Y={[V]=y}
            l=l(C,w,S,Y)
            C="Play"
            w="task"
            C=l.Play
            C=C(l)
            l=environment.task
            w="delay"
            Y=makeClosure3(fn_tween_position,{capturedCells[8];capturedCells[5],capturedCells[2];capturedCells[3]})
            C=l.delay
            w=3
            l=C(w,Y)
            C={}
            result = C or {}
        end
    end
    return unpackValues(result or {})
end
fn_set_visible = function(capturedCells, visible, arg2, arg3, arg4)
    local t = nil
    local u, l, S, Y, C, w, K
    local entry
    local result
    t=capturedCells[1].value
    C="Visible"
    l=capturedCells[1].value
    K=l.Visible
    u=not K
    t.Visible=u
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_teleport_saved_position = function(capturedCells, arg1)
    local t = nil
    local u, l, V, g, S, Y, C, w, K
    local result
    while true do
        t=true
        if t then
            t=capturedCells[1].value
            if t then
                C=capturedCells[2].value
                K=capturedCells[3].value
                t=C.Character
                u=t
                if u then
                    t="FindFirstChild"
                    t=u.FindFirstChild
                    C="HumanoidRootPart"
                    t=t(u,C)
                    K=t
                    C=K
                    if K then
                        Y=K.Position
                        w=Y.Y
                        Y=-400
                        l=w<=Y
                        C=l
                    end
                    if C then
                        t="CFrame"
                        l=environment.CFrame
                        S=0
                        C=l.new
                        Y=100
                        w=0
                        l=C(w,Y,S)
                        K.CFrame=l
                    end
                else
                end
            else
            end
            C=environment.task
            t=C.wait
            C=t()
        else
            break
        end
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_auto_event_reward = function(capturedCells, arg1, arg2, arg3, arg4)
    while capturedCells[1].value.Parent do
        local timedRewards = capturedCells[4].value:FindFirstChild("TimedRewards", true)
        if timedRewards then
            local rewards = timedRewards:GetChildren()
            local replicatedStorage = capturedCells[5].value
            local hasEvents = replicatedStorage:FindFirstChild("Events")
            local rewardEvent
            if hasEvents then
                rewardEvent = replicatedStorage.Events:FindFirstChild("RewardEvent")
            end

            for _, reward in environment.ipairs(rewards) do
                local name = reward.Name
                local shouldClaim = name == "SmallReward"
                    or name == "MediumReward"
                    or name == "LargeReward"

                if shouldClaim then
                    if rewardEvent then
                        rewardEvent:FireServer(reward)
                    end
                    environment.task.wait(0.2)
                end
            end
        end

        environment.pcall(makeClosure2(fn_fire_spin_event, {
            capturedCells[5], capturedCells[2], capturedCells[3]
        }))
        environment.task.wait(1)
    end

    return
end

fn_aim_worker = function(capturedCells, arg1, arg2, arg3)
    local t = nil
    local u, Z, O, l, y, V, D, X, g, p, S, Y
    local C, A, w, K, U
    local result
    t=capturedCells[1].value
    if t then
        C=capturedCells[2].value
        t=C.Character
        u=t
        C=u
        if u then
            K="FindFirstChild"
            l="HumanoidRootPart"
            K=u.FindFirstChild
            K=K(u,l)
            C=K
        end
        if C then
            C="HumanoidRootPart"
            Y="workspace"
            t=u.HumanoidRootPart
            K=t
            w=environment.workspace
            l=w.CurrentCamera
            C=l.CFrame
            t=C.LookVector
            l=t
            t="CFrame"
            w=environment.CFrame
            C=w.new
            Y=K.Position
            Z="Vector3"
            V=K.Position
            y=environment.Vector3
            g=y.new
            Z=l.X
            O=0
            D=l.Z
            y=g(Z,O,D)
            S=V+y
            w=C(Y,S)
            K.CFrame=w
        end
        u=nil
    else
    end
    t=capturedCells[5].value
    if t then
        C=capturedCells[2].value
        t=C.Character
        u=t
        if u then
            t=environment.pairs
            Y=u.GetDescendants
            w={Y(u)}
            Y={t(unpackValues(w))}
            l=Y[3]
            C=Y[1]
            w=C
            K=Y[2]
            while true do
                l,S=w(K,l)
                if l then
                    t="IsA"
                    Z="BasePart"
                    t=S.IsA
                    V="BasePart"
                    t=t(S,V)
                    if t then
                        t="AssemblyAngularVelocity"
                        g=environment.Vector3
                        V=g.zero
                        S.AssemblyAngularVelocity=V
                        t="AssemblyLinearVelocity"
                        g=environment.Vector3
                        Z=capturedCells[3].value
                        V=g.zero
                        S.AssemblyLinearVelocity=V
                    end
                else
                    break
                end
            end
        else
        end
        u=nil
    else
    end
    u=capturedCells[2].value
    Y="Character"
    t=u.Character
    u=t
    if u then
        t="FindFirstChild"
        t=u.FindFirstChild
        K="HumanoidRootPart"
        t=t(u,K)
        K=t
        t="FindFirstChildOfClass"
        l="Humanoid"
        t=u.FindFirstChildOfClass
        t=t(u,l)
        l=t
        Y=capturedCells[6].value
        w=Y
        if Y then
            t = 2542573 -- valor que o registrador t tinha ao entrar neste bloco;
            Y=K
            if K then
                Z=capturedCells[4].value
                V=K.Anchored
                Y=V
            end
            w=Y
        else
        end
        if w then
            t="Anchored"
            w=false
            K.Anchored=w
        end
        if l then
            t=environment.pairs
            g=l.GetPlayingAnimationTracks
            V={g(l)}
            g={t(unpackValues(V))}
            Y=g[2]
            w=g[1]
            S=g[3]
            while true do
                S,g=w(Y,S)
                if S then
                    Z=capturedCells[6].value
                    y=Z
                    if Z then
                        O=environment.tick
                        D=O()
                        O=capturedCells[7].value
                        Z=D<O
                        y=Z
                    end
                    if y then
                        Z=capturedCells[8].value
                        y=Z[g]
                        t=not y
                        if t then
                            t=capturedCells[8].value
                            y=g.Speed
                            t[g]=y
                        end
                        y=9999999999999
                        t=g.AdjustSpeed
                        t=t(g,y)
                    else
                        y=capturedCells[8].value
                        t=y[g]
                        if t then
                            Z=capturedCells[8].value
                            y=Z[g]
                            t=g.AdjustSpeed
                            t=t(g,y)
                            t=capturedCells[8].value
                            y=nil
                            t[g]=y
                        end
                    end
                else
                    break
                end
            end
        else
        end
    else
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_character_animation_setup = function(capturedCells, character, arg2, arg3, arg4, arg5, arg6)
    local t = nil
    local u, l, V, g, S, Y, C, w, K
    local result
    u=character
    t=capturedCells[1].value
    if t then
        t=capturedCells[2].value
        C=t()
    end
    t=capturedCells[3].value
    if t then
        t=false
        capturedCells[3].value=t
        C=capturedCells[4].value
        K="Text"
        l="Remove Map : OFF"
        C.Text=l
        C=capturedCells[4].value
        K="BackgroundColor3"
        w=environment.Color3
        V=41
        l=w.fromRGB
        Y=36
        S=38
        w=l(Y,S,V)
        C.BackgroundColor3=w
        C=environment.pairs
        Y=capturedCells[7].value
        V=Y.GetChildren
        S={V(Y)}
        Y={C(unpackValues(S))}
        w=Y[3]
        l=Y[2]
        K=Y[1]
        while true do
            w,S=K(l,w)
            if w then
                C="Parent"
                V=environment.workspace
                S.Parent=V
            else
                break
            end
        end
        C=environment.workspace
        l="RemovedMapFloor"
        K=C.FindFirstChild
        K=K(C,l)
        if K then
            K=environment.workspace
            C=K.RemovedMapFloor
            K=C.Destroy
            K=K(C)
        end
    else
    end
    l=capturedCells[5].value
    C=u.WaitForChild
    K="HumanoidRootPart"
    C=C(u,K)
    K=C
    C=capturedCells[8].value
    if C then
        C="CFrame"
        w=environment.CFrame
        l=w.new
        Y=capturedCells[8].value
        w=l(Y)
        K.CFrame=w
    end
    C=u.WaitForChild
    l="Humanoid"
    w=5
    C=C(u,l,w)
    l=C
    if l then
        w="AnimationPlayed"
        Y=makeClosure2(fn_animation_timer,{capturedCells[9];capturedCells[5];capturedCells[6],capturedCells[10]})
        C=l.AnimationPlayed
        w=C.Connect
        w=w(C,Y)
    end
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_resize_scroll_canvas_2 = function(capturedCells)
    local t = nil
    local u, Z, O, l, y, V, D, g, p, S, Y, C
    local A, w, K
    local entry
    local result
    t=capturedCells[1].value
    C="CanvasSize"
    K=environment.UDim2
    u=K.new
    w=0
    g=capturedCells[4].value
    Y=0
    l=0
    V=g.AbsoluteContentSize
    S=V.Y
    K=u(l,w,Y,S)
    t.CanvasSize=K
    t=capturedCells[5].value
    C="Size"
    K=environment.UDim2
    g="math"
    u=K.new
    Y=0
    V=environment.math
    w=115
    l=0
    S=V.min
    O=capturedCells[4].value
    Z=O.AbsoluteContentSize
    y=Z.Y
    Z=25
    g=y+Z
    y=105
    V={S(g,y)}
    K=u(l,w,Y,unpackValues(V))
    t.Size=K
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_toggle_tp_attack = function(capturedCells)
    local t = nil
    local u, l, y, V, g, S, Y, C, w, K
    local result
    t=capturedCells[1].value
    C="Visible"
    l=capturedCells[1].value
    K=l.Visible
    u=not K
    t.Visible=u
    t=capturedCells[4].value
    K=t
    C="Text"
    S=capturedCells[1].value
    Y=S.Visible
    l=Y
    if Y then
        Y="TP Attack : ON"
        l=Y
    end
    u=l
    if l then
    else
        Y=capturedCells[3].value
        l="TP Attack : OFF"
        u=l
    end
    t=K
    t[C]=u
    t=capturedCells[4].value
    K=t
    C="BackgroundColor3"
    S=capturedCells[1].value
    Y=S.Visible
    l=Y
    if Y then
        S=environment.Color3
        y=32
        V="fromRGB"
        g=58
        Y=S.fromRGB
        V=32
        S=Y(V,g,y)
        l=S
    end
    u=l
    if l then
    else
        w=environment.Color3
        V=41
        l=w.fromRGB
        S=38
        Y=36
        w=l(Y,S,V)
        u=w
    end
    t=K
    t[C]=u
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_resize_scroll_canvas_3 = function(capturedCells)
    local t = nil
    local u, Z, O, l, y, V, D, g, p, S, Y, C
    local A, w, K
    local entry
    local result
    t=capturedCells[1].value
    C="CanvasSize"
    K=environment.UDim2
    l="new"
    w=0
    Y=0
    u=K.new
    l=0
    g=capturedCells[4].value
    V=g.AbsoluteContentSize
    S=V.Y
    K=u(l,w,Y,S)
    t.CanvasSize=K
    t=capturedCells[5].value
    C="Size"
    K=environment.UDim2
    l="new"
    g="math"
    u=K.new
    w=115
    Y=0
    V=environment.math
    l=0
    S=V.min
    O=capturedCells[4].value
    Z=O.AbsoluteContentSize
    y=Z.Y
    Z=25
    g=y+Z
    y=105
    V={S(g,y)}
    K=u(l,w,Y,unpackValues(V))
    t.Size=K
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_toggle_tp_grab = function(capturedCells)
    local t = nil
    local u, l, y, V, g, S, Y, C, w, K
    local result
    t=capturedCells[1].value
    C="Visible"
    l=capturedCells[1].value
    K=l.Visible
    u=not K
    t.Visible=u
    t=capturedCells[4].value
    C="Text"
    S=capturedCells[1].value
    K=t
    Y=S.Visible
    l=Y
    if Y then
        Y="TP Grab : ON"
        l=Y
    end
    u=l
    if l then
    else
        Y=capturedCells[3].value
        l="TP Grab : OFF"
        u=l
    end
    t=K
    t[C]=u
    t=capturedCells[4].value
    C="BackgroundColor3"
    K=t
    S=capturedCells[1].value
    Y=S.Visible
    l=Y
    if Y then
        S=environment.Color3
        Y=S.fromRGB
        y=32
        g=58
        V=32
        S=Y(V,g,y)
        l=S
    end
    u=l
    if l then
    else
        w=environment.Color3
        Y="fromRGB"
        S=38
        V=41
        l=w.fromRGB
        Y=36
        w=l(Y,S,V)
        u=w
    end
    t=K
    t[C]=u
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_tp_grab_worker = function(capturedCells, arg1, arg2, arg3)
    local t = nil
    local k, G, u, m, Z, O, l, f, y, V, D, r
    local g, E, s, B, p, S, h, Y, C, A, w, K
    local U, N
    local result
    C=capturedCells[1].value
    u=arg1
    Y="Character"
    t=C.Character
    K=allocateCell()
    K.value=t
    w=K.value
    l=not w
    C=l
    if l then
    else
        t = 4616618 -- valor que o registrador t tinha ao entrar neste bloco;
        V="FindFirstChild"
        S=K.value
        V=S.FindFirstChild
        g="HumanoidRootPart"
        V=V(S,g)
        Y=not V
        l=Y
        if Y then
        else
            t = 7569570 -- valor que o registrador t tinha ao entrar neste bloco;
            g=u.Character
            V=not g
            Y=V
            if V then
            else
                U=23882840222577
                g=u.Character
                y="FindFirstChild"
                Z="HumanoidRootPart"
                y=g.FindFirstChild
                y=y(g,Z)
                V=not y
                Y=V
            end
            l=Y
        end
        C=l
    end
    if C then
        C={}
        result = C or {}
        return unpackValues(result or {})
    else
        C=environment.workspace
        t=C.FallenPartsDestroyHeight
        l=allocateCell()
        l.value=t
        C=K.value
        t=C.HumanoidRootPart
        w=allocateCell()
        C="FindFirstChildOfClass"
        w.value=t
        t=K.value
        C=t.FindFirstChildOfClass
        Y="Humanoid"
        C=C(t,Y)
        Y=allocateCell()
        Y.value=C
        C=u.Character
        t=C.HumanoidRootPart
        g="FindFirstChild"
        S=allocateCell()
        S.value=t
        V=K.value
        g=V.FindFirstChild
        y="UpperTorso"
        g=g(V,y)
        C=g
        if g then
        else
            V=K.value
            g="FindFirstChild"
            g=V.FindFirstChild
            y="Torso"
            g=g(V,y)
            C=g
        end
        t = 9164172 -- valor que o registrador t tinha ao entrar neste bloco;
        V=C
        g=V
        if V then
            D=V.Size
            U=capturedCells[3].value
            O=D.Y
            D=1.3
            Z=O*D
            g=Z
        end
        Z="Vector3"
        y=1.5
        k=6876769209474
        C=g or y
        g=C
        y=environment.Vector3
        Z="new"
        O=0
        C=y.new
        Z=0
        y=C(Z,g,O)
        Z=allocateCell()
        Z.value=y
        y=w.value
        C=y.CFrame
        y=allocateCell()
        y.value=C
        C=environment.tick
        D=allocateCell()
        O=C()
        D.value=O
        O=true
        C=true
        capturedCells[4].value=C
        capturedCells[5].value=O
        U=Y.value
        A=U
        if U then
            U=capturedCells[6].value
            A=U
        end
        if A then
            A=Y.value
            k=capturedCells[3].value
            p="PlatformStand"
            U=false
            A.PlatformStand=U
        end
        t = 15742022 -- valor que o registrador t tinha ao entrar neste bloco;
        p=allocateCell()
        A=nil
        p.value=A
        U=capturedCells[7].value
        A=U.RenderStepped
        k=makeClosure2(fn_safe_zone_worker,{capturedCells[8];capturedCells[2];capturedCells[3];S,D,capturedCells[6],w;capturedCells[9],Y,y,l,capturedCells[4],capturedCells[5],p,K;Z})
        U=A.Connect
        U=U(A,k)
        p.value=U
        A=capturedCells[10].value
        N=t
        k=A()
        A=k
        if k then
            h="FindFirstChild"
            E="Throw"
            h=k.FindFirstChild
            h=h(k,E)
            A=h
        end
        t=N
        if A then
            A=1
            N=3
            h=N
            N=1
            E=N
            N=0
            m=E<N
            N=A-E
            while true do
                r=not m
                N=N+E
                A=N<=h
                A=r and A
                r=N>=h
                r=m and r
                A=r or A
                r=14312867
                t=A and r
                if t then
                    r=k.Throw
                    G=r.FireServer
                    G=G(r)
                    G=environment.task
                    r=G.wait
                    f=.05
                    G=r(f)
                else
                    break
                end
            end
        else
        end
        p=nil
        Z=nil
        w=nil
        C={}
        D=nil
        Y=nil
        y=nil
        l=nil
        S=nil
        K=nil
        result = C or {}
        return unpackValues(result or {})
    end
end
fn_all_players_worker = function(capturedCells, arg1, arg2)
    local t = nil
    local k, G, u, m, Z, O, l, f, y, V, D, r
    local X, g, E, s, B, p, S, h, Y, C, A, w
    local K, U, N
    local result
    u=allocateCell()
    u.value=arg1
    C=capturedCells[1].value
    Y="Character"
    t=C.Character
    K=allocateCell()
    K.value=t
    w=K.value
    l=not w
    C=l
    if l then
    else
        t = 15104080 -- valor que o registrador t tinha ao entrar neste bloco;
        S=K.value
        V="FindFirstChild"
        D="HumanoidRootPart"
        V=S.FindFirstChild
        g="HumanoidRootPart"
        V=V(S,g)
        Y=not V
        l=Y
        if Y then
        else
            t = 12843377 -- valor que o registrador t tinha ao entrar neste bloco;
            y=u.value
            D=capturedCells[3].value
            g=y.Character
            V=not g
            Y=V
            if V then
            else
                y=u.value
                g=y.Character
                y="FindFirstChild"
                D=capturedCells[3].value
                Z="HumanoidRootPart"
                y=g.FindFirstChild
                y=y(g,Z)
                V=not y
                Y=V
            end
            l=Y
        end
        C=l
    end
    if C then
        C={}
        result = C or {}
        return unpackValues(result or {})
    else
        C=environment.workspace
        t=C.FallenPartsDestroyHeight
        C=K.value
        t=C.HumanoidRootPart
        w=allocateCell()
        w.value=t
        t=K.value
        C=t.FindFirstChildOfClass
        Y="Humanoid"
        C=C(t,Y)
        Y=allocateCell()
        Y.value=C
        S=u.value
        C=S.Character
        t=C.HumanoidRootPart
        S=allocateCell()
        S.value=t
        C=w.value
        t=C.CFrame
        y=allocateCell()
        g=allocateCell()
        V=allocateCell()
        C="tick"
        V.value=t
        t=environment.tick
        C=t()
        g.value=C
        t=0
        y.value=t
        C=true
        t=true
        capturedCells[4].value=t
        capturedCells[5].value=C
        D=Y.value
        Z=D
        if D then
            D=capturedCells[6].value
            Z=D
        end
        if Z then
            Z=Y.value
            O="PlatformStand"
            D=false
            Z.PlatformStand=D
        end
        Z=nil
        D="GetExtentsSize"
        O=allocateCell()
        O.value=Z
        Z=K.value
        D=Z.GetExtentsSize
        p="Instance"
        D=D(Z)
        A=environment.Instance
        Z=A.new
        p="Part"
        A=Z(p)
        O.value=A
        Z=O.value
        p="Size"
        k=environment.Vector3
        N="new"
        E="math"
        U=k.new
        h=environment.math
        N=h.max
        C={}
        m=D.X
        r=1.5
        E=m*r
        m=5
        h=N(E,m)
        N=1
        m=environment.math
        E=m.max
        G=D.Z
        f=1.5
        r=G*f
        G=5
        m={E(r,G)}
        k=U(h,N,unpackValues(m))
        Z.Size=k
        Z=O.value
        p="Anchored"
        U=true
        Z.Anchored=U
        Z=O.value
        p="Transparency"
        U=1
        Z.Transparency=U
        Z=O.value
        k="workspace"
        p="Parent"
        U=environment.workspace
        Z.Parent=U
        p=allocateCell()
        Z=nil
        p.value=Z
        U=capturedCells[7].value
        Z=U.Heartbeat
        k=makeClosure4(fn_map_position_worker,{capturedCells[8],capturedCells[2];capturedCells[3];S,g;capturedCells[6];w,capturedCells[9],Y,V,capturedCells[4];capturedCells[5],O;p,K,y,u,capturedCells[10]})
        U="Connect"
        O=nil
        w=nil
        g=nil
        U=Z.Connect
        U=U(Z,k)
        u=nil
        K=nil
        V=nil
        p.value=U
        y=nil
        S=nil
        Y=nil
        p=nil
        result = C or {}
        return unpackValues(result or {})
    end
end
fn_create_player_button = function(capturedCells, player, arg2, arg3, arg4, arg5)
    local t = nil
    local u, l, V, g, S, Y, C, w, K
    local result
    u=allocateCell()
    u.value=player
    C=u.value
    K=capturedCells[1].value
    t=C==K
    if t then
        C={}
        result = C or {}
    else
        C=environment.Instance
        t=C.new
        K="TextButton"
        C=t(K)
        K=C
        t="Parent"
        C=capturedCells[4].value
        K.Parent=C
        t="Size"
        l=environment.UDim2
        C=l.new
        Y=-4
        S=0
        w=1
        V=18
        l=C(w,Y,S,V)
        K.Size=l
        t="Text"
        l=u.value
        C=l.DisplayName
        K.Text=C
        t="BackgroundColor3"
        l=environment.Color3
        w="fromRGB"
        S=41
        C=l.fromRGB
        w=36
        Y=38
        l=C(w,Y,S)
        K.BackgroundColor3=l
        t="TextSize"
        C=8
        K.TextSize=C
        t=capturedCells[5].value
        C=t(K)
        t=K.MouseButton1Click
        C=t.Connect
        l=makeClosure3(fn_callback_no_strings_2,{capturedCells[6];u})
        C=C(t,l)
        C=environment.Instance
        t=C.new
        l="TextButton"
        C=t(l)
        l=C
        t="Parent"
        C=capturedCells[7].value
        l.Parent=C
        t="Size"
        w=environment.UDim2
        Y="new"
        V=0
        C=w.new
        Y=1
        g=18
        S=-4
        w=C(Y,S,V,g)
        l.Size=w
        t="Text"
        w=u.value
        C=w.DisplayName
        l.Text=C
        t="BackgroundColor3"
        w=environment.Color3
        V=41
        C=w.fromRGB
        S=38
        Y=36
        w=C(Y,S,V)
        l.BackgroundColor3=w
        t="TextSize"
        C=8
        l.TextSize=C
        t=capturedCells[5].value
        C=t(l)
        C="MouseButton1Click"
        w=makeClosure3(fn_callback_no_strings_3,{capturedCells[8],u})
        t=l.MouseButton1Click
        u=nil
        C=t.Connect
        C=C(t,w)
        C={}
        result = C or {}
    end
    return unpackValues(result or {})
end
fn_protected_worker = function(capturedCells)
    while true do
        environment.task.wait(0.01)

        for key, enabled in environment.pairs(capturedCells[3].value) do
            if enabled then
                local keyCell = allocateCell(key)
                environment.pcall(makeClosure0(fn_fire_remote, {
                    capturedCells[4], keyCell
                }))
            end
        end
    end
end

fn_callback_no_strings_1 = function(capturedCells, arg1, arg2, arg3, arg4)
    local t = nil
    local C
    local entry
    local result
    t=capturedCells[1].value
    C=t()
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_event_animation_config = function(capturedCells, arg1, arg2)
    local t = nil
    local u, l, S, Y, C, w, K
    local entry
    local result
    t=capturedCells[1].value
    K=capturedCells[2].value
    u=K.id
    l=capturedCells[2].value
    K=l.speed
    C=t(u,K)
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_resize_scroll_canvas_4 = function(capturedCells, arg1, arg2, arg3, arg4, arg5)
    local t = nil
    local u, Z, O, l, y, V, D, g, p, S, Y, C
    local A, w, K
    local entry
    local result
    t=capturedCells[1].value
    C="CanvasSize"
    K=environment.UDim2
    u=K.new
    Y=0
    g=capturedCells[4].value
    l=0
    w=0
    V=g.AbsoluteContentSize
    S=V.Y
    K=u(l,w,Y,S)
    t.CanvasSize=K
    t=capturedCells[5].value
    C="Size"
    K=environment.UDim2
    g="math"
    l="new"
    Y=0
    u=K.new
    w=115
    l=0
    V=environment.math
    S=V.min
    O=capturedCells[4].value
    Z=O.AbsoluteContentSize
    y=Z.Y
    Z=25
    g=y+Z
    y=105
    V={S(g,y)}
    K=u(l,w,Y,unpackValues(V))
    t.Size=K
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_toggle_auto_event = function(capturedCells, arg1)
    local t = nil
    local u, l, y, V, g, S, Y, C, w, K
    local entry, block_01, block_02, block_03, block_04, block_05, block_06, block_07, block_08
    local result
    t=capturedCells[1].value
    C="Visible"
    l=capturedCells[1].value
    K=l.Visible
    u=not K
    t.Visible=u
    t=capturedCells[4].value
    C="Text"
    S=capturedCells[1].value
    K=t
    Y=S.Visible
    l=Y
    if Y then
        Y="Auto Event : ON"
        l=Y
    end
    u=l
    if l then
    else
        Y=capturedCells[3].value
        l="Auto Event : OFF"
        u=l
    end
    t=K
    t[C]=u
    t=capturedCells[4].value
    C="BackgroundColor3"
    S=capturedCells[1].value
    K=t
    Y=S.Visible
    l=Y
    if Y then
        S=environment.Color3
        y=32
        V="fromRGB"
        g=58
        Y=S.fromRGB
        V=32
        S=Y(V,g,y)
        l=S
    end
    u=l
    if l then
    else
        w=environment.Color3
        l=w.fromRGB
        V=41
        S=38
        Y=36
        w=l(Y,S,V)
        u=w
    end
    t=K
    t[C]=u
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_callback_no_strings_2 = function(capturedCells, arg1, arg2, arg3)
    local t = nil
    local u, C
    local entry
    local result
    t=capturedCells[1].value
    u=capturedCells[2].value
    C=t(u)
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_callback_no_strings_3 = function(capturedCells, arg1, arg2, arg3)
    local t = nil
    local u, C
    local entry
    local result
    t=capturedCells[1].value
    u=capturedCells[2].value
    C=t(u)
    C={}
    result = C or {}
    return unpackValues(result or {})
end
fn_safe_zone_worker = function(capturedCells, arg1, arg2)
    local t = nil
    local u, Z, O, l, y, V, D, X, g, p, S, Y
    local C, A, w, K, U
    local result
    l=capturedCells[1].value
    Y=capturedCells[2].value
    K=l.Parent
    u=not K
    C=u
    if u then
    else
        t = 12769119 -- valor que o registrador t tinha ao entrar neste bloco;
        w=capturedCells[4].value
        K=t
        l=not w
        u=l
        if l then
        else
            t = 3843915 -- valor que o registrador t tinha ao entrar neste bloco;
            V=capturedCells[4].value
            S=V.Parent
            Y=not S
            l=Y
            if Y then
            else
                V=environment.tick
                g=V()
                V=capturedCells[5].value
                S=g-V
                V=1
                Y=S>=V
                l=Y
            end
            u=l
        end
        t=K
        C=u
    end
    if C then
        t=capturedCells[6].value
        if t then
            t=capturedCells[7].value
            C="CFrame"
            u=capturedCells[8].value
            t.CFrame=u
            t=capturedCells[9].value
            if t then
                t=capturedCells[9].value
                C="PlatformStand"
                u=true
                t.PlatformStand=u
            end
        else
            t=capturedCells[7].value
            C="CFrame"
            u=capturedCells[10].value
            t.CFrame=u
        end
        t=environment.workspace
        C="FallenPartsDestroyHeight"
        u=capturedCells[11].value
        t.FallenPartsDestroyHeight=u
        t=capturedCells[7].value
        C="AssemblyLinearVelocity"
        K=environment.Vector3
        u=K.zero
        t.AssemblyLinearVelocity=u
        t=capturedCells[7].value
        C="AssemblyAngularVelocity"
        K=environment.Vector3
        u=K.zero
        t.AssemblyAngularVelocity=u
        t=false
        capturedCells[12].value=t
        C=false
        capturedCells[13].value=C
        u=capturedCells[14].value
        if u then
            K="Disconnect"
            u=capturedCells[14].value
            K=u.Disconnect
            K=K(u)
        end
        C={}
        result = C or {}
        return unpackValues(result or {})
    else
        V="GetDescendants"
        u=environment.pairs
        Y=capturedCells[15].value
        V=Y.GetDescendants
        S={V(Y)}
        Y={u(unpackValues(S))}
        w=Y[3]
        l=Y[2]
        K=Y[1]
        while true do
            w,Y=K(l,w)
            if w then
                S="IsA"
                S=Y.IsA
                V="BasePart"
                S=S(Y,V)
                if S then
                    S="CanCollide"
                    V=false
                    Y.CanCollide=V
                end
            else
                break
            end
        end
        C={}
        u=capturedCells[7].value
        K="AssemblyLinearVelocity"
        w=environment.Vector3
        l=w.zero
        u.AssemblyLinearVelocity=l
        u=capturedCells[7].value
        K="AssemblyAngularVelocity"
        w=environment.Vector3
        l=w.zero
        u.AssemblyAngularVelocity=l
        K=environment.Vector3
        u=K.new
        Y=capturedCells[4].value
        w=Y.Position
        l=w.X
        g=capturedCells[4].value
        V=g.Position
        S=V.Y
        Z=capturedCells[4].value
        y=Z.Position
        g=y.Y
        D=capturedCells[4].value
        O=D.Size
        Z=O.Y
        O=2
        y=Z/O
        V=g-y
        Y=S+V
        S=2
        w=Y/S
        V=capturedCells[4].value
        Z=capturedCells[3].value
        S=V.Position
        Y=S.Z
        K=u(l,w,Y)
        u=capturedCells[7].value
        l="CFrame"
        Y=environment.CFrame
        w=Y.new
        V=capturedCells[16].value
        S=K-V
        y=capturedCells[16].value
        g=K-y
        O=capturedCells[4].value
        Z=O.CFrame
        y=Z.LookVector
        V=g+y
        Y=w(S,V)
        u.CFrame=Y
        result = C or {}
        return unpackValues(result or {})
    end
end
fn_main = function(capturedCells, ...)
    local t = nil
local scratch01, scratch02, scratch03, scratch04, scratch05, scratch06, scratch07, scratch08, scratch09, scratch10, scratch11, scratch12, scratch13, scratch14, scratch15, scratch16, scratch17, scratch18, scratch19, scratch20, scratch21, scratch22, scratch23, scratch24, scratch25, scratch26, scratch27, scratch28, scratch29, scratch30, scratch31, scratch32, scratch33, scratch34, scratch35
    local d_, P_, uW, V_, A_, G, a_, S_, J_, m, dW, Z
    local t_, x_, bW, F_, tW, O, f, R_, I_, oW, IW, y
    local lW, V, D, H, Z_, CW, f_, xW, j_, s_, M_, H_
    local U_, LW, c, X, o_, q_, m_, X_, l_, z_, L_, h_
    local p_, g, JW, E, y_, iW, s, r_, aW, Q_, B, n_
    local p, g_, S, K_, E_, B_, F, O_, i_, W, C_, b_
    local Y, KW, T_, C, A, N_, W_, G_, c_, u_, w, v_
    local K, U, e_, w_, Y_, D_, k_, P
    -- Células preservadas apenas porque fazem parte dos captures das closures reconstruídas.
    K = allocateCell()
    K.value = decodedStringCache
    w = allocateCell()
    w.value = decodePlainString

    local gameObject = environment.game
    if not gameObject or gameObject.GameId ~= 5677613211 then
        return
    end

    local result

       Y=environment.game


       V="Players"
       S=Y.GetService
       S=S(Y,V)
       Y=allocateCell()
       Y.value=S
       S=environment.game


       g="RunService"
       V=S.GetService
       V=V(S,g)
       S=allocateCell()
       g="game"
       S.value=V
       V=environment.game


       g=V.GetService
       y="HttpService"
       g=g(V,y)
       V=environment.game


       Z="TweenService"
       y=V.GetService
       y=y(V,Z)
       V=allocateCell()
       V.value=y
       y=environment.game

       Z="GetService"

       Z=y.GetService
       O="UserInputService"
       Z=Z(y,O)
       y=environment.game


       O="GetService"
       D="ReplicatedStorage"
       O=y.GetService
       O=O(y,D)
       y=allocateCell()
       y.value=O
       D=Y.value


       O=D.LocalPlayer
       A="WaitForChild"
       D=allocateCell()
       D.value=O
       O=D.value

       A=O.WaitForChild

       p="PlayerGui"
       U="workspace"
       A=A(O,p)
       p=environment.workspace


       O=p.CurrentCamera
       U="WaitForChild"
       p=y.value

       U=p.WaitForChild

       E="Events"
       U=U(p,E)
       p="WaitForChild"


       p=U.WaitForChild
       E="SummonEvent"
       p=p(U,E)
       U=allocateCell()
       U.value=p
       p="FindFirstChild"

       p=A.FindFirstChild

       E="BattleScriptGUI"
       p=p(A,E)
    if p then
        p=A.BattleScriptGUI
        E=p.Destroy
        E=E(p)
    end

    m="name"


    G="Grab"


    f="id"


    s="rbxassetid://16493266847"


    B="speed"
    F=.65
    E={[m]=G;[f]=s,[B]=F}


    G="name"


    f="Eat"


    s="id"


    B="rbxassetid://16493281076"


    F="speed"
    H=1
    m={[G]=f,[s]=B;[F]=H}


    f="name"


    s="Throw"


    B="id"


    F="rbxassetid://16493298195"


    H="speed"
    P=.85
    G={[f]=s;[B]=F;[H]=P}


    s="name"


    B="Player Grab"


    F="id"


    H="rbxassetid://16493304009"


    P="speed"
    W=.95
    f={[s]=B;[F]=H;[P]=W}
    p={E,m,G;f}
    f=allocateCell()
    G=allocateCell()
    F=allocateCell()
    E=nil
    m=allocateCell()
    m.value=E
    s=allocateCell()
    E=false
    B=allocateCell()
    G.value=E
    E=false
    f.value=E
    E=false
    s.value=E
    E=0
    B.value=E
    E={}
    F.value=E

    H="Low Gravity"
    P=false


    W="Money Rain"
    c=false


    X="Robot"
    b_=false


    a_="Skeletons"


    t_=false
    o_="Nuke"
    x_=false
    E={[H]=P,[W]=c;[X]=b_,[a_]=t_,[o_]=x_}
    H=allocateCell()
    H.value=E

    P="Low Gravity"


    W="Money Rain"


    c="Robot"


    X="Skeletons"


    b_="Nuke"
    E={P;W;c,X;b_}
    W=environment.CFrame
    x_=400


    P=W.new
    c=0
    X=15000
    b_=0
    W=P(c,X,b_)
    P=allocateCell()
    c=allocateCell()
    P.value=W
    t_=400
    W=false
    X=allocateCell()
    c.value=W
    o_=10657240698
    W=nil
    b_=allocateCell()
    X.value=W
    W={}
    b_.value=W
    a_=8765953542
    W={[a_]=t_;[o_]=x_}
    o_=D.value


    t_=o_.UserId
    a_=W[t_]
    t_=allocateCell()
    t_.value=a_

    -- ================================================================
    -- SPEED PERSISTENTE
    -- Guarda a velocidade escolhida mesmo quando o personagem morre.
    -- Para os dois IDs que ja tinham Speed=400 no script original,
    -- o valor inicial continua sendo 400. Para os demais fica OFF ate
    -- que uma opcao seja escolhida na interface.
    -- ================================================================
    local speedCell = t_
    local localPlayerCell = D

    -- Mantem o WalkSpeed escolhido em todos os personagens/respawns.
    o_=S.value
    a_=o_.RenderStepped
    x_=makeClosure5(fn_character_walkspeed,{localPlayerCell,K,w,speedCell})
    o_=a_.Connect
    o_=o_(a_,x_)

    I_=makeClosure5(fn_find_character_event,{D;K;w})
    B_=6090098954
    a_=allocateCell()
    L_="Instance"
    e_=6070899844
    o_=makeClosure1(fn_reset_character_physics,{c;f;D,K;w,P})
    x_=makeClosure2(fn_platform_stand_cleanup,{b_,D;K;w})
    a_.value=o_
    o_=allocateCell()
    o_.value=x_
    d_=makeClosure0(fn_character_tracking,{K;w;b_,S;a_;D})
    N_=3424154009
    i_=makeClosure6(fn_style_button,{K;w})
    x_=allocateCell()
    x_.value=d_
    d_=allocateCell()
    O_=9515388641
    d_.value=I_
    I_=allocateCell()
    I_.value=i_
    C_=environment.Instance
    A_=5414663953


    f_=9508212224
    i_=C_.new

    F_=8570509038

    R_=10663803052
    E_=9516014431
    T_=3632035761
    V_=10397238620
    L_="ScreenGui"
    C_=i_(L_)
    i_=allocateCell()
    i_.value=C_
    C_=i_.value


    L_="Name"


    u_="BattleScriptGUI"
    C_.Name=u_
    C_=i_.value
    p_=4001797380

    k_=8646639667

    v_=10697324672
    r_=3507569900
    s_=10657240698
    m_=9269302700
    L_="ResetOnSpawn"
    u_=false
    C_.ResetOnSpawn=u_
    C_=i_.value


    L_="Parent"
    u_=A
    C_.Parent=u_
    S_=7013674312
    C_=i_.value


    h_=8765953542
    D_=2055872416
    L_="IgnoreGuiInset"
    u_=true
    C_.IgnoreGuiInset=u_
    C_=i_.value


    z_=8096881984
    K_="Enum"
    L_="ZIndexBehavior"
    g_=3080601393
    w_=environment.Enum
    Z_=7471067357

    G_=9473330269

    J_=w_.ZIndexBehavior


    w_="Sibling"
    U_=2838149488
    u_=J_.Sibling
    C_.ZIndexBehavior=u_
    C_=i_.value
    Y_=4164365779


    K_=5602499148
    J_=8646639667
    M_=7018096014
    l_=7221735983
    y_=8543449356
    L_="DisplayOrder"
    u_=999
    w_=7569257913
    Q_=9459622297
    C_.DisplayOrder=u_
    q_=7911735464
    L_=9116586938
    u_=8119021028
    -- Usa a WHITELIST definida no começo do arquivo.
    -- Mantem a mesma logica de verificacao do script original.
    C_ = WHITELIST
    L_=false
    u_=environment.pairs
    l_={u_(C_)}
    J_=l_[1]
    K_=l_[3]
    w_=l_[2]

    -- Percorre a whitelist do payload original.
    while true do
        K_, l_ = J_(w_, K_)
        if not K_ then
            break
        end

        Y_ = D.value
        Q_ = Y_.UserId
        q_ = Q_ == l_
        if q_ then
            u_ = nil
            q_ = true
            L_ = q_
            break
        else
            u_ = nil
        end
    end


    u_=not L_
    if u_ then
        J_=environment.Instance


        u_=J_.new


        w_="Frame"
        J_=u_(w_)
        u_=allocateCell()
        u_.value=J_
        J_=u_.value


        w_="Parent"
        K_=i_.value
        J_.Parent=K_
        J_=u_.value


        w_="AnchorPoint"
        l_=environment.Vector2


        K_=l_.new
        Q_=0.5
        Y_=0.5
        l_=K_(Q_,Y_)
        J_.AnchorPoint=l_
        J_=u_.value


        w_="Position"
        l_=environment.UDim2


        Q_="new"
        M_=0.5
        K_=l_.new
        Q_=0.5
        e_=0
        Y_=0
        l_=K_(Q_,Y_,M_,e_)
        J_.Position=l_
        J_=u_.value


        w_="Size"
        l_=environment.UDim2


        Q_="new"
        e_=120
        M_=0
        Y_=500
        K_=l_.new
        Q_=0
        l_=K_(Q_,Y_,M_,e_)
        J_.Size=l_
        J_=u_.value


        w_="BackgroundTransparency"
        K_=0.25
        J_.BackgroundTransparency=K_
        J_=u_.value


        w_="BackgroundColor3"
        l_=environment.Color3


        M_=28
        K_=l_.fromRGB
        Y_=25
        Q_=24
        l_=K_(Q_,Y_,M_)
        J_.BackgroundColor3=l_
        J_=u_.value


        w_="ZIndex"
        K_=60
        J_.ZIndex=K_
        w_=environment.Instance


        J_=w_.new


        K_="UICorner"
        w_=J_(K_)


        J_="Parent"
        K_=u_.value
        w_.Parent=K_

        J_="CornerRadius"
        l_=environment.UDim


        Q_="new"
        Y_=12
        K_=l_.new
        Q_=0
        l_=K_(Q_,Y_)
        w_.CornerRadius=l_
        K_=environment.Instance


        J_=K_.new


        l_="UIStroke"
        K_=J_(l_)


        J_="Parent"
        l_=u_.value
        K_.Parent=l_

        M_="Enum"
        J_="ApplyStrokeMode"
        Y_=environment.Enum


        Q_=Y_.ApplyStrokeMode


        l_=Q_.Border
        K_.ApplyStrokeMode=l_

        J_="LineJoinMode"
        Y_=environment.Enum


        Q_=Y_.LineJoinMode


        l_=Q_.Round
        K_.LineJoinMode=l_

        J_="Color"
        Q_=environment.Color3


        Y_="fromRGB"
        e_=58
        M_=54
        l_=Q_.fromRGB
        Y_=52
        Q_=l_(Y_,M_,e_)
        K_.Color=Q_

        J_="Thickness"
        l_=2
        Q_="Instance"
        K_.Thickness=l_
        l_=environment.Instance


        J_=l_.new


        Q_="TextLabel"
        l_=J_(Q_)


        J_="Parent"
        Q_=u_.value
        l_.Parent=Q_

        J_="BackgroundTransparency"
        Q_=1
        l_.BackgroundTransparency=Q_

        J_="Size"
        Y_=environment.UDim2


        M_="new"
        R_=0
        v_=70
        Q_=Y_.new
        e_=-20
        M_=1
        Y_=Q_(M_,e_,R_,v_)
        l_.Size=Y_

        J_="Position"
        Y_=environment.UDim2


        Q_=Y_.new
        v_=10
        M_=0
        R_=0
        e_=10
        Y_=Q_(M_,e_,R_,v_)
        l_.Position=Y_

        J_="TextColor3"
        Y_=environment.Color3


        Q_=Y_.new
        e_=1
        R_=1
        M_=1
        Y_=Q_(M_,e_,R_)
        l_.TextColor3=Y_

        J_="TextScaled"
        Q_=true
        l_.TextScaled=Q_

        e_="Enum"
        J_="Font"
        M_=environment.Enum


        Y_=M_.Font


        Q_=Y_.GothamBold
        l_.Font=Q_

        J_="ZIndex"
        Q_=61
        l_.ZIndex=Q_

        J_="Text"


        Q_="Add your ID to the whitelist"
        l_.Text=Q_
        Q_=environment.Instance


        J_=Q_.new


        Y_="TextButton"
        Q_=J_(Y_)


        J_="Parent"
        Y_=u_.value
        Q_.Parent=Y_

        J_="Size"
        M_=environment.UDim2


        v_=0
        Y_=M_.new
        e_=0
        R_=80
        z_=25
        M_=Y_(e_,R_,v_,z_)
        Q_.Size=M_

        J_="Position"
        M_=environment.UDim2

        C={}

        e_="new"
        v_=1
        Y_=M_.new
        z_=-35
        e_=0
        R_=10
        M_=Y_(e_,R_,v_,z_)
        Q_.Position=M_

        J_="Text"


        Y_="Close"
        Q_.Text=Y_

        J_="BackgroundColor3"
        M_=environment.Color3


        e_="fromRGB"
        v_=50
        R_=50
        Y_=M_.fromRGB
        e_=180
        M_=Y_(e_,R_,v_)
        Q_.BackgroundColor3=M_

        J_="TextColor3"
        M_=environment.Color3


        e_="new"
        v_=1
        R_=1
        Y_=M_.new
        e_=1
        M_=Y_(e_,R_,v_)
        Q_.TextColor3=M_

        J_="ZIndex"
        Y_=62
        Q_.ZIndex=Y_

        J_=Q_.MouseButton1Click
        M_=makeClosure0(fn_destroy_instance_alt,{u_})
        Y_=J_.Connect
        Y_=Y_(J_,M_)
        Y_=environment.Instance


        J_=Y_.new


        M_="TextButton"
        Y_=J_(M_)


        J_="Parent"
        M_=u_.value
        Y_.Parent=M_

        J_="Size"
        e_=environment.UDim2


        R_="new"
        z_=0
        v_=140
        T_=25
        M_=e_.new
        R_=0
        e_=M_(R_,v_,z_,T_)
        Y_.Size=e_

        J_="Position"
        e_=environment.UDim2


        M_=e_.new
        T_=-35
        v_=-150
        R_=1
        z_=1
        e_=M_(R_,v_,z_,T_)
        Y_.Position=e_

        J_="Text"


        M_="Copy Discord Link"
        Y_.Text=M_

        J_="BackgroundColor3"
        e_=environment.Color3


        M_=e_.fromRGB
        v_=100
        z_=180
        R_=50
        e_=M_(R_,v_,z_)
        Y_.BackgroundColor3=e_

        J_="TextColor3"
        e_=environment.Color3


        R_="new"
        v_=1
        M_=e_.new
        R_=1
        z_=1
        e_=M_(R_,v_,z_)
        Y_.TextColor3=e_

        J_="ZIndex"
        M_=62
        Y_.ZIndex=M_

        J_=Y_.MouseButton1Click
        e_=makeClosure4(fn_copy_discord_link,{K;w})
        M_=J_.Connect
        M_=M_(J_,e_)
        result = C or {}
        do return unpackValues(result or {}) end
    else
         J_=environment.Instance


         u_=J_.new


         w_="TextButton"
         J_=u_(w_)


         u_="Parent"
         w_=i_.value
         J_.Parent=w_

         u_="Size"
         K_=environment.UDim2


         w_=K_.new
         M_=28
         l_=0
         Q_=65
         Y_=0
         K_=w_(l_,Q_,Y_,M_)
         J_.Size=K_

         u_="Position"
         K_=environment.UDim2


         Y_=0
         w_=K_.new
         Q_=15
         M_=55
         l_=0
         K_=w_(l_,Q_,Y_,M_)
         J_.Position=K_

         u_="Text"


         w_="ETW"
         J_.Text=w_

         u_="BackgroundColor3"
         K_=environment.Color3


         l_="fromRGB"
         Q_=38
         Y_=41
         w_=K_.fromRGB
         l_=36
         K_=w_(l_,Q_,Y_)
         J_.BackgroundColor3=K_

         u_="ZIndex"
         w_=50
         J_.ZIndex=w_

         u_="TextSize"
         w_=12
         J_.TextSize=w_
         u_=I_.value
         K_="Instance"
         w_=u_(J_)
         w_=environment.Instance


         u_=w_.new


         K_="Frame"
         w_=u_(K_)
         u_=allocateCell()
         u_.value=w_
         w_=u_.value


         K_="Parent"
         l_=i_.value
         w_.Parent=l_
         w_=u_.value


         K_="Size"
         Q_=environment.UDim2


         Y_="new"
         e_=0
         l_=Q_.new
         R_=250
         Y_=0
         M_=190
         Q_=l_(Y_,M_,e_,R_)
         w_.Size=Q_
         w_=u_.value


         K_="Position"
         Q_=environment.UDim2


         Y_="new"
         e_=0
         M_=65
         R_=50
         l_=Q_.new
         Y_=0
         Q_=l_(Y_,M_,e_,R_)
         w_.Position=Q_
         w_=u_.value


         K_="BackgroundColor3"
         Q_=environment.Color3


         l_=Q_.fromRGB
         M_=25
         e_=28
         Y_=24
         Q_=l_(Y_,M_,e_)
         w_.BackgroundColor3=Q_
         w_=u_.value


         K_="Active"
         l_=true
         w_.Active=l_
         w_=u_.value


         K_="Draggable"
         l_=true
         w_.Draggable=l_
         w_=u_.value


         K_="Visible"
         l_=false
         w_.Visible=l_
         w_=u_.value


         K_="ZIndex"
         l_=50
         w_.ZIndex=l_
         K_=environment.Instance


         w_=K_.new


         l_="UICorner"
         K_=w_(l_)


         w_="CornerRadius"
         Q_=environment.UDim


         l_=Q_.new
         Y_=0
         M_=3
         Q_=l_(Y_,M_)
         K_.CornerRadius=Q_

         w_="Parent"
         l_=u_.value
         K_.Parent=l_
         l_=environment.Instance


         w_=l_.new


         Q_="UIStroke"
         l_=w_(Q_)


         w_="Color"
         Y_=environment.Color3


         R_=58
         Q_=Y_.fromRGB
         e_=54
         M_=52
         Y_=Q_(M_,e_,R_)
         l_.Color=Y_

         w_="Thickness"
         Q_=1
         l_.Thickness=Q_

         w_="Parent"
         Q_=u_.value
         l_.Parent=Q_
         Q_=environment.Instance


         w_=Q_.new


         Y_="TextLabel"
         Q_=w_(Y_)


         w_="Parent"
         Y_=u_.value
         Q_.Parent=Y_

         w_="Size"
         M_=environment.UDim2


         v_=0
         Y_=M_.new
         R_=0
         e_=1
         z_=32
         M_=Y_(e_,R_,v_,z_)
         Q_.Size=M_

         w_="BackgroundTransparency"
         Y_=1
         Q_.BackgroundTransparency=Y_

         w_="Text"


         Y_="BATTLE SCRIPT"
         Q_.Text=Y_

         w_="TextColor3"
         M_=environment.Color3


         Y_=M_.fromRGB
         R_=255
         e_=255
         v_=255
         M_=Y_(e_,R_,v_)
         Q_.TextColor3=M_

         w_="TextSize"
         Y_=14
         Q_.TextSize=Y_

         R_="Enum"
         w_="Font"
         e_=environment.Enum


         M_=e_.Font


         Y_=M_.GothamBold
         Q_.Font=Y_

         w_="ZIndex"
         Y_=51
         Q_.ZIndex=Y_
         Y_=environment.Instance


         w_=Y_.new


         M_="ScrollingFrame"
         Y_=w_(M_)
         w_=allocateCell()
         w_.value=Y_
         Y_=w_.value


         M_="Parent"
         e_=u_.value
         Y_.Parent=e_
         Y_=w_.value


         M_="Size"
         R_=environment.UDim2


         e_=R_.new
         T_=1
         z_=-10
         v_=1
         V_=-42
         R_=e_(v_,z_,T_,V_)
         Y_.Size=R_
         Y_=w_.value


         M_="Position"
         R_=environment.UDim2


         v_="new"
         T_=0
         z_=4
         e_=R_.new
         V_=34
         v_=0
         R_=e_(v_,z_,T_,V_)
         Y_.Position=R_
         Y_=w_.value


         M_="BackgroundTransparency"
         e_=1
         Y_.BackgroundTransparency=e_
         Y_=w_.value


         M_="ScrollBarThickness"
         e_=3
         Y_.ScrollBarThickness=e_
         Y_=w_.value


         M_="ScrollBarImageColor3"
         R_=environment.Color3


         T_=85
         e_=R_.fromRGB
         z_=85
         v_=85
         R_=e_(v_,z_,T_)
         Y_.ScrollBarImageColor3=R_
         Y_=w_.value


         M_="BorderSizePixel"
         e_=0
         Y_.BorderSizePixel=e_
         M_=environment.Instance


         Y_=M_.new


         e_="UIListLayout"
         M_=Y_(e_)
         Y_=allocateCell()
         Y_.value=M_
         M_=Y_.value


         e_="Parent"
         R_=w_.value
         M_.Parent=R_
         M_=Y_.value


         e_="Padding"
         v_=environment.UDim


         z_="new"
         T_=6
         R_=v_.new
         z_=0
         v_=R_(z_,T_)
         M_.Padding=v_
         M_=Y_.value


         e_="HorizontalAlignment"
         z_=environment.Enum


         v_=z_.HorizontalAlignment


         R_=v_.Center
         M_.HorizontalAlignment=R_
         M_=Y_.value


         e_="GetPropertyChangedSignal"
         R_="AbsoluteContentSize"
         e_=M_.GetPropertyChangedSignal
         e_=e_(M_,R_)
         M_="Connect"
         R_=makeClosure4(fn_resize_canvas_y,{w_,K;w,Y_})
         M_=e_.Connect
         M_=M_(e_,R_)
         M_=allocateCell()
         e_=makeClosure2(fn_create_text_button,{K;w;I_})
         M_.value=e_
         e_=M_.value


         v_="Only Eat : OFF"
         z_=w_.value
         R_=e_(v_,z_)
         e_=allocateCell()
         v_=allocateCell()
         e_.value=R_
         R_=false
         v_.value=R_
         z_=e_.value


         R_=z_.MouseButton1Click
         z_="Connect"
         T_=makeClosure2(fn_toggle_only_eat,{v_;e_;K,w;d_})
         z_=R_.Connect
         z_=z_(R_,T_)
         R_=M_.value


         T_="Unanchor : OFF"
         V_=w_.value
         z_=R_(T_,V_)
         R_=allocateCell()
         R_.value=z_
         z_=false
         T_=allocateCell()
         T_.value=z_
         V_=R_.value


         z_=V_.MouseButton1Click
         S_=makeClosure0(fn_toggle_unanchor,{T_;R_,K;w,D})
         V_=z_.Connect
         V_=V_(z_,S_)
         z_=M_.value


         S_="Floor : OFF"
         g_=w_.value
         V_=z_(S_,g_)
         z_=allocateCell()
         S_=allocateCell()
         z_.value=V_
         V_=false
         S_.value=V_
         g_=z_.value


         V_=g_.MouseButton1Click
         g_="Connect"
         Z_=makeClosure3(fn_toggle_floor,{S_;z_,K,w;i_,D})
         g_=V_.Connect
         g_=g_(V_,Z_)
         V_=M_.value


         Z_="TP Respawn"
         D_=w_.value
         g_=V_(Z_,D_)


         V_=g_.MouseButton1Click
         D_=makeClosure4(fn_anti_void_worker,{D;K,w})
         Z_=V_.Connect
         Z_=Z_(V_,D_)
         V_=M_.value


         D_="Set Respawn"
         O_=w_.value
         Z_=V_(D_,O_)
         V_=M_.value


         O_="Anti Void : ON"
         y_=w_.value
         D_=V_(O_,y_)
         V_=allocateCell()
         V_.value=D_
         D_=V_.value


         O_="BackgroundColor3"
         A_=environment.Color3


         y_=A_.fromRGB
         U_=58
         p_=32
         h_=32
         A_=y_(p_,U_,h_)
         D_.BackgroundColor3=A_
         O_=allocateCell()
         D_=true
         O_.value=D_
         y_=V_.value


         D_=y_.MouseButton1Click
         y_="Connect"
         A_=makeClosure5(fn_toggle_anti_void,{O_,V_,K;w})
         y_=D_.Connect
         y_=y_(D_,A_)

         -- ============================================================
         -- SPEED
         -- Botao principal + painel 4x3 com velocidades predefinidas.
         -- A escolha fica em speedCell e e reaplicada a cada frame,
         -- portanto continua funcionando depois de morrer/respawnar.
         -- ============================================================
         local createBattleButton = M_.value
         local battleScroll = w_.value
         local currentSpeed = speedCell.value
         local speedToggleText = currentSpeed and ("Speed : " .. tostring(currentSpeed)) or "Speed : OFF"
         local speedToggleButton = createBattleButton(speedToggleText, battleScroll)

         local speedPanel = environment.Instance.new("Frame")
         speedPanel.Name = "SpeedOptions"
         speedPanel.Parent = battleScroll
         speedPanel.BackgroundTransparency = 1
         speedPanel.BorderSizePixel = 0
         speedPanel.Visible = false
         speedPanel.Size = environment.UDim2.new(1, -4, 0, 0)

         local speedGrid = environment.Instance.new("UIGridLayout")
         speedGrid.Parent = speedPanel
         speedGrid.CellSize = environment.UDim2.new(0, 43, 0, 26)
         speedGrid.CellPadding = environment.UDim2.new(0, 4, 0, 4)
         speedGrid.FillDirectionMaxCells = 4
         speedGrid.HorizontalAlignment = environment.Enum.HorizontalAlignment.Center
         speedGrid.SortOrder = environment.Enum.SortOrder.LayoutOrder

         local speedValues = {
             50, 100, 200, 300,
             400, 500, 600, 700,
             800, 900, 1000, 1500,
         }

         local function closeSpeedPanel()
             speedPanel.Visible = false
             speedPanel.Size = environment.UDim2.new(1, -4, 0, 0)
         end

         local function applySelectedSpeed(speedValue)
             speedCell.value = speedValue
             speedToggleButton.Text = "Speed : " .. tostring(speedValue)

             -- Aplica imediatamente ao personagem atual.
             local player = localPlayerCell.value
             local character = player and player.Character
             if character then
                 local humanoid = character:FindFirstChildOfClass("Humanoid")
                 if humanoid then
                     humanoid.WalkSpeed = speedValue
                 end
             end

             closeSpeedPanel()
         end

         for index, speedValue in ipairs(speedValues) do
             local optionButton = createBattleButton(tostring(speedValue), speedPanel)
             optionButton.LayoutOrder = index
             optionButton.MouseButton1Click:Connect(function()
                 applySelectedSpeed(speedValue)
             end)
         end

         speedToggleButton.MouseButton1Click:Connect(function()
             local show = not speedPanel.Visible
             speedPanel.Visible = show
             speedPanel.Size = environment.UDim2.new(1, -4, 0, show and 86 or 0)
         end)

         D_=M_.value


         A_="Aim Lock : OFF"
         p_=w_.value
         y_=D_(A_,p_)
         A_=allocateCell()
         D_=allocateCell()
         D_.value=y_
         y_=false
         A_.value=y_
         p_=D_.value


         y_=p_.MouseButton1Click
         p_="Connect"
         U_=makeClosure2(fn_toggle_aim_lock,{A_,D_;K,w})
         p_=y_.Connect
         p_=p_(y_,U_)
         y_=M_.value


         U_="TP Attack : OFF"
         h_=w_.value
         p_=y_(U_,h_)
         y_=allocateCell()
         y_.value=p_
         p_=M_.value


         h_="TP Grab : OFF"
         N_=w_.value
         U_=p_(h_,N_)
         p_=allocateCell()
         p_.value=U_
         U_=M_.value


         N_="Remove Map : OFF"
         k_=w_.value
         h_=U_(N_,k_)
         U_=allocateCell()
         U_.value=h_
         h_=M_.value


         k_="ESP : OFF"
         E_=w_.value
         N_=h_(k_,E_)
         h_=allocateCell()
         h_.value=N_
         N_=M_.value


         E_="Fake Emote : OFF"
         m_=w_.value
         k_=N_(E_,m_)
         N_=allocateCell()
         N_.value=k_
         k_=M_.value


         m_="Auto Event : OFF"
         r_=w_.value
         E_=k_(m_,r_)
         k_=allocateCell()
         k_.value=E_
         E_=M_.value


         r_="Safe Zone : OFF"
         G_=w_.value
         m_=E_(r_,G_)
         E_=allocateCell()
         E_.value=m_
         r_=E_.value


         m_=r_.MouseButton1Click
         G_=makeClosure4(fn_toggle_safe_zone,{c;E_,K,w;D;X;x_,o_})
         r_=m_.Connect
         r_=r_(m_,G_)
         r_=environment.Instance


         m_=r_.new


         G_="Frame"
         r_=m_(G_)
         m_=allocateCell()
         m_.value=r_
         r_=m_.value


         G_="Parent"
         f_=i_.value
         r_.Parent=f_
         r_=m_.value


         G_="AnchorPoint"
         s_=environment.Vector2


         B_="new"
         F_=1
         f_=s_.new
         B_=1
         s_=f_(B_,F_)
         r_.AnchorPoint=s_
         r_=m_.value


         G_="Position"
         s_=environment.UDim2


         B_="new"
         H_=1
         f_=s_.new
         F_=400
         B_=1
         c_=-20
         s_=f_(B_,F_,H_,c_)
         r_.Position=s_
         r_=m_.value


         G_="Size"
         s_=environment.UDim2


         B_="new"
         c_=65
         H_=0
         f_=s_.new
         F_=300
         B_=0
         s_=f_(B_,F_,H_,c_)
         r_.Size=s_
         r_=m_.value


         G_="BackgroundTransparency"
         f_=0.25
         r_.BackgroundTransparency=f_
         r_=m_.value


         G_="BackgroundColor3"
         s_=environment.Color3


         f_=s_.fromRGB
         B_=24
         H_=28
         F_=25
         s_=f_(B_,F_,H_)
         r_.BackgroundColor3=s_
         r_=m_.value


         G_="ZIndex"
         f_=60
         r_.ZIndex=f_
         r_=m_.value


         G_="ClipsDescendants"
         f_=true
         r_.ClipsDescendants=f_
         G_=environment.Instance


         r_=G_.new


         f_="UICorner"
         G_=r_(f_)


         r_="CornerRadius"
         s_=environment.UDim


         f_=s_.new
         F_=6
         B_=0
         s_=f_(B_,F_)
         G_.CornerRadius=s_

         r_="Parent"
         s_="Instance"
         f_=m_.value
         G_.Parent=f_
         f_=environment.Instance


         r_=f_.new


         s_="UIStroke"
         f_=r_(s_)


         r_="Parent"
         s_=m_.value
         f_.Parent=s_

         H_="Enum"
         r_="ApplyStrokeMode"
         F_=environment.Enum


         B_=F_.ApplyStrokeMode


         s_=B_.Border
         f_.ApplyStrokeMode=s_

         r_="Color"
         B_=environment.Color3


         c_=58
         s_=B_.fromRGB
         F_=52
         H_=54
         B_=s_(F_,H_,c_)
         f_.Color=B_

         r_="Transparency"
         s_=.7
         f_.Transparency=s_

         r_="Thickness"
         B_="Instance"
         s_=1
         f_.Thickness=s_
         s_=environment.Instance


         r_=s_.new


         B_="TextLabel"
         s_=r_(B_)
         r_=allocateCell()
         r_.value=s_
         s_=r_.value


         B_="Parent"
         F_=m_.value
         s_.Parent=F_
         s_=r_.value


         B_="BackgroundTransparency"
         F_=1
         s_.BackgroundTransparency=F_
         s_=r_.value


         B_="Size"
         H_=environment.UDim2


         c_="new"
         P_=0
         j_=-30
         F_=H_.new
         c_=1
         X_=20
         H_=F_(c_,j_,P_,X_)
         s_.Size=H_
         s_=r_.value


         B_="Position"
         H_=environment.UDim2


         F_=H_.new
         c_=0
         P_=0
         j_=15
         X_=12
         H_=F_(c_,j_,P_,X_)
         s_.Position=H_
         s_=r_.value


         B_="RichText"
         F_=true
         s_.RichText=F_
         s_=r_.value


         B_="Text"


         F_="GUI was successfully executed <font size='12' color='#AAAAAA'>(Standard Version 2)</font>"
         s_.Text=F_
         s_=r_.value


         B_="TextColor3"
         H_=environment.Color3


         c_="fromRGB"
         j_=255
         F_=H_.fromRGB
         c_=255
         P_=255
         H_=F_(c_,j_,P_)
         s_.TextColor3=H_
         s_=r_.value


         B_="TextSize"
         F_=16
         s_.TextSize=F_
         s_=r_.value


         B_="Font"
         c_=environment.Enum


         H_=c_.Font


         F_=H_.SourceSansBold
         s_.Font=F_
         s_=r_.value


         B_="TextXAlignment"
         c_=environment.Enum


         H_=c_.TextXAlignment


         F_=H_.Left
         s_.TextXAlignment=F_
         s_=r_.value


         B_="ZIndex"
         F_=61
         s_.ZIndex=F_
         B_=environment.Instance


         s_=B_.new


         F_="TextLabel"
         B_=s_(F_)
         s_=allocateCell()
         s_.value=B_
         B_=s_.value


         F_="Parent"
         H_=m_.value
         B_.Parent=H_
         B_=s_.value


         F_="BackgroundTransparency"
         H_=1
         B_.BackgroundTransparency=H_
         B_=s_.value


         F_="Size"
         c_=environment.UDim2


         H_=c_.new
         W_=20
         X_=0
         P_=-30
         j_=1
         c_=H_(j_,P_,X_,W_)
         B_.Size=c_
         B_=s_.value


         F_="Position"
         c_=environment.UDim2


         j_="new"
         W_=34
         H_=c_.new
         X_=0
         j_=0
         P_=15
         c_=H_(j_,P_,X_,W_)
         B_.Position=c_
         B_=s_.value


         F_="Text"


         H_="made by h1xn"
         B_.Text=H_
         B_=s_.value


         F_="TextColor3"
         c_=environment.Color3


         H_=c_.fromRGB
         j_=220
         P_=220
         X_=220
         c_=H_(j_,P_,X_)
         B_.TextColor3=c_
         B_=s_.value


         F_="TextSize"
         H_=14
         B_.TextSize=H_
         B_=s_.value


         F_="Font"
         j_=environment.Enum


         c_=j_.Font


         H_=c_.SourceSans
         B_.Font=H_
         B_=s_.value


         P_="Enum"
         F_="TextXAlignment"
         j_=environment.Enum


         c_=j_.TextXAlignment


         H_=c_.Left
         B_.TextXAlignment=H_
         B_=s_.value


         F_="ZIndex"
         H_=61
         B_.ZIndex=H_
         B_=V.value
         H_=m_.value
         j_=environment.TweenInfo


         P_="new"
         bW="Enum"
         c_=j_.new
         P_=0.5
         n_=environment.Enum


         W_=n_.EasingStyle


         X_=W_.Quint
         bW=environment.Enum


         n_=bW.EasingDirection


         W_=n_.Out
         j_=c_(P_,X_,W_)


         P_="Position"
         W_=environment.UDim2


         X_=W_.new
         aW=1
         bW=-20
         n_=1
         tW=-20
         W_=X_(n_,bW,aW,tW)
         c_={[P_]=W_}
         F_=B_.Create
         F_=F_(B_,H_,j_,c_)
         B_="Play"
         c_="task"
         B_=F_.Play
         B_=B_(F_)
         H_=environment.task


         c_="delay"
         j_=makeClosure3(fn_tween_ui,{V,m_;K;w})
         B_=H_.delay
         c_=4
         H_=B_(c_,j_)


         B_=Z_.MouseButton1Click
         H_=B_.Connect
         c_=makeClosure2(fn_save_position,{D,K;w,m,m_;r_,s_,V})
         H_=H_(B_,c_)


         B_=J_.MouseButton1Click
         c_=makeClosure4(fn_set_visible,{u_,K,w})
         H_=B_.Connect
         H_=H_(B_,c_)
         H_=environment.task


         B_=H_.spawn
         c_=makeClosure1(fn_teleport_saved_position,{O_;D;K,w})
         H_=B_(c_)
         H_=environment.task


         B_=H_.spawn
         c_=makeClosure4(fn_auto_event_reward,{i_,K;w,D;y})
         H_=B_(c_)
         H_=S.value


         B_=H_.RenderStepped
         H_="Connect"
         c_=makeClosure3(fn_aim_worker,{A_;D;K,w,G,s,B,F})
         H_=B_.Connect
         H_=H_(B_,c_)
         H_=allocateCell()
         B_=false
         j_="Instance"
         H_.value=B_
         c_=environment.Instance


         B_=c_.new


         j_="Folder"
         c_=B_(j_)
         B_=allocateCell()
         B_.value=c_
         c_=B_.value


         j_="Name"


         P_="StoredMap"
         c_.Name=P_
         c_=B_.value


         j_="Parent"
         P_=i_.value
         c_.Parent=P_
         j_=D.value


         c_=j_.CharacterAdded
         P_=makeClosure6(fn_character_animation_setup,{c;x_,H_,U_,K;w,B_;m,s;B})
         j_=c_.Connect
         j_=j_(c_,P_)
         j_=environment.Instance


         c_=j_.new


         P_="Frame"
         j_=c_(P_)
         c_=allocateCell()
         c_.value=j_
         j_=c_.value


         P_="Parent"
         X_=i_.value
         j_.Parent=X_
         j_=c_.value


         P_="Size"
         W_=environment.UDim2


         aW=0
         n_="new"
         tW=80
         bW=115
         X_=W_.new
         n_=0
         W_=X_(n_,bW,aW,tW)
         j_.Size=W_
         j_=c_.value


         P_="Position"
         W_=environment.UDim2


         n_="new"
         tW=50
         X_=W_.new
         bW=215
         n_=0
         aW=0
         W_=X_(n_,bW,aW,tW)
         j_.Position=W_
         j_=c_.value


         P_="BackgroundColor3"
         W_=environment.Color3


         aW=28
         X_=W_.fromRGB
         bW=25
         n_=24
         W_=X_(n_,bW,aW)
         j_.BackgroundColor3=W_
         j_=c_.value


         P_="Visible"
         X_=false
         j_.Visible=X_
         j_=c_.value


         P_="Active"
         X_=true
         j_.Active=X_
         j_=c_.value


         P_="Draggable"
         X_=true
         j_.Draggable=X_
         P_=environment.Instance


         j_=P_.new


         X_="UICorner"
         P_=j_(X_)


         j_="CornerRadius"
         W_=environment.UDim


         n_="new"
         bW=3
         X_=W_.new
         n_=0
         W_=X_(n_,bW)
         P_.CornerRadius=W_

         j_="Parent"
         X_=c_.value
         W_="Instance"
         P_.Parent=X_
         X_=environment.Instance


         j_=X_.new


         W_="UIStroke"
         X_=j_(W_)


         j_="Color"
         n_=environment.Color3


         bW="fromRGB"
         tW=58
         aW=54
         W_=n_.fromRGB
         bW=52
         n_=W_(bW,aW,tW)
         X_.Color=n_

         j_="Thickness"
         W_=1
         X_.Thickness=W_

         n_="Instance"
         j_="Parent"
         W_=c_.value
         X_.Parent=W_
         W_=environment.Instance


         j_=W_.new


         n_="TextLabel"
         W_=j_(n_)


         j_="Parent"
         n_=c_.value
         W_.Parent=n_

         j_="Size"
         bW=environment.UDim2


         dW=0
         aW="new"
         tW=0
         n_=bW.new
         oW=20
         aW=1
         bW=n_(aW,tW,dW,oW)
         W_.Size=bW

         j_="BackgroundTransparency"
         n_=1
         W_.BackgroundTransparency=n_

         j_="Text"


         n_="TP ATTACK"
         W_.Text=n_

         j_="TextColor3"
         bW=environment.Color3


         aW="fromRGB"
         tW=255
         dW=255
         n_=bW.fromRGB
         aW=255
         bW=n_(aW,tW,dW)
         W_.TextColor3=bW

         tW="Enum"
         j_="Font"
         aW=environment.Enum


         bW=aW.Font


         n_=bW.GothamBold
         W_.Font=n_

         j_="TextSize"
         n_=9
         W_.TextSize=n_

         bW="Instance"
         j_="ZIndex"
         n_=52
         W_.ZIndex=n_
         n_=environment.Instance


         j_=n_.new


         bW="ScrollingFrame"
         n_=j_(bW)
         j_=allocateCell()
         j_.value=n_
         n_=j_.value


         bW="Parent"
         aW=c_.value
         n_.Parent=aW
         n_=j_.value


         bW="Size"
         tW=environment.UDim2


         xW=1
         aW=tW.new
         oW=-8
         dW=1
         IW=-25
         tW=aW(dW,oW,xW,IW)
         n_.Size=tW
         n_=j_.value


         bW="Position"
         tW=environment.UDim2


         dW="new"
         oW=4
         aW=tW.new
         IW=20
         dW=0
         xW=0
         tW=aW(dW,oW,xW,IW)
         n_.Position=tW
         n_=j_.value


         bW="BackgroundTransparency"
         aW=1
         n_.BackgroundTransparency=aW
         n_=j_.value


         bW="ScrollBarThickness"
         aW=2
         n_.ScrollBarThickness=aW
         n_=j_.value


         bW="ScrollBarImageColor3"
         tW=environment.Color3


         dW="fromRGB"
         xW=85
         oW=85
         aW=tW.fromRGB
         dW=85
         tW=aW(dW,oW,xW)
         n_.ScrollBarImageColor3=tW
         bW=environment.Instance


         n_=bW.new


         aW="UIListLayout"
         bW=n_(aW)
         n_=allocateCell()
         n_.value=bW
         bW=n_.value


         aW="Parent"
         tW=j_.value
         bW.Parent=tW
         bW=n_.value


         aW="Padding"
         dW=environment.UDim


         tW=dW.new
         xW=3
         oW=0
         dW=tW(oW,xW)
         bW.Padding=dW
         bW=n_.value
         aW="GetPropertyChangedSignal"


         aW=bW.GetPropertyChangedSignal
         tW="AbsoluteContentSize"
         aW=aW(bW,tW)
         bW=aW.Connect
         tW=makeClosure0(fn_resize_scroll_canvas_2,{j_;K,w,n_,c_})
         bW=bW(aW,tW)
         aW=y_.value


         bW=aW.MouseButton1Click
         tW=makeClosure0(fn_toggle_tp_attack,{c_;K,w,y_})
         aW=bW.Connect
         aW=aW(bW,tW)
         aW=environment.Instance


         bW=aW.new


         tW="Frame"
         aW=bW(tW)
         bW=allocateCell()
         bW.value=aW
         aW=bW.value


         tW="Parent"
         dW=i_.value
         aW.Parent=dW
         aW=bW.value


         tW="Size"
         oW=environment.UDim2


         dW=oW.new
         xW=0
         iW=0
         IW=115
         CW=80
         oW=dW(xW,IW,iW,CW)
         aW.Size=oW
         aW=bW.value


         tW="Position"
         oW=environment.UDim2


         xW="new"
         iW=0
         CW=165
         dW=oW.new
         IW=215
         xW=0
         oW=dW(xW,IW,iW,CW)
         aW.Position=oW
         aW=bW.value


         tW="BackgroundColor3"
         oW=environment.Color3


         dW=oW.fromRGB
         iW=28
         xW=24
         IW=25
         oW=dW(xW,IW,iW)
         aW.BackgroundColor3=oW
         aW=bW.value


         tW="Visible"
         dW=false
         aW.Visible=dW
         aW=bW.value


         tW="Active"
         dW=true
         aW.Active=dW
         aW=bW.value


         tW="Draggable"
         dW=true
         aW.Draggable=dW
         tW=environment.Instance


         aW=tW.new


         dW="UICorner"
         tW=aW(dW)


         aW="CornerRadius"
         oW=environment.UDim


         dW=oW.new
         xW=0
         IW=3
         oW=dW(xW,IW)
         tW.CornerRadius=oW

         aW="Parent"
         dW=bW.value
         oW="Instance"
         tW.Parent=dW
         dW=environment.Instance


         aW=dW.new


         oW="UIStroke"
         dW=aW(oW)


         aW="Color"
         xW=environment.Color3


         oW=xW.fromRGB
         CW=58
         IW=52
         iW=54
         xW=oW(IW,iW,CW)
         dW.Color=xW

         aW="Thickness"
         oW=1
         dW.Thickness=oW

         aW="Parent"
         xW="Instance"
         oW=bW.value
         dW.Parent=oW
         oW=environment.Instance


         aW=oW.new


         xW="TextLabel"
         oW=aW(xW)


         aW="Parent"
         xW=bW.value
         oW.Parent=xW

         aW="Size"
         IW=environment.UDim2


         iW="new"
         uW=20
         xW=IW.new
         CW=0
         iW=1
         LW=0
         IW=xW(iW,CW,LW,uW)
         oW.Size=IW

         aW="BackgroundTransparency"
         xW=1
         oW.BackgroundTransparency=xW

         aW="Text"


         xW="TP GRAB"
         oW.Text=xW

         aW="TextColor3"
         IW=environment.Color3


         xW=IW.fromRGB
         iW=255
         LW=255
         CW=255
         IW=xW(iW,CW,LW)
         oW.TextColor3=IW

         CW="Enum"
         aW="Font"
         iW=environment.Enum


         IW=iW.Font


         xW=IW.GothamBold
         oW.Font=xW

         aW="TextSize"
         xW=9
         oW.TextSize=xW

         aW="ZIndex"
         xW=52
         IW="Instance"
         oW.ZIndex=xW
         xW=environment.Instance


         aW=xW.new


         IW="ScrollingFrame"
         xW=aW(IW)
         aW=allocateCell()
         aW.value=xW
         xW=aW.value


         IW="Parent"
         iW=bW.value
         xW.Parent=iW
         xW=aW.value


         IW="Size"
         CW=environment.UDim2


         iW=CW.new
         uW=-8
         LW=1
         JW=1
         KW=-25
         CW=iW(LW,uW,JW,KW)
         xW.Size=CW
         xW=aW.value


         IW="Position"
         CW=environment.UDim2


         JW=0
         iW=CW.new
         KW=20
         uW=4
         LW=0
         CW=iW(LW,uW,JW,KW)
         xW.Position=CW
         xW=aW.value


         IW="BackgroundTransparency"
         iW=1
         xW.BackgroundTransparency=iW
         xW=aW.value


         IW="ScrollBarThickness"
         iW=2
         xW.ScrollBarThickness=iW
         xW=aW.value


         IW="ScrollBarImageColor3"
         CW=environment.Color3


         iW=CW.fromRGB
         uW=85
         JW=85
         LW=85
         CW=iW(LW,uW,JW)
         iW="Instance"
         xW.ScrollBarImageColor3=CW
         IW=environment.Instance


         xW=IW.new


         iW="UIListLayout"
         IW=xW(iW)
         xW=allocateCell()
         xW.value=IW
         IW=xW.value


         iW="Parent"
         CW=aW.value
         IW.Parent=CW
         IW=xW.value


         iW="Padding"
         LW=environment.UDim


         CW=LW.new
         uW=0
         JW=3
         LW=CW(uW,JW)
         IW.Padding=LW
         IW=xW.value


         CW="AbsoluteContentSize"
         iW=IW.GetPropertyChangedSignal
         iW=iW(IW,CW)
         scratch02="GetPlayers"
         IW="Connect"
         CW=makeClosure0(fn_resize_scroll_canvas_3,{aW,K;w;xW;bW})
         IW=iW.Connect
         IW=IW(iW,CW)
         iW=p_.value


         IW=iW.MouseButton1Click
         CW=makeClosure0(fn_toggle_tp_grab,{bW;K,w;p_})
         iW=IW.Connect
         iW=iW(IW,CW)
         iW=makeClosure3(fn_tp_grab_worker,{D,K,w;G,f,c;S;i_,P,d_})
         uW="pairs"
         IW=allocateCell()
         IW.value=iW
         iW=allocateCell()
         CW=makeClosure2(fn_all_players_worker,{D;K,w,G,f,c,S;i_;P;d_})
         iW.value=CW
         CW=makeClosure5(fn_create_player_button,{D,K,w,j_;I_;IW,aW,iW})
         LW=environment.pairs
         lW=Y.value
         scratch02=lW.GetPlayers
         scratch01={scratch02(lW)}
         lW={LW(unpackValues(scratch01))}
         KW=lW[3]
         uW=lW[1]
         JW=lW[2]

    end
    while true do
        KW,lW=uW(JW,KW)
        if not (KW) then
            break
        end
        scratch01=CW(lW)
    end
    uW=Y.value


    LW=uW.PlayerAdded
    uW=LW.Connect
    uW=uW(LW,CW)
    uW=Y.value


    LW=uW.PlayerRemoving
    uW=LW.Connect
    JW=makeClosure2(fn_remove_text_button,{j_,K;w;aW})
    uW=uW(LW,JW)
    uW=U_.value


    LW=uW.MouseButton1Click
    JW=makeClosure5(fn_create_removed_map_floor,{H_,U_,K;w,Y;B_})
    uW=LW.Connect
    uW=uW(LW,JW)
    uW=environment.Instance


    LW=uW.new


    JW="Frame"
    uW=LW(JW)
    LW=allocateCell()
    LW.value=uW
    uW=LW.value


    JW="Parent"
    KW=i_.value
    uW.Parent=KW
    uW=LW.value


    JW="Size"
    scratch01="UDim2"
    lW=environment.UDim2
    scratch01="new"
    scratch03=0
    KW=lW.new
    scratch01=0
    scratch02=115
    scratch04=80
    lW=KW(scratch01,scratch02,scratch03,scratch04)
    uW.Size=lW
    uW=LW.value


    JW="Position"
    scratch01="UDim2"
    lW=environment.UDim2
    scratch01="new"
    KW=lW.new
    scratch02=215
    scratch04=165
    scratch03=0
    scratch01=0
    lW=KW(scratch01,scratch02,scratch03,scratch04)
    uW.Position=lW
    uW=LW.value


    JW="BackgroundColor3"
    scratch01="Color3"
    lW=environment.Color3
    scratch01="fromRGB"
    scratch02=25
    KW=lW.fromRGB
    scratch03=28
    scratch01=24
    lW=KW(scratch01,scratch02,scratch03)
    uW.BackgroundColor3=lW
    uW=LW.value


    JW="Visible"
    KW=false
    uW.Visible=KW
    uW=LW.value


    JW="Active"
    KW=true
    uW.Active=KW
    uW=LW.value


    JW="Draggable"
    KW=true
    uW.Draggable=KW
    JW=environment.Instance

    uW=JW.new

    KW="UICorner"
    JW=uW(KW)


    uW="CornerRadius"
    scratch01="UDim"
    lW=environment.UDim
    scratch01="new"
    scratch02=3
    KW=lW.new
    scratch01=0
    lW=KW(scratch01,scratch02)
    JW.CornerRadius=lW

    lW="Instance"
    uW="Parent"
    KW=LW.value
    JW.Parent=KW
    KW=environment.Instance
    uW=KW.new
    lW="UIStroke"
    KW=uW(lW)

    uW="Color"
    scratch02="Color3"
    scratch01=environment.Color3
    scratch04=58
    scratch02="fromRGB"
    scratch03=54
    lW=scratch01.fromRGB
    scratch02=52
    scratch01=lW(scratch02,scratch03,scratch04)
    KW.Color=scratch01

    uW="Thickness"
    lW=1
    KW.Thickness=lW
    uW="Parent"
    lW=LW.value
    scratch01="Instance"
    KW.Parent=lW
    lW=environment.Instance
    scratch01="new"
    uW=lW.new
    scratch01="TextLabel"
    lW=uW(scratch01)
    uW="Parent"
    scratch01=LW.value
    lW.Parent=scratch01
    uW="Size"
    scratch03="UDim2"
    scratch02=environment.UDim2
    scratch03="new"
    scratch06=20
    scratch04=0
    scratch01=scratch02.new
    scratch03=1
    scratch05=0
    scratch02=scratch01(scratch03,scratch04,scratch05,scratch06)
    lW.Size=scratch02
    uW="BackgroundTransparency"
    scratch01=1
    lW.BackgroundTransparency=scratch01
    uW="Text"
    scratch01="ESP"
    lW.Text=scratch01
    uW="TextColor3"
    scratch03="Color3"
    scratch02=environment.Color3
    scratch03="fromRGB"
    scratch01=scratch02.fromRGB
    scratch05=255
    scratch04=255
    scratch03=255
    scratch02=scratch01(scratch03,scratch04,scratch05)
    lW.TextColor3=scratch02
    scratch04="Enum"
    uW="Font"
    scratch03=environment.Enum
    scratch04="Font"
    scratch02=scratch03.Font
    scratch03="GothamBold"
    scratch01=scratch02.GothamBold
    lW.Font=scratch01
    uW="TextSize"
    scratch01=9
    lW.TextSize=scratch01
    uW="ZIndex"
    scratch02="Instance"
    scratch01=52
    lW.ZIndex=scratch01
    scratch01=environment.Instance
    scratch02="new"
    uW=scratch01.new
    scratch02="ScrollingFrame"
    scratch01=uW(scratch02)
    uW=allocateCell()
    uW.value=scratch01
    scratch01=uW.value
    scratch02="Parent"
    scratch03=LW.value
    scratch01.Parent=scratch03
    scratch01=uW.value
    scratch02="Size"
    scratch05="UDim2"
    scratch04=environment.UDim2
    scratch05="new"
    scratch08=-25
    scratch07=1
    scratch03=scratch04.new
    scratch06=-8
    scratch05=1
    scratch04=scratch03(scratch05,scratch06,scratch07,scratch08)
    scratch01.Size=scratch04
    scratch01=uW.value
    scratch02="Position"
    scratch05="UDim2"
    scratch04=environment.UDim2
    scratch07=0
    scratch05="new"
    scratch08=20
    scratch03=scratch04.new
    scratch05=0
    scratch06=4
    scratch04=scratch03(scratch05,scratch06,scratch07,scratch08)
    scratch01.Position=scratch04
    scratch01=uW.value
    scratch02="BackgroundTransparency"
    scratch03=1
    scratch01.BackgroundTransparency=scratch03
    scratch01=uW.value
    scratch02="ScrollBarThickness"
    scratch03=2
    scratch01.ScrollBarThickness=scratch03
    scratch01=uW.value
    scratch02="ScrollBarImageColor3"
    scratch05="Color3"
    scratch04=environment.Color3
    scratch05="fromRGB"
    scratch07=85
    scratch03=scratch04.fromRGB
    scratch05=85
    scratch06=85
    scratch04=scratch03(scratch05,scratch06,scratch07)
    scratch03="Instance"
    scratch01.ScrollBarImageColor3=scratch04
    scratch02=environment.Instance
    scratch03="new"
    scratch01=scratch02.new
    scratch03="UIListLayout"
    scratch02=scratch01(scratch03)
    scratch01=allocateCell()
    scratch01.value=scratch02
    scratch02=scratch01.value
    scratch03="Parent"
    scratch04=uW.value
    scratch02.Parent=scratch04
    scratch02=scratch01.value
    scratch03="Padding"
    scratch06="UDim"
    scratch05=environment.UDim
    scratch06="new"
    scratch04=scratch05.new
    scratch07=3
    scratch06=0
    scratch05=scratch04(scratch06,scratch07)
    scratch02.Padding=scratch05
    scratch02=scratch01.value
    scratch03="SortOrder"
    scratch07="Enum"
    scratch06=environment.Enum
    scratch07="SortOrder"
    scratch05=scratch06.SortOrder
    scratch06="LayoutOrder"
    scratch04=scratch05.LayoutOrder
    scratch02.SortOrder=scratch04
    scratch03="GetPropertyChangedSignal"
    scratch02=scratch01.value
    scratch03=scratch02.GetPropertyChangedSignal
    scratch04="AbsoluteContentSize"
    scratch03=scratch03(scratch02,scratch04)
    scratch02="Connect"
    scratch04=makeClosure4(fn_resize_scroll_canvas_alt,{uW;K;w,scratch01,LW})
    scratch05=allocateCell()
    scratch02=scratch03.Connect
    scratch02=scratch02(scratch03,scratch04)
    scratch04=allocateCell()
    scratch03=allocateCell()
    scratch02={}
    scratch03.value=scratch02
    scratch02={}
    scratch04.value=scratch02
    scratch06=makeClosure5(fn_cleanup_esp,{scratch03;K;w})
    scratch02=false
    scratch05.value=scratch02
    scratch02=allocateCell()
    scratch07=makeClosure3(fn_on_character_added,{D;scratch04,scratch02;K,w,S,scratch03})
    scratch02.value=scratch06
    scratch06=allocateCell()
    scratch06.value=scratch07
    scratch07=M_.value
    scratch09="All Player : OFF"
    scratch10=uW.value
    scratch08=scratch07(scratch09,scratch10)
    scratch07=allocateCell()
    scratch07.value=scratch08
    scratch08=scratch07.value
    scratch09="LayoutOrder"
    scratch10=0
    scratch08.LayoutOrder=scratch10
    scratch08=scratch07.value
    scratch09="Size"
    scratch12="UDim2"
    scratch11=environment.UDim2
    scratch14=0
    scratch12="new"
    scratch15=18
    scratch10=scratch11.new
    scratch13=-4
    scratch12=1
    scratch11=scratch10(scratch12,scratch13,scratch14,scratch15)
    scratch08.Size=scratch11
    scratch08=scratch07.value
    scratch09="TextSize"
    scratch10=8
    scratch08.TextSize=scratch10
    scratch09=scratch07.value
    scratch10="MouseButton1Click"
    scratch08=scratch09.MouseButton1Click
    scratch10=makeClosure4(fn_toggle_all_players,{scratch05,scratch07;K,w,Y;D,scratch04,scratch06;scratch02,uW})
    scratch09="Connect"
    scratch09=scratch08.Connect
    scratch09=scratch09(scratch08,scratch10)
    scratch08=makeClosure3(fn_player_button_click,{D,M_,K,w,uW,scratch05,scratch04,scratch02;scratch06})
    scratch10="pairs"
    scratch09=environment.pairs
    scratch15="GetPlayers"
    scratch13=Y.value
    scratch15=scratch13.GetPlayers
    scratch14={scratch15(scratch13)}
    scratch13={scratch09(unpackValues(scratch14))}
    scratch12=scratch13[3]
    scratch11=scratch13[2]
    scratch10=scratch13[1]
    while true do
        scratch12,scratch13=scratch10(scratch11,scratch12)
        if not (scratch12) then
            break
        end
        scratch14=scratch08(scratch13)


    end
    scratch10=Y.value
    scratch11="PlayerAdded"
    scratch09=scratch10.PlayerAdded
    scratch10="Connect"
    scratch10=scratch09.Connect
    scratch10=scratch10(scratch09,scratch08)
    scratch10=Y.value
    scratch11="PlayerRemoving"
    scratch09=scratch10.PlayerRemoving
    scratch11=makeClosure1(fn_remove_player_button,{uW,K;w,scratch02})
    scratch10="Connect"
    scratch10=scratch09.Connect
    scratch10=scratch10(scratch09,scratch11)
    scratch10=h_.value
    scratch11="MouseButton1Click"
    scratch09=scratch10.MouseButton1Click
    scratch10="Connect"
    scratch10=scratch09.Connect
    scratch11=makeClosure3(fn_toggle_esp_ui,{LW,K;w;h_})
    scratch10=scratch10(scratch09,scratch11)
    scratch11="Instance"
    scratch10=environment.Instance
    scratch11="new"
    scratch09=scratch10.new
    scratch11="Frame"
    scratch10=scratch09(scratch11)
    scratch09=allocateCell()
    scratch09.value=scratch10
    scratch10=scratch09.value
    scratch11="Parent"
    scratch12=i_.value
    scratch10.Parent=scratch12
    scratch10=scratch09.value
    scratch11="Size"
    scratch14="UDim2"
    scratch13=environment.UDim2
    scratch14="new"
    scratch17=80
    scratch16=0
    scratch12=scratch13.new
    scratch15=115
    scratch14=0
    scratch13=scratch12(scratch14,scratch15,scratch16,scratch17)
    scratch10.Size=scratch13
    scratch10=scratch09.value
    scratch11="Position"
    scratch14="UDim2"
    scratch13=environment.UDim2
    scratch14="new"
    scratch15=-180
    scratch17=0
    scratch12=scratch13.new
    scratch14=1
    scratch16=0
    scratch13=scratch12(scratch14,scratch15,scratch16,scratch17)
    scratch10.Position=scratch13
    scratch10=scratch09.value
    scratch11="BackgroundColor3"
    scratch14="Color3"
    scratch13=environment.Color3
    scratch14="fromRGB"
    scratch15=25
    scratch12=scratch13.fromRGB
    scratch16=28
    scratch14=24
    scratch13=scratch12(scratch14,scratch15,scratch16)
    scratch10.BackgroundColor3=scratch13
    scratch10=scratch09.value
    scratch11="Active"
    scratch12=true
    scratch10.Active=scratch12
    scratch10=scratch09.value
    scratch11="Draggable"
    scratch12=true
    scratch10.Draggable=scratch12
    scratch10=scratch09.value
    scratch11="Visible"
    scratch12=false
    scratch10.Visible=scratch12
    scratch12="Instance"
    scratch11=environment.Instance
    scratch12="new"
    scratch10=scratch11.new
    scratch12="UICorner"
    scratch13=scratch09.value
    scratch11=scratch10(scratch12,scratch13)
    scratch10="CornerRadius"
    scratch14="UDim"
    scratch13=environment.UDim
    scratch14="new"
    scratch15=3
    scratch12=scratch13.new
    scratch14=0
    scratch13=scratch12(scratch14,scratch15)
    scratch11.CornerRadius=scratch13
    scratch13="Instance"
    scratch12=environment.Instance
    scratch13="new"
    scratch10=scratch12.new
    scratch13="UIStroke"
    scratch12=scratch10(scratch13)
    scratch10="Color"
    scratch15="Color3"
    scratch14=environment.Color3
    scratch15="fromRGB"
    scratch17=58
    scratch13=scratch14.fromRGB
    scratch15=52
    scratch16=54
    scratch14=scratch13(scratch15,scratch16,scratch17)
    scratch12.Color=scratch14
    scratch10="Thickness"
    scratch13=1
    scratch12.Thickness=scratch13
    scratch10="Parent"
    scratch13=scratch09.value
    scratch12.Parent=scratch13
    scratch14="Instance"
    scratch13=environment.Instance
    scratch14="new"
    scratch10=scratch13.new
    scratch14="TextLabel"
    scratch13=scratch10(scratch14)
    scratch10="Parent"
    scratch14=scratch09.value
    scratch13.Parent=scratch14
    scratch10="Size"
    scratch16="UDim2"
    scratch15=environment.UDim2
    scratch16="new"
    scratch17=0
    scratch19=20
    scratch14=scratch15.new
    scratch18=0
    scratch16=1
    scratch15=scratch14(scratch16,scratch17,scratch18,scratch19)
    scratch13.Size=scratch15
    scratch10="BackgroundTransparency"
    scratch14=1
    scratch13.BackgroundTransparency=scratch14
    scratch10="Text"
    scratch14="Fake Emote"
    scratch13.Text=scratch14
    scratch10="TextColor3"
    scratch16="Color3"
    scratch15=environment.Color3
    scratch16="new"
    scratch14=scratch15.new
    scratch17=1
    scratch18=1
    scratch16=1
    scratch15=scratch14(scratch16,scratch17,scratch18)
    scratch13.TextColor3=scratch15
    scratch17="Enum"
    scratch10="Font"
    scratch16=environment.Enum
    scratch17="Font"
    scratch15=scratch16.Font
    scratch16="GothamBold"
    scratch14=scratch15.GothamBold
    scratch13.Font=scratch14
    scratch10="TextSize"
    scratch14=10
    scratch13.TextSize=scratch14
    scratch10="ZIndex"
    scratch15="Instance"
    scratch14=52
    scratch13.ZIndex=scratch14
    scratch14=environment.Instance
    scratch15="new"
    scratch10=scratch14.new
    scratch15="ScrollingFrame"
    scratch14=scratch10(scratch15)
    scratch10=allocateCell()
    scratch10.value=scratch14
    scratch14=scratch10.value
    scratch15="Parent"
    scratch16=scratch09.value
    scratch14.Parent=scratch16
    scratch14=scratch10.value
    scratch15="Size"
    scratch18="UDim2"
    scratch17=environment.UDim2
    scratch18="new"
    scratch21=-25
    scratch16=scratch17.new
    scratch19=-8
    scratch18=1
    scratch20=1
    scratch17=scratch16(scratch18,scratch19,scratch20,scratch21)
    scratch14.Size=scratch17
    scratch14=scratch10.value
    scratch15="Position"
    scratch18="UDim2"
    scratch17=environment.UDim2
    scratch18="new"
    scratch19=4
    scratch16=scratch17.new
    scratch20=0
    scratch21=20
    scratch18=0
    scratch17=scratch16(scratch18,scratch19,scratch20,scratch21)
    scratch14.Position=scratch17
    scratch14=scratch10.value
    scratch15="BackgroundTransparency"
    scratch16=1
    scratch14.BackgroundTransparency=scratch16
    scratch14=scratch10.value
    scratch15="ScrollBarThickness"
    scratch16=2
    scratch14.ScrollBarThickness=scratch16
    scratch16="Instance"
    scratch15=environment.Instance
    scratch16="new"
    scratch14=scratch15.new
    scratch16="UIListLayout"
    scratch15=scratch14(scratch16)
    scratch14=allocateCell()
    scratch14.value=scratch15
    scratch15=scratch14.value
    scratch16="Parent"
    scratch17=scratch10.value
    scratch15.Parent=scratch17
    scratch15=scratch14.value
    scratch16="Padding"
    scratch19="UDim"
    scratch18=environment.UDim
    scratch19="new"
    scratch17=scratch18.new
    scratch20=3
    scratch19=0
    scratch18=scratch17(scratch19,scratch20)
    scratch15.Padding=scratch18
    scratch15=scratch14.value
    scratch16="GetPropertyChangedSignal"
    scratch16=scratch15.GetPropertyChangedSignal
    scratch17="AbsoluteContentSize"
    scratch16=scratch16(scratch15,scratch17)
    scratch15="Connect"
    scratch17=makeClosure1(fn_resize_scroll_canvas,{scratch10,K,w,scratch14;scratch09})
    scratch15=scratch16.Connect
    scratch15=scratch15(scratch16,scratch17)
    scratch16=N_.value
    scratch17="MouseButton1Click"
    scratch15=scratch16.MouseButton1Click
    scratch16="Connect"
    scratch17=makeClosure2(fn_toggle_fake_emote_ui,{scratch09;K,w,N_})
    scratch16=scratch15.Connect
    scratch16=scratch16(scratch15,scratch17)
    scratch15=allocateCell()
    scratch16=makeClosure2(fn_play_fake_emote,{D,K,w})
    scratch15.value=scratch16
    scratch17="ipairs"
    scratch16=environment.ipairs
    scratch20={scratch16(p)}
    scratch18=scratch20[2]
    scratch17=scratch20[1]
    scratch19=scratch20[3]
    while true do
        scratch19,scratch20=scratch17(scratch18,scratch19)
        if not (scratch19) then
            break
        end
        scratch21=allocateCell()
        scratch21.value=scratch20
        scratch20=scratch21
        scratch21=M_.value
        scratch24=scratch20.value
        scratch25="name"
        scratch23=scratch24.name
        scratch24=scratch10.value
        scratch22=scratch21(scratch23,scratch24)
        scratch23="MouseButton1Click"
        scratch21=scratch22.MouseButton1Click
        scratch24=makeClosure2(fn_event_animation_config,{scratch15,scratch20,K,w})
        scratch23="Connect"
        scratch23=scratch21.Connect
        scratch23=scratch23(scratch21,scratch24)
        scratch20=nil
    end
    scratch18="Instance"
    scratch17=environment.Instance
    scratch18="new"
    scratch16=scratch17.new
    scratch18="Frame"
    scratch17=scratch16(scratch18)
    scratch16=allocateCell()
    scratch16.value=scratch17
    scratch17=scratch16.value
    scratch18="Parent"
    scratch19=i_.value
    scratch17.Parent=scratch19
    scratch17=scratch16.value
    scratch18="Size"
    scratch21="UDim2"
    scratch20=environment.UDim2
    scratch23=0
    scratch21="new"
    scratch19=scratch20.new
    scratch21=0
    scratch22=115
    scratch24=80
    scratch20=scratch19(scratch21,scratch22,scratch23,scratch24)
    scratch17.Size=scratch20
    scratch17=scratch16.value
    scratch18="Position"
    scratch21="UDim2"
    scratch20=environment.UDim2
    scratch21="new"
    scratch19=scratch20.new
    scratch21=1
    scratch23=0
    scratch24=120
    scratch22=-180
    scratch20=scratch19(scratch21,scratch22,scratch23,scratch24)
    scratch17.Position=scratch20
    scratch17=scratch16.value
    scratch18="BackgroundColor3"
    scratch21="Color3"
    scratch20=environment.Color3
    scratch21="fromRGB"
    scratch19=scratch20.fromRGB
    scratch22=25
    scratch23=28
    scratch21=24
    scratch20=scratch19(scratch21,scratch22,scratch23)
    scratch17.BackgroundColor3=scratch20
    scratch17=scratch16.value
    scratch18="Visible"
    scratch19=false
    scratch17.Visible=scratch19
    scratch17=scratch16.value
    scratch18="Active"
    scratch19=true
    scratch17.Active=scratch19
    scratch17=scratch16.value
    scratch18="Draggable"
    scratch19=true
    scratch17.Draggable=scratch19
    scratch19="Instance"
    scratch18=environment.Instance
    scratch19="new"
    scratch17=scratch18.new
    scratch19="UICorner"
    scratch18=scratch17(scratch19)
    scratch17="CornerRadius"
    scratch21="UDim"
    scratch20=environment.UDim
    scratch21="new"
    scratch19=scratch20.new
    scratch22=3
    scratch21=0
    scratch20=scratch19(scratch21,scratch22)
    scratch18.CornerRadius=scratch20
    scratch17="Parent"
    scratch19=scratch16.value
    scratch18.Parent=scratch19
    scratch20="Instance"
    scratch19=environment.Instance
    scratch20="new"
    scratch17=scratch19.new
    scratch20="UIStroke"
    scratch19=scratch17(scratch20)
    scratch17="Color"
    scratch22="Color3"
    scratch21=environment.Color3
    scratch22="fromRGB"
    scratch23=54
    scratch20=scratch21.fromRGB
    scratch24=58
    scratch22=52
    scratch21=scratch20(scratch22,scratch23,scratch24)
    scratch19.Color=scratch21
    scratch17="Thickness"
    scratch20=1
    scratch19.Thickness=scratch20
    scratch17="Parent"
    scratch20=scratch16.value
    scratch21="Instance"
    scratch19.Parent=scratch20
    scratch20=environment.Instance
    scratch21="new"
    scratch17=scratch20.new
    scratch21="TextLabel"
    scratch20=scratch17(scratch21)
    scratch17="Parent"
    scratch21=scratch16.value
    scratch20.Parent=scratch21
    scratch17="Size"
    scratch23="UDim2"
    scratch22=environment.UDim2
    scratch23="new"
    scratch26=20
    scratch25=0
    scratch21=scratch22.new
    scratch24=0
    scratch23=1
    scratch22=scratch21(scratch23,scratch24,scratch25,scratch26)
    scratch20.Size=scratch22
    scratch17="BackgroundTransparency"
    scratch21=1
    scratch20.BackgroundTransparency=scratch21
    scratch17="Text"
    scratch21="Auto Event"
    scratch20.Text=scratch21
    scratch17="TextColor3"
    scratch23="Color3"
    scratch22=environment.Color3
    scratch23="new"
    scratch21=scratch22.new
    scratch23=1
    scratch24=1
    scratch25=1
    scratch22=scratch21(scratch23,scratch24,scratch25)
    scratch20.TextColor3=scratch22
    scratch24="Enum"
    scratch17="Font"
    scratch23=environment.Enum
    scratch24="Font"
    scratch22=scratch23.Font
    scratch23="GothamBold"
    scratch21=scratch22.GothamBold
    scratch20.Font=scratch21
    scratch17="TextSize"
    scratch21=9
    scratch20.TextSize=scratch21
    scratch22="Instance"
    scratch17="ZIndex"
    scratch21=52
    scratch20.ZIndex=scratch21
    scratch21=environment.Instance
    scratch22="new"
    scratch17=scratch21.new
    scratch22="ScrollingFrame"
    scratch21=scratch17(scratch22)
    scratch17=allocateCell()
    scratch17.value=scratch21
    scratch21=scratch17.value
    scratch22="Parent"
    scratch23=scratch16.value
    scratch21.Parent=scratch23
    scratch21=scratch17.value
    scratch22="Size"
    scratch25="UDim2"
    scratch24=environment.UDim2
    scratch25="new"
    scratch23=scratch24.new
    scratch26=-8
    scratch25=1
    scratch27=1
    scratch28=-25
    scratch24=scratch23(scratch25,scratch26,scratch27,scratch28)
    scratch21.Size=scratch24
    scratch21=scratch17.value
    scratch22="Position"
    scratch25="UDim2"
    scratch24=environment.UDim2
    scratch25="new"
    scratch28=20
    scratch23=scratch24.new
    scratch27=0
    scratch25=0
    scratch26=4
    scratch24=scratch23(scratch25,scratch26,scratch27,scratch28)
    scratch21.Position=scratch24
    scratch21=scratch17.value
    scratch22="BackgroundTransparency"
    scratch23=1
    scratch21.BackgroundTransparency=scratch23
    scratch21=scratch17.value
    scratch22="ScrollBarThickness"
    scratch23=2
    scratch21.ScrollBarThickness=scratch23
    scratch23="Instance"
    scratch22=environment.Instance
    scratch23="new"
    scratch21=scratch22.new
    scratch23="UIListLayout"
    scratch22=scratch21(scratch23)
    scratch21=allocateCell()
    scratch21.value=scratch22
    scratch22=scratch21.value
    scratch23="Parent"
    scratch24=scratch17.value
    scratch22.Parent=scratch24
    scratch22=scratch21.value
    scratch23="Padding"
    scratch26="UDim"
    scratch25=environment.UDim
    scratch26="new"
    scratch24=scratch25.new
    scratch26=0
    scratch27=3
    scratch25=scratch24(scratch26,scratch27)
    scratch22.Padding=scratch25
    scratch22=scratch21.value
    scratch23="GetPropertyChangedSignal"
    scratch24="AbsoluteContentSize"
    scratch23=scratch22.GetPropertyChangedSignal
    scratch23=scratch23(scratch22,scratch24)
    scratch22="Connect"
    scratch24=makeClosure5(fn_resize_scroll_canvas_4,{scratch17,K;w,scratch21,scratch16})
    scratch22=scratch23.Connect
    scratch22=scratch22(scratch23,scratch24)
    scratch23=k_.value
    scratch24="MouseButton1Click"
    scratch22=scratch23.MouseButton1Click
    scratch23="Connect"
    scratch23=scratch22.Connect
    scratch24=makeClosure1(fn_toggle_auto_event,{scratch16,K;w;k_})
    scratch23=scratch23(scratch22,scratch24)
    scratch23="ipairs"
    scratch22=environment.ipairs
    scratch26={scratch22(E)}
    scratch25=scratch26[3]
    scratch24=scratch26[2]
    scratch23=scratch26[1]
    while true do
        scratch25,scratch26=scratch23(scratch24,scratch25)
        if not (scratch25) then
            break
        end
        scratch27=allocateCell()
        scratch27.value=scratch26
        scratch26=scratch27
        scratch27=M_.value
        scratch30=scratch26.value
        scratch31=": OFF"
        scratch29=scratch30..scratch31
        scratch30=scratch17.value
        scratch28=scratch27(scratch29,scratch30)
        scratch27=allocateCell()
        scratch27.value=scratch28
        scratch28=scratch27.value
        scratch29="Size"
        scratch32="UDim2"
        scratch31=environment.UDim2
        scratch34=0
        scratch32="new"
        scratch33=-4
        scratch30=scratch31.new
        scratch35=18
        scratch32=1
        scratch31=scratch30(scratch32,scratch33,scratch34,scratch35)
        scratch28.Size=scratch31
        scratch28=scratch27.value
        scratch29="TextSize"
        scratch30=8
        scratch28.TextSize=scratch30
        scratch29=scratch27.value
        scratch30="MouseButton1Click"
        scratch28=scratch29.MouseButton1Click
        scratch30=makeClosure3(fn_update_toggle_display,{H,scratch26,scratch27;K;w})
        scratch27=nil
        scratch29="Connect"
        scratch29=scratch28.Connect
        scratch26=nil
        scratch29=scratch29(scratch28,scratch30)
    end
    t_=nil
    R_=nil
    G=nil
    S_=nil
    B=nil
    s_=nil
    m_=nil
    s=nil
    scratch16=nil
    scratch15=nil
    x_=nil
    H_=nil
    b_=nil
    scratch24="task"
    C={}
    E_=nil
    scratch23=environment.task
    scratch03=nil
    y=nil
    D=nil
    d_=nil
    T_=nil
    N_=nil
    Y=nil
    V=nil
    scratch01=nil
    scratch24="spawn"
    scratch06=nil
    r_=nil
    scratch22=scratch23.spawn
    scratch05=nil
    m=nil
    S=nil
    scratch24=makeClosure0(fn_protected_worker,{K;w;H,U})
    scratch23=scratch22(scratch24)
    scratch23=i_.value
    D_=nil
    IW=nil
    n_=nil
    j_=nil
    scratch21=nil
    v_=nil
    uW=nil
    z_=nil
    f=nil
    H=nil
    A_=nil
    U_=nil
    c=nil
    scratch14=nil
    scratch02=nil
    c_=nil
    scratch04=nil
    e_=nil
    iW=nil
    bW=nil
    F=nil
    scratch10=nil
    w_=nil
    k_=nil
    scratch24="Destroying"
    scratch22=scratch23.Destroying
    scratch23="Connect"
    scratch07=nil
    V_=nil
    aW=nil
    scratch23=scratch22.Connect
    I_=nil
    xW=nil
    X=nil
    w=nil
    u_=nil
    p_=nil
    scratch24=makeClosure4(fn_callback_no_strings_1,{o_})
    a_=nil
    i_=nil
    scratch09=nil
    K=nil
    h_=nil
    P=nil
    O_=nil
    o_=nil
    U=nil
    scratch23=scratch23(scratch22,scratch24)
    Y_=nil
    B_=nil
    scratch17=nil
    LW=nil
    M_=nil
    y_=nil
    result = C or {}
    do return unpackValues(result or {}) end


end

local __hn1_result = {makeClosureVarargs(fn_main, {})(...)}

-- =====================================================================
local GRABKILL_DEBUG = false
local function gkLog(...)
    if GRABKILL_DEBUG then
        print(...)
    end
end
local function gkWarn(...)
    if GRABKILL_DEBUG then
        warn(...)
    end
end

-- GRAB KILL LIMPO
-- Mantém somente o mecanismo servidor recuperado do killgrab.txt:
-- Player Grab -> 0.45s -> Ragdoll x3 -> unRagdoll x3.
--
-- SEM AdjustSpeed.
-- SEM Grab Assist.
-- SEM alteração em animações de Grab/Eat/Throw/blocos.
-- =====================================================================
environment.task.spawn(function()
    local gameObject = environment.game
    if not gameObject then
        return
    end

    local Players = gameObject:GetService("Players")
    local ReplicatedStorage = gameObject:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer

    if not LocalPlayer then
        return
    end

    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        or LocalPlayer:WaitForChild("PlayerGui", 10)

    if not PlayerGui then
        gkWarn("[GrabKill] PlayerGui não encontrado")
        return
    end

    local Gui = PlayerGui:FindFirstChild("BattleScriptGUI")
        or PlayerGui:WaitForChild("BattleScriptGUI", 10)

    if not Gui then
        gkWarn("[GrabKill] BattleScriptGUI não encontrado")
        return
    end

    local function findButton(prefix)
        for _, obj in ipairs(Gui:GetDescendants()) do
            if obj:IsA("TextButton")
                and type(obj.Text) == "string"
                and string.sub(obj.Text, 1, #prefix) == prefix then
                return obj
            end
        end
        return nil
    end

    local function findTPGrabPanel()
        for _, obj in ipairs(Gui:GetDescendants()) do
            if obj:IsA("TextLabel") and obj.Text == "TP GRAB" then
                return obj.Parent
            end
        end
        return nil
    end

    local TPGrabPanel = findTPGrabPanel()

    local GrabKillButton = findButton("Grab Kill")

    if not GrabKillButton then
        local template = findButton("TP Grab")
            or findButton("Aim Lock")
            or findButton("Only Eat")

        if not template then
            gkWarn("[GrabKill] botão modelo não encontrado")
            return
        end

        GrabKillButton = template:Clone()
        GrabKillButton.Name = "GrabKillButton"
        GrabKillButton.Text = "Grab Kill : OFF"
        GrabKillButton.LayoutOrder = (template.LayoutOrder or 0) + 1
        GrabKillButton.Parent = template.Parent
    else
        GrabKillButton.Text = "Grab Kill : OFF"
    end

    local enabled = false
    local hookedHumanoids = setmetatable({}, {__mode = "k"})
    local killSequenceBusy = false

    -- Grab Assist recuperado da versão que estava pegando com mais consistência.
    local grabAssistBusy = false
    local lastGrabConfirmedAt = 0

    local function updateButton()
        if not GrabKillButton or not GrabKillButton.Parent then
            return
        end

        if enabled then
            GrabKillButton.Text = "Grab Kill : ON"
            GrabKillButton.BackgroundColor3 = environment.Color3.fromRGB(32, 58, 32)
        else
            GrabKillButton.Text = "Grab Kill : OFF"
            GrabKillButton.BackgroundColor3 = environment.Color3.fromRGB(36, 38, 41)
        end
    end

    GrabKillButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        updateButton()
    end)

    updateButton()

    local NORMAL_GRAB_ANIMATION = "rbxassetid://16493266847"
    local PLAYER_GRAB_ANIMATION = "rbxassetid://16493304009"
    local GRAB_SUCCESS_TRIGGER_ANIMATION = "rbxassetid://16493275190"

    local function getGrabRemote()
        local events = ReplicatedStorage:FindFirstChild("Events")
        if not events then
            return nil
        end
        return events:FindFirstChild("Grab")
    end

    local function fireGrabRemote(grab)
        if not grab then
            return false
        end
        local ok = pcall(grab.FireServer, grab)
        return ok
    end

    -- Mesmo timing da versão em que o Grab ficou confiável:
    -- 1) deixa o Grab original tentar sozinho por 0.12 s;
    -- 2) se não confirmou, faz no máximo 2 reforços;
    -- 3) cada reforço tem 3 Grab com 0.025 s;
    -- 4) espera a confirmação antes de tentar novamente.
    local function pulseNormalGrab()
        -- TP Grab já dispara o Grab por conta própria.
        -- Se o painel TP GRAB estiver aberto, não mande reforço aqui,
        -- senão o personagem tenta agarrar duas vezes após o teleport.
        if TPGrabPanel and TPGrabPanel.Visible then
            gkLog("[GrabKill] TP Grab ativo -> reforço manual ignorado")
            return
        end

        if grabAssistBusy or not enabled then
            return
        end

        grabAssistBusy = true
        local attemptStarted = environment.tick()

        environment.task.spawn(function()
            environment.task.wait(0.12)

            if (TPGrabPanel and TPGrabPanel.Visible)
                or not enabled
                or lastGrabConfirmedAt >= attemptStarted then
                grabAssistBusy = false
                return
            end

            local grab = getGrabRemote()
            if not grab then
                gkWarn("[GrabKill] Events.Grab não encontrado")
                grabAssistBusy = false
                return
            end

            local confirmed = false

            for burst = 1, 2 do
                gkLog("[GrabKill] Grab não confirmou; reforço " .. tostring(burst) .. "/2")

                for _ = 1, 3 do
                    if (TPGrabPanel and TPGrabPanel.Visible)
                        or not enabled
                        or lastGrabConfirmedAt >= attemptStarted then
                        confirmed = true
                        break
                    end

                    fireGrabRemote(grab)
                    environment.task.wait(0.025)
                end

                if confirmed then
                    break
                end

                local deadline = environment.tick() + 0.14
                while environment.tick() < deadline do
                    if lastGrabConfirmedAt >= attemptStarted then
                        confirmed = true
                        break
                    end
                    environment.task.wait(0.01)
                end

                if confirmed then
                    break
                end

                if burst < 2 then
                    environment.task.wait(0.05)
                end
            end

            if confirmed then
                gkLog("[GrabKill] Grab confirmado")
            else
                gkLog("[GrabKill] Grab não confirmou nesta tentativa")
            end

            environment.task.wait(0.06)
            grabAssistBusy = false
        end)
    end

    local function executeKillSequence()
        if killSequenceBusy or not enabled then
            return
        end

        killSequenceBusy = true

        local events = ReplicatedStorage:FindFirstChild("Events")

        if not events then
            gkWarn("[GrabKill] ReplicatedStorage.Events não encontrado")
            killSequenceBusy = false
            return
        end

        local ragdoll = events:FindFirstChild("Ragdoll")
        local unRagdoll = events:FindFirstChild("unRagdoll")

        if not ragdoll or not unRagdoll then
            gkWarn(
                "[GrabKill] Ragdoll/unRagdoll ausente | Ragdoll="
                .. tostring(ragdoll ~= nil)
                .. " | unRagdoll="
                .. tostring(unRagdoll ~= nil)
            )
            killSequenceBusy = false
            return
        end

        -- Sequência recuperada do killgrab original.
        for _ = 1, 3 do
            pcall(function()
                ragdoll:FireServer()
            end)
        end

        for _ = 1, 3 do
            pcall(function()
                unRagdoll:FireServer()
            end)
        end

        gkLog("[GrabKill] kill enviado sem alterar animações")

        -- Evita duplicar a sequência pela mesma animação.
        environment.task.delay(0.20, function()
            killSequenceBusy = false
        end)
    end

    local function hookCharacter(character)
        if not character then
            return
        end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
            or character:WaitForChild("Humanoid", 5)

        if not humanoid or hookedHumanoids[humanoid] then
            return
        end

        hookedHumanoids[humanoid] = true

        humanoid.AnimationPlayed:Connect(function(track)
            if not enabled or not track then
                return
            end

            local animation = track.Animation
            local animationId = animation and animation.AnimationId

            -- Igual ao killgrab.txt que estava pegando melhor:
            -- tanto Grab normal quanto Player Grab podem iniciar/manter o
            -- assistente. Player Grab sozinho NAO confirma que o servidor
            -- realmente prendeu o alvo.
            if animationId == NORMAL_GRAB_ANIMATION
                or animationId == PLAYER_GRAB_ANIMATION then
                pulseNormalGrab()
            end

            -- A confirmação real usada pela versão confiável é este trigger.
            if animationId == GRAB_SUCCESS_TRIGGER_ANIMATION then
                lastGrabConfirmedAt = environment.tick()
                gkLog("[GrabKill] Grab confirmado pelo trigger 16493275190")
                return
            end

            if animationId ~= PLAYER_GRAB_ANIMATION then
                return
            end

            -- Mantém o Kill Grab que já está funcionando muito bem.
            -- Só não encerramos mais o Grab Assist prematuramente aqui.
            gkLog("[GrabKill] Player Grab detectado -> kill em 0.45s")

            environment.task.delay(0.45, function()
                if enabled then
                    executeKillSequence()
                end
            end)
        end)
    end

    hookCharacter(LocalPlayer.Character)

    LocalPlayer.CharacterAdded:Connect(function(character)
        killSequenceBusy = false
        grabAssistBusy = false
        lastGrabConfirmedAt = 0

        environment.task.defer(function()
            hookCharacter(character)
        end)
    end)

    environment.task.defer(function()
        local events = ReplicatedStorage:FindFirstChild("Events")
        if events then
            gkLog(
                "[GrabKill] Events OK | Ragdoll="
                .. tostring(events:FindFirstChild("Ragdoll") ~= nil)
                .. " | unRagdoll="
                .. tostring(events:FindFirstChild("unRagdoll") ~= nil)
            )
        else
            gkWarn("[GrabKill] ReplicatedStorage.Events AUSENTE")
        end
    end)
end)

return unpackValues(__hn1_result)

