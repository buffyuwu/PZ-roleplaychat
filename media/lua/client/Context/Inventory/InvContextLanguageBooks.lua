---@diagnostic disable: undefined-global

ISInventoryMenuElements = ISInventoryMenuElements or {};

function ISInventoryMenuElements.ContextLanguageBooks(context)
    local self = ISMenuElement.new();
    self.invMenu = ISContextManager.getInstance().getInventoryMenu();
    local player = getPlayer()
    local modData = player:getModData()
    local languages = { "Spanish", "Russian", "Ukrainian", "German", "French", "Mandarin", "Japanese", "ASL" }
    function self.init()
    end

    function self.createMenu( _item )
        if _item:getContainer() ~= self.invMenu.inventory then
            return;
        end
        if not string.contains(_item:getFullType(), "Language") then return end

        local itemType = _item:getFullType()
        print("Item type: "..itemType)
        for _, language in ipairs(languages) do
            print("Language: "..language)
            if string.match(itemType, language) then 
                print("Language MATCH: "..language)
                if modData['rpLanguage1'] ~= "Empty Slot" and modData['rpLanguage2'] ~= "Empty Slot" then
                    self.invMenu.context:addOption("Replace "..ISChat.instance.rpLanguage1.." with "..language, self.invMenu, self.LearnLanguage, _item, language, "1")
                    self.invMenu.context:addOption("Replace "..ISChat.instance.rpLanguage2.." with "..language, self.invMenu, self.LearnLanguage, _item, language, "2")
                    return
                end
                self.invMenu.context:addOption("Learn "..language, self.invMenu, self.LearnLanguage, _item, language)
                break
            end
        end
        if itemType == "Language.ResetBook" then
            self.invMenu.context:addOption("Reset All Languages", self.invMenu, self.ResetLanguages, _item)
            self.invMenu.context:addOption("Forget "..ISChat.instance.rpLanguage1, self.invMenu, self.ResetLanguages, _item, "1")
            self.invMenu.context:addOption("Forget "..ISChat.instance.rpLanguage2, self.invMenu, self.ResetLanguages, _item, "2")
            return
        end
    end

    --languages
    function self.ResetLanguages(_p, _item, value)
        local playerModData = getPlayer():getModData()
        -- if playerModData['rpLanguage1'] == "Empty Slot" and playerModData['rpLanguage2'] == "Empty Slot" then
        --     getPlayer():addLineChatElement("You don't know any additional languages!", 1, 0, 0);
        --     getSpecificPlayer(0):getInventory():Remove(_item)
        --     return
        -- end
        getPlayer():addLineChatElement("You feel as though you have forgotten something important...", 1, 0, 0);
        if value and value == "1" then
            playerModData['rpLanguage1'] = "Empty Slot"
            ISChat.instance.rpLanguage = "Empty Slot"
            ISChat.instance.rpLanguage1 = "Empty Slot"
            return
        elseif value and value == "2" then
            playerModData['rpLanguage2'] = "Empty Slot"
            ISChat.instance.rpLanguage = "Empty Slot"
            ISChat.instance.rpLanguage2 = "Empty Slot"
            return
        end
        playerModData['rpLanguage1'] = "Empty Slot"
        playerModData['rpLanguage2'] = "Empty Slot"
        ISChat.rpLanguage = "Empty Slot"
        ISChat.instance.rpLanguage = "Empty Slot"
        ISChat.rpLanguage1 = "Empty Slot"
        ISChat.instance.rpLanguage1 = "Empty Slot"
        ISChat.rpLanguage2 = "Empty Slot"
        ISChat.instance.rpLanguage2 = "Empty Slot"
        print("languages soft reset")
    end

    function self.LearnLanguage(_p, _item, language, value)
        if getPlayer():getModData()['rpLanguage1'] == nil then getPlayer():getModData()['rpLanguage1'] = "Empty Slot"; end
        if getPlayer():getModData()['rpLanguage2'] == nil then getPlayer():getModData()['rpLanguage2'] = "Empty Slot"; end
        print("rpchat debug: language slot 1 = "..getPlayer():getModData()['rpLanguage1'])
        print("rpchat debug: language slot 2 = "..getPlayer():getModData()['rpLanguage2'])
        print("rpchat debug: active language = "..ISChat.instance.rpLanguage)
        -- if getPlayer():getModData()['rpLanguage1'] == "["..language.."]" or modData['rpLanguage2'] == "["..language.."]" then
        --     getPlayer():addLineChatElement("You already know "..language.."!", 1, 0, 0);
        --     return
        -- end
        getPlayer():addLineChatElement("Access your new language from the Cog wheel in the chat box.", 1, 0, 0);
        getSpecificPlayer(0):getInventory():Remove(_item)

        if value == "1" then
            getPlayer():getModData()['rpLanguage1'] = "["..language.."]"
            ISChat.instance.rpLanguage1 = "["..language.."]"
            ISChat.instance.rpLanguage = "Empty Slot"
            print("learning language on slot 1...")
            print("rpchat debug: language slot 1 = "..getPlayer():getModData()['rpLanguage1']);
            print("rpchat debug: language slot 2 = "..getPlayer():getModData()['rpLanguage2']);
            print("rpchat debug: active language = "..ISChat.instance.rpLanguage);
            return
        elseif value == "2" then
            getPlayer():getModData()['rpLanguage2'] = "["..language.."]"
            ISChat.instance.rpLanguage2 = "["..language.."]"
            print("learning language on slot 2...")
            print("rpchat debug: language slot 1 = "..getPlayer():getModData()['rpLanguage1'])
            print("rpchat debug: language slot 2 = "..getPlayer():getModData()['rpLanguage2'])
            print("rpchat debug: active language = "..ISChat.instance.rpLanguage)
            return
        end

        if getPlayer():getModData()['rpLanguage1'] == "Empty Slot" then
            getPlayer():getModData()['rpLanguage1'] = "["..language.."]"
            ISChat.instance.rpLanguage1 = "["..language.."]"
            print("learning language on slot 1 by default...")
            print("rpchat debug: language slot 1 = "..getPlayer():getModData()['rpLanguage1'])
            print("rpchat debug: language slot 2 = "..getPlayer():getModData()['rpLanguage2'])
            print("rpchat debug: active language = "..ISChat.instance.rpLanguage)
            return
        elseif getPlayer():getModData()['rpLanguage2'] == "Empty Slot" then
            getPlayer():getModData()['rpLanguage2'] = "["..language.."]"
            ISChat.instance.rpLanguage2 = "["..language.."]"
            print("learning language on slot 2 by default...")
            print("rpchat debug: language slot 1 = "..getPlayer():getModData()['rpLanguage1'])
            print("rpchat debug: language slot 2 = "..getPlayer():getModData()['rpLanguage2'])
            print("rpchat debug: active language = "..ISChat.instance.rpLanguage)
            return
        else
            --something went wrong...
            print("rpchat debug: language slot 1 = "..getPlayer():getModData()['rpLanguage1'])
            print("rpchat debug: language slot 2 = "..getPlayer():getModData()['rpLanguage2'])
            print("rpchat debug: active language = "..ISChat.instance.rpLanguage)
            getPlayer():getModData()['rpLanguage1'] = "["..language.."]"
            ISChat.instance.rpLanguage1 = "["..language.."]"
            print("rpchat debug: no language was available. overwriting...")
            return
        end
    end
    Events.OnPlayerDeath.Add(self.ResetLanguages)
    return self;
end
