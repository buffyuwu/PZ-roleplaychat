
ISInventoryMenuElements = ISInventoryMenuElements or {};

function ISInventoryMenuElements.ContextLanguageBooks(context)
    local self 					= ISMenuElement.new();
    self.invMenu			    = ISContextManager.getInstance().getInventoryMenu();
    local player = getPlayer()
    local modData = player:getModData()
    function self.init()
    end

    function self.createMenu( _item )
        if _item:getContainer() ~= self.invMenu.inventory then
            return;
        end
        if not string.contains(_item:getFullType(), "Language") then return end

        if _item:getFullType() == "Language.SpanishBook" then
            if modData['rpLanguage1'] ~= "Empty Slot" and modData['rpLanguage2'] ~= "Empty Slot" then
                self.invMenu.context:addOption("Replace "..ISChat.instance.rpLanguage1.." with Spanish", self.invMenu, self.LearnSpanish, _item, "1")
                self.invMenu.context:addOption("Replace "..ISChat.instance.rpLanguage2.." with Spanish", self.invMenu, self.LearnSpanish, _item, "2")
                return
            end
            self.invMenu.context:addOption("Learn Spanish", self.invMenu, self.LearnSpanish, _item)

        elseif _item:getFullType() == "Language.RussianBook" then
            if modData['rpLanguage1'] ~= "Empty Slot" and modData['rpLanguage2'] ~= "Empty Slot" then
                self.invMenu.context:addOption("Replace "..ISChat.instance.rpLanguage1.." with Russian", self.invMenu, self.LearnRussian, _item, "1")
                self.invMenu.context:addOption("Replace "..ISChat.instance.rpLanguage2.." with Russian", self.invMenu, self.LearnRussian, _item, "2")
                return
            end
            self.invMenu.context:addOption("Learn Russian", self.invMenu, self.LearnRussian, _item)
        elseif _item:getFullType() == "Language.UkrainianBook" then
            if modData['rpLanguage1'] ~= "Empty Slot" and modData['rpLanguage2'] ~= "Empty Slot" then
                self.invMenu.context:addOption("Replace "..ISChat.instance.rpLanguage1.." with Ukrainian", self.invMenu, self.LearnUkrainian, _item, "1")
                self.invMenu.context:addOption("Replace "..ISChat.instance.rpLanguage2.." with Ukrainian", self.invMenu, self.LearnUkrainian, _item, "2")
                return
            end
            self.invMenu.context:addOption("Learn Ukrainian", self.invMenu, self.LearnUkrainian, _item)

        elseif _item:getFullType() == "Language.GermanBook" then
            if modData['rpLanguage1'] ~= "Empty Slot" and modData['rpLanguage2'] ~= "Empty Slot" then
                self.invMenu.context:addOption("Replace "..ISChat.instance.rpLanguage1.." with German", self.invMenu, self.LearnGerman, _item, "1")
                self.invMenu.context:addOption("Replace "..ISChat.instance.rpLanguage2.." with German", self.invMenu, self.LearnGerman, _item, "2")
                return
            end
            self.invMenu.context:addOption("Learn German", self.invMenu, self.LearnGerman, _item)

        elseif _item:getFullType() == "Language.MandarinBook" then
            if modData['rpLanguage1'] ~= "Empty Slot" and modData['rpLanguage2'] ~= "Empty Slot" then
                self.invMenu.context:addOption("Replace "..ISChat.instance.rpLanguage1.." with Mandarin", self.invMenu, self.LearnMandarin, _item, "1")
                self.invMenu.context:addOption("Replace "..ISChat.instance.rpLanguage2.." with Mandarin", self.invMenu, self.LearnMandarin, _item, "2")
                return
            end
            self.invMenu.context:addOption("Learn Mandarin", self.invMenu, self.LearnMandarin, _item)

        elseif _item:getFullType() == "Language.JapaneseBook" then
            if modData['rpLanguage1'] ~= "Empty Slot" and modData['rpLanguage2'] ~= "Empty Slot" then
                self.invMenu.context:addOption("Replace "..ISChat.instance.rpLanguage1.." with Japanese", self.invMenu, self.LearnJapanese, _item, "1")
                self.invMenu.context:addOption("Replace "..ISChat.instance.rpLanguage2.." with Japanese", self.invMenu, self.LearnJapanese, _item, "2")
                return
            end
            self.invMenu.context:addOption("Learn Japanese", self.invMenu, self.LearnJapanese, _item)

        elseif _item:getFullType() == "Language.ASLBook" then
            if modData['rpLanguage1'] ~= "Empty Slot" and modData['rpLanguage2'] ~= "Empty Slot" then
                self.invMenu.context:addOption("Replace "..ISChat.instance.rpLanguage1.." with American Sign Language", self.invMenu, self.LearnASL, _item, "1")
                self.invMenu.context:addOption("Replace "..ISChat.instance.rpLanguage2.." with American Sign Language", self.invMenu, self.LearnASL, _item, "2")
                return
            end
            self.invMenu.context:addOption("Learn Sign Language", self.invMenu, self.LearnASL, _item)
        elseif _item:getFullType() == "Language.ResetBook" then
            self.invMenu.context:addOption("Forget All Languages", self.invMenu, self.ResetLanguages, _item)
            self.invMenu.context:addOption("Forget "..ISChat.instance.rpLanguage1, self.invMenu, self.ResetLanguages, _item, "1")
            self.invMenu.context:addOption("Forget "..ISChat.instance.rpLanguage2, self.invMenu, self.ResetLanguages, _item, "2")
            return
        end
    end

    --languages
    function self.ResetLanguages(_p, _item, value)
        if modData['rpLanguage1'] == "Empty Slot" and modData['rpLanguage2'] == "Empty Slot" then
            getPlayer():addLineChatElement("You don't know any additional languages!", 1, 0, 0);
            getSpecificPlayer(0):getInventory():Remove(_item)
            return
        end
        getPlayer():addLineChatElement("You feel as though you have forgotten something important...", 1, 0, 0);
        if value and value == "1" then
            modData['rpLanguage1'] = "Empty Slot"
            ISChat.instance.rpLanguage = "Empty Slot"
            ISChat.instance.rpLanguage1 = "Empty Slot"
            return
        elseif value and value == "2" then
            modData['rpLanguage2'] = "Empty Slot"
            ISChat.instance.rpLanguage = "Empty Slot"
            ISChat.instance.rpLanguage2 = "Empty Slot"
            return
        end

        ISChat.instance.rpLanguage = "Empty Slot"
        modData['rpLanguage1'] = "Empty Slot"
        ISChat.instance.rpLanguage1 = "Empty Slot"
        modData['rpLanguage2'] = "Empty Slot"
        ISChat.instance.rpLanguage2 = "Empty Slot"
    end
    function self.LearnSpanish(_p, _item, value)

        if modData['rpLanguage1'] == "[Spanish]" or modData['rpLanguage2'] == "[Spanish]" then
            getPlayer():addLineChatElement("You already know Spanish!", 1, 0, 0);
            return
        end
        getPlayer():addLineChatElement("Access your new language from the Cog wheel in the chat box.", 1, 0, 0);
        getSpecificPlayer(0):getInventory():Remove(_item)

        if value and value == "1" then
            modData['rpLanguage1'] = "[Spanish]"
            ISChat.instance.rpLanguage1 = "[Spanish]"
            ISChat.instance.rpLanguage = "Empty Slot"
            return
        elseif value and value == "2" then
            modData['rpLanguage2'] = "[Spanish]"
            ISChat.instance.rpLanguage2 = "[Spanish]"
            return
        end

        if modData['rpLanguage1'] == nil or modData['rpLanguage1'] == "Empty Slot" then
            modData['rpLanguage1'] = "[Spanish]"
            ISChat.instance.rpLanguage1 = "[Spanish]"
            return
        elseif modData['rpLanguage2'] == nil or modData['rpLanguage2'] == "Empty Slot" then
            modData['rpLanguage2'] = "[Spanish]"
            ISChat.instance.rpLanguage2 = "[Spanish]"
            return
        end
    end
    function self.LearnRussian(_p, _item, value)

        if modData['rpLanguage1'] == "[Russian]" or modData['rpLanguage2'] == "[Russian]" then
            getPlayer():addLineChatElement("You already know Russian!", 1, 0, 0);
            return
        end
        getPlayer():addLineChatElement("Access your new language from the Cog wheel in the chat box.", 1, 0, 0);
        getSpecificPlayer(0):getInventory():Remove(_item)

        if value and value == "1" then
            modData['rpLanguage1'] = "[Russian]"
            ISChat.instance.rpLanguage = "Empty Slot"
            ISChat.instance.rpLanguage1 = "[Russian]"
            return
        elseif value and value == "2" then
            modData['rpLanguage2'] = "[Russian]"
            ISChat.instance.rpLanguage = "Empty Slot"
            ISChat.instance.rpLanguage2 = "[Russian]"
            return
        end

        if modData['rpLanguage1'] == nil or modData['rpLanguage1'] == "Empty Slot" then
            modData['rpLanguage1'] = "[Russian]"
            ISChat.instance.rpLanguage1 = "[Russian]"
            return
        elseif modData['rpLanguage2'] == nil or modData['rpLanguage2'] == "Empty Slot" then
            modData['rpLanguage2'] = "[Russian]"
            ISChat.instance.rpLanguage2 = "[Russian]"
            return
        end
    end
    function self.LearnUkrainian(_p, _item, value)

        if modData['rpLanguage1'] == "[Ukrainian]" or modData['rpLanguage2'] == "[Ukrainian]" then
            getPlayer():addLineChatElement("You already know Ukrainian!", 1, 0, 0);
            return
        end
        getPlayer():addLineChatElement("Access your new language from the Cog wheel in the chat box.", 1, 0, 0);
        getSpecificPlayer(0):getInventory():Remove(_item)

        if value and value == "1" then
            modData['rpLanguage1'] = "[Ukrainian]"
            ISChat.instance.rpLanguage = "Empty Slot"
            ISChat.instance.rpLanguage1 = "[Ukrainian]"
            return
        elseif value and value == "2" then
            modData['rpLanguage2'] = "[Ukrainian]"
            ISChat.instance.rpLanguage = "Empty Slot"
            ISChat.instance.rpLanguage2 = "[Ukrainian]"
            return
        end

        if modData['rpLanguage1'] == nil or modData['rpLanguage1'] == "Empty Slot" then
            modData['rpLanguage1'] = "[Ukrainian]"
            ISChat.instance.rpLanguage1 = "[Ukrainian]"
            return
        elseif modData['rpLanguage2'] == nil or modData['rpLanguage2'] == "Empty Slot" then
            modData['rpLanguage2'] = "[Ukrainian]"
            ISChat.instance.rpLanguage2 = "[Ukrainian]"
            return
        end
    end
    function self.LearnGerman(_p, _item, value)

        if modData['rpLanguage1'] == "[German]" or modData['rpLanguage2'] == "[German]" then
            getPlayer():addLineChatElement("You already know German!", 1, 0, 0);
            return
        end
        getPlayer():addLineChatElement("Access your new language from the Cog wheel in the chat box.", 1, 0, 0);
        getSpecificPlayer(0):getInventory():Remove(_item)

        if value and value == "1" then
            modData['rpLanguage1'] = "[German]"
            ISChat.instance.rpLanguage = "Empty Slot"
            ISChat.instance.rpLanguage1 = "[German]"
            return
        elseif value and value == "2" then
            modData['rpLanguage2'] = "[German]"
            ISChat.instance.rpLanguage = "Empty Slot"
            ISChat.instance.rpLanguage2 = "[German]"
            return
        end

        if modData['rpLanguage1'] == nil or modData['rpLanguage1'] == "Empty Slot" then
            modData['rpLanguage1'] = "[German]"
            ISChat.instance.rpLanguage1 = "[German]"
            return
        elseif modData['rpLanguage2'] == nil or modData['rpLanguage2'] == "Empty Slot" then
            modData['rpLanguage2'] = "[German]"
            ISChat.instance.rpLanguage2 = "[German]"
            return
        end
    end
    function self.LearnMandarin(_p, _item, value)

        if modData['rpLanguage1'] == "[Mandarin]" or modData['rpLanguage2'] == "[Mandarin]" then
            getPlayer():addLineChatElement("You already know Mandarin!", 1, 0, 0);
            return
        end
        getPlayer():addLineChatElement("Access your new language from the Cog wheel in the chat box.", 1, 0, 0);
        getSpecificPlayer(0):getInventory():Remove(_item)

        if value and value == "1" then
            modData['rpLanguage1'] = "[Mandarin]"
            ISChat.instance.rpLanguage = "Empty Slot"
            ISChat.instance.rpLanguage1 = "[Mandarin]"
            return
        elseif value and value == "2" then
            modData['rpLanguage2'] = "[Mandarin]"
            ISChat.instance.rpLanguage = "Empty Slot"
            ISChat.instance.rpLanguage2 = "[Mandarin]"
            return
        end

        if modData['rpLanguage1'] == nil or modData['rpLanguage1'] == "Empty Slot" then
            modData['rpLanguage1'] = "[Mandarin]"
            ISChat.instance.rpLanguage1 = "[Mandarin]"
            return
        elseif modData['rpLanguage2'] == nil or modData['rpLanguage2'] == "Empty Slot" then
            modData['rpLanguage2'] = "[Mandarin]"
            ISChat.instance.rpLanguage2 = "[Mandarin]"
            return
        end
    end
    function self.LearnJapanese(_p, _item, value)

        if modData['rpLanguage1'] == "[Japanese]" or modData['rpLanguage2'] == "[Japanese]" then
            getPlayer():addLineChatElement("You already know Japanese!", 1, 0, 0);
            return
        end
        getPlayer():addLineChatElement("Access your new language from the Cog wheel in the chat box.", 1, 0, 0);
        getSpecificPlayer(0):getInventory():Remove(_item)

        if value and value == "1" then
            modData['rpLanguage1'] = "[Japanese]"
            ISChat.instance.rpLanguage = "Empty Slot"
            ISChat.instance.rpLanguage1 = "[Japanese]"
            return
        elseif value and value == "2" then
            modData['rpLanguage2'] = "[Japanese]"
            ISChat.instance.rpLanguage = "Empty Slot"
            ISChat.instance.rpLanguage2 = "[Japanese]"
            return
        end

        if modData['rpLanguage1'] == nil or modData['rpLanguage1'] == "Empty Slot" then
            modData['rpLanguage1'] = "[Japanese]"
            ISChat.instance.rpLanguage1 = "[Japanese]"
            return
        elseif modData['rpLanguage2'] == nil or modData['rpLanguage2'] == "Empty Slot" then
            modData['rpLanguage2'] = "[Japanese]"
            ISChat.instance.rpLanguage2 = "[Japanese]"
            return
        end
    end
    function self.LearnASL(_p, _item, value)

        if modData['rpLanguage1'] == "[ASL]" or modData['rpLanguage2'] == "[ASL]" then
            getPlayer():addLineChatElement("You already know Sign Language!", 1, 0, 0);
            return
        end
        getPlayer():addLineChatElement("Access your new language from the Cog wheel in the chat box.", 1, 0, 0);
        getSpecificPlayer(0):getInventory():Remove(_item)

        if value and value == "1" then
            modData['rpLanguage1'] = "[ASL]"
            ISChat.instance.rpLanguage = "Empty Slot"
            ISChat.instance.rpLanguage1 = "[ASL]"
            return
        elseif value and value == "2" then
            modData['rpLanguage2'] = "[ASL]"
            ISChat.instance.rpLanguage = "Empty Slot"
            ISChat.instance.rpLanguage2 = "[ASL]"
            return
        end

        if modData['rpLanguage1'] == nil or modData['rpLanguage1'] == "Empty Slot" then
            modData['rpLanguage1'] = "[ASL]"
            ISChat.instance.rpLanguage1 = "[ASL]"
            return
        elseif modData['rpLanguage2'] == nil or modData['rpLanguage2'] == "Empty Slot" then
            modData['rpLanguage2'] = "[ASL]"
            ISChat.instance.rpLanguage2 = "[ASL]"
            return
        end
    end

    return self;
end

