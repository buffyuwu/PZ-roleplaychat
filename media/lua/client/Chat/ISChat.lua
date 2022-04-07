---@diagnostic disable: undefined-global, lowercase-global, deprecated

require "ISUI/ISCollapsableWindow"
require "ISUI/ISRichTextPanel"
require "ISUI/ISButton"
require "ISUI/ISTabPanel"

ISChat = ISCollapsableWindow:derive("ISChat");
ISChat.maxLine = 50;
ISChat.focused = false;
ISChat.allChatStreams = {}
ISChat.allChatStreams[1] = {name = "say", command = "/say ", shortCommand = "/s ", tabID = 1};
ISChat.allChatStreams[2] = {name = "yell", command = "/yell ", shortCommand = "/shout ", tabID = 1};
ISChat.allChatStreams[3] = {name = "whisper", command = "/whisper ", shortCommand = "/w ", tabID = 1};
ISChat.allChatStreams[4] = {name = "whisperme", command = "/whisperme ", shortCommand = "/wme ", tabID = 1};
ISChat.allChatStreams[5] = {name = "pm", command = "/pm ", shortCommand = "/pm ", tabID = 1};
ISChat.allChatStreams[6] = {name = "faction", command = "/faction ", shortCommand = "/f ", tabID = 1};
ISChat.allChatStreams[7] = {name = "safehouse", command = "/safehouse ", shortCommand = "/sh ", tabID = 1};
ISChat.allChatStreams[8] = {name = "general", command = "/all ", shortCommand = "// ", "/ooc ", tabID = 1};
ISChat.allChatStreams[9] = {name = "admin", command = "/admin ", shortCommand = "/a ", tabID = 2};
ISChat.allChatStreams[10] = {name = "me", command = "/me ", shortCommand = "/m ", "/emote ", tabID = 1};
ISChat.allChatStreams[11] = {name = "do", command = "/do ", shortCommand = "/d ", tabID = 1};
ISChat.allChatStreams[12] = {name = "name", command = "/name ", shortCommand = "/act ", tabID = 1};
ISChat.allChatStreams[13] = {name = "looc", command = "/looc ", shortCommand = "/l ", tabID = 1};
ISChat.allChatStreams[14] = {name = "levent", command = "/levent ", shortCommand = "/lev ", tabID = 1};
--ISChat.allChatStreams[15] = {name = "globalradio", command = "/common ", shortCommand = "/common ", tabID = 3};
ISChat.defaultTabStream = {}
ISChat.defaultTabStream[1] = ISChat.allChatStreams[1];
ISChat.defaultTabStream[2] = ISChat.allChatStreams[9];
--ISChat.defaultTabStream[3] = ISChat.allChatStreams[15];
-- default min and max opaque values
ISChat.minControlOpaque = 0.5; -- a value
ISChat.minGeneralOpaque = 0.0; -- a value, not percentage
ISChat.maxGeneralOpaque = 1.0; -- a value, not percentage
ISChat.minTextEntryOpaque = 0.3;
ISChat.maxTextEntryOpaque = 1.0;
ISChat.minTextOpaque = 0.8;
-- elements name
ISChat.textEntryName = "chat text entry"
ISChat.tabPanelName = "chat tab panel"
ISChat.yResizeWidgetName = "chat bottom y resize widget"
ISChat.xyResizeWidgetName = "chat xy resize widget"
ISChat.closeButtonName = "chat close button"
ISChat.lockButtonName = "chat lock button"
ISChat.gearButtonName = "chat gear button"
ISChat.textPanelName = "chat text element"
ISChat.windowName = "chat window"
ISChat.languages = { "Empty Slot", "Spanish", "Russian", "Ukrainian", "German", "Mandarin", "Japanese", "ASL" }
-- start roleplaychat settings
ISChat.rpName = "Unknown"
ISChat.rpColor = "" --player names in chat
ISChat.rpColorR = 28 / 255
ISChat.rpColorG = 18 / 255
ISChat.rpColorB = 128 / 255
ISChat.emoteR = 128 / 255
ISChat.emoteG = 0 / 255
ISChat.emoteB = 128 / 255
ISChat.sayIdentifier = "� �"
ISChat.meIdentifier = " �**"
ISChat.lowIdentifier = "[Low] "
ISChat.longIdentifier = "[Long] "
ISChat.sayR = 177 / 255
ISChat.sayG = 210 / 255
ISChat.sayB = 187 / 255
ISChat.foocR = 15 / 255
ISChat.foocG = 210 / 255
ISChat.foocB = 18 / 255
ISChat.rpEmoteColor = "<RGB:"..ISChat.emoteR..","..ISChat.emoteG..","..ISChat.emoteB..">" --/me, /do
ISChat.sayColor = "<RGB:"..ISChat.sayR..","..ISChat.sayG..","..ISChat.sayB..">" --/me, /do
ISChat.rpfoocColor = "<RGB:"..ISChat.foocR..","..ISChat.foocG..","..ISChat.foocB..">" --/fooc
ISChat.rpLanguage = ""
ISChat.rpLanguage1 = "Empty Slot"
ISChat.rpLanguage2 = "Empty Slot"
ISChat.hammer = "��*hammer*��"
ISChat.sayRange = SandboxVars.RoleplayChat.sayRange or 15 -- default
ISChat.meRange = SandboxVars.RoleplayChat.meRange or 25 -- default
ISChat.meLongRange = SandboxVars.RoleplayChat.meLongRange or 40 -- default
ISChat.lowRange = SandboxVars.RoleplayChat.lowRange or 5 -- default
ISChat.whisperRange = SandboxVars.RoleplayChat.whisperRange or 2 -- default
-- end roleplaychat settings

function ISChat:initialise()
    self:setUIName(ISChat.windowName);
    ISCollapsableWindow.initialise(self);
    self.showTimestamp = getCore():isOptionShowChatTimestamp();
    self.showTitle = getCore():isOptionShowChatTitle();
    self.minOpaque = getCore():getOptionMinChatOpaque(); -- in percentage
    self.maxOpaque = getCore():getOptionMaxChatOpaque(); -- in percentage
    self.fadeTime = getCore():getOptionChatFadeTime();
    self.chatFont = getCore():getOptionChatFontSize();
    self.opaqueOnFocus = getCore():getOptionChatOpaqueOnFocus();
    self:initFade(self.fadeTime);
    self.fade:update();
    self.backgroundColor.a = self.maxOpaque * ISChat.maxGeneralOpaque;
    self.pin = true;
    self.borderColor.a = 0.0;
	local charDesc = getPlayer():getDescriptor()
    local modplayerobj = getPlayer()
    local modData = modplayerobj:getModData()
	self.rpName = charDesc:getForename()
    self.rpColor = modData['rpColor'] or "*177,210,187*" --player name color
    self.rpEmoteColor = modData['rpEmoteColor'] or ISChat.instance.rpEmoteColor
    self.sayColor = modData['rpsayColor'] or ISChat.instance.sayColor
    self.rpfoocColor = modData['rpfoocColor'] or ISChat.instance.foocColor
    self.rpLanguage = ""
    self.rpLanguage1 = modData['rpLanguage1'] or ISChat.instance.rpLanguage1
    self.rpLanguage2 = modData['rpLanguage2'] or ISChat.instance.rpLanguage2
    self.hammer = "��*hammer*��"
    if isAdmin() then
        modData['_hammer'] = modData['_hammer'] or "on"
        ISChat.instance.hammer = "��*hammer*��"
    end
    if modData['rpEmoteColor'] == nil then
        modData['rpEmoteColor'] = ISChat.instance.rpEmoteColor --/me, /do
    elseif modData['rpsayColor'] == nil then
        modData['rpsayColor'] = ISChat.instance.sayColor
    elseif modData['rpfoocColor'] == nil then
        modData['rpfoocColor'] = ISChat.instance.foocColor
    end
    if modData['rpLanguage1'] == nil then
        modData['rpLanguage1'] = ISChat.instance.rpLanguage1 or "Empty Slot"
    elseif modData['rpLanguage2'] == nil then
        modData['rpLanguage2'] = ISChat.instance.rpLanguage2 or "Empty Slot"
    end
end

ISChat.initChat = function()
    local instance = ISChat.instance
    if instance.tabCnt == 1 then
        instance.chatText:setVisible(false);
        instance:removeChild(instance.chatText);
        instance.chatText = nil;
    elseif instance.tabCnt > 1 then
        instance.panel:setVisible(false);
        for i = 1, instance.tabCnt do
            instance.panel:removeView(instance.tabs[i])
        end
    end
    instance.tabCnt = 0;
    instance.tabs = {}
    instance.currentTabID = 0;
end

function ISChat:createChildren()
    --window stuff
    -- Do corner x + y widget
    local rh = self:resizeWidgetHeight()
    local resizeWidget = ISResizeWidget:new(self.width-rh, self.height-rh, rh, rh, self);
    resizeWidget:initialise();
    resizeWidget.onMouseDown = ISChat.onMouseDown;
    resizeWidget.onMouseUp = ISChat.onMouseUp;
    resizeWidget:setVisible(self.resizable)
    resizeWidget:bringToTop();
    resizeWidget:setUIName(ISChat.xyResizeWidgetName);
    self:addChild(resizeWidget);
    self.resizeWidget = resizeWidget;

    -- Do bottom y widget
    local resizeWidget2 = ISResizeWidget:new(0, self.height-rh, self.width-rh, rh, self, true);
    resizeWidget2.anchorLeft = true;
    resizeWidget2.anchorRight = true;
    resizeWidget2:initialise();
    resizeWidget2.onMouseDown = ISChat.onMouseDown;
    resizeWidget2.onMouseUp = ISChat.onMouseUp;
    resizeWidget2:setVisible(self.resizable);
    resizeWidget2:setUIName(ISChat.yResizeWidgetName);
    self:addChild(resizeWidget2);
    self.resizeWidget2 = resizeWidget2;

    -- close button
    local th = self:titleBarHeight()
    self.closeButton = ISButton:new(3, 0, th, th, "", self, self.close);
    self.closeButton:initialise();
    self.closeButton.borderColor.a = 0.0;
    self.closeButton.backgroundColor.a = 0;
    self.closeButton.backgroundColorMouseOver.a = 0;
    self.closeButton:setImage(self.closeButtonTexture);
    self.closeButton:setUIName(ISChat.closeButtonName);
    self:addChild(self.closeButton);

    -- lock button
    self.lockButton = ISButton:new(self.width - 19, 0, th, th, "", self, ISChat.pin);
    self.lockButton.anchorRight = true;
    self.lockButton.anchorLeft = false;
    self.lockButton:initialise();
    self.lockButton.borderColor.a = 0.0;
    self.lockButton.backgroundColor.a = 0;
    self.lockButton.backgroundColorMouseOver.a = 0;
    if self.locked then
        self.lockButton:setImage(self.chatLockedButtonTexture);
    else
        self.lockButton:setImage(self.chatUnLockedButtonTexture);
    end
    self.lockButton:setUIName(ISChat.lockButtonName);
    self:addChild(self.lockButton);
    self.lockButton:setVisible(true);

    --gear button
    self.gearButton = ISButton:new(self.lockButton:getX() - th / 2 - th, 1, th, th, "", self, ISChat.onGearButtonClick);
    self.gearButton.anchorRight = true;
    self.gearButton.anchorLeft = false;
    self.gearButton:initialise();
    self.gearButton.borderColor.a = 0.0;
    self.gearButton.backgroundColor.a = 0;
    self.gearButton.backgroundColorMouseOver.a = 0;
    self.gearButton:setImage(getTexture("media/ui/Panel_Icon_Gear.png"));
    self.gearButton:setUIName(ISChat.gearButtonName);
    self:addChild(self.gearButton);
    self.gearButton:setVisible(true);

    --general stuff
    self.minimumHeight = 90;
    self.minimumWidth = 200;
    self:setResizable(true);
    self:setDrawFrame(true);
    self:addToUIManager();

    self.tabs = {};
    self.tabCnt = 0;
    self.btnHeight = 25;
    self.currentTabID = 0;
    self.inset = 2
    self.fontHgt = getTextManager():getFontFromEnum(UIFont.Medium):getLineHeight();

    --text entry stuff
    local inset, EdgeSize, fontHgt = self.inset, 5, self.fontHgt;

    -- EdgeSize must match UITextBox2.EdgeSize
    local height = EdgeSize * 2 + fontHgt
    self.textEntry = ISTextEntryBox:new("", inset, self:getHeight() - 8 - inset - height, self:getWidth() - inset * 2, height);
    self.textEntry.font = UIFont.Medium
    self.textEntry:initialise();
    self.textEntry:instantiate();
    self.textEntry.backgroundColor = {r=0, g=0, b=0, a=0.5};
    self.textEntry.borderColor = {r=1, g=1, b=1, a=0.0};
    self.textEntry:setHasFrame(true)
    self.textEntry:setAnchorTop(false);
    self.textEntry:setAnchorBottom(true);
    self.textEntry:setAnchorRight(true);
    self.textEntry.onCommandEntered = ISChat.onCommandEntered;
    self.textEntry.onTextChange = ISChat.onTextChange;
    self.textEntry.onPressDown = ISChat.onPressDown;
    self.textEntry.onPressUp = ISChat.onPressUp;
    self.textEntry.onOtherKey = ISChat.onOtherKey
    self.textEntry.onClick = ISChat.onMouseDown;
    self.textEntry:setUIName(ISChat.textEntryName); -- need to be right this. If it will empty or another then focus will lost on click in chat
    self.textEntry:setHasFrame(true);
    self:addChild(self.textEntry)
    ISChat.maxTextEntryOpaque = self.textEntry:getFrameAlpha();

    --tab panel stuff
    local panelHeight = self.textEntry:getY() - self:titleBarHeight() - self.inset;
    self.panel = ISTabPanel:new(0, self:titleBarHeight(), self.width - inset, panelHeight);
    self.panel:initialise();
    self.panel.borderColor = { r = 0, g = 0, b = 0, a = 0};
    self.panel.onActivateView = ISChat.onActivateView;
    self.panel.target = self;
    self.panel:setAnchorTop(true);
    self.panel:setAnchorLeft(true);
    self.panel:setAnchorRight(true);
    self.panel:setAnchorBottom(true);
    self.panel:setEqualTabWidth(false);
    self.panel:setVisible(false);
    self.panel.onRightMouseUp = ISChat.onRightMouseUp;
    self.panel.onRightMouseDown = ISChat.onRightMouseDown;
    self.panel.onMouseUp = ISChat.onMouseUp;
    self.panel.onMouseDown = ISChat.ISTabPanelOnMouseDown;
    self.panel:setUIName(ISChat.tabPanelName);
    self:addChild(self.panel);

    self:bringToTop();
    self.textEntry:bringToTop();
    self.minimumWidth = self.panel:getWidthOfAllTabs() + 2 * inset;
    self.minimumHeight = self.textEntry:getHeight() + self:titleBarHeight() + 2 * inset + self.panel.tabHeight + fontHgt * 4;
    self:unfocus();

    self.mutedUsers = {}
end

function ISChat:setDrawFrame(visible)
    self.background = visible
    self.drawFrame = visible
    if self.closeButton then
        self.closeButton:setVisible(visible)
    end
end

function ISChat:collapse()
    self.pin = false;
    self.lockButton:setVisible(true);
end

function ISChat:close()
    if not self.locked then
        ISCollapsableWindow.close(self);
    end
end

function ISChat:pin()
    self.locked = not self.locked;
    ISChat.focused = not self.locked;
    if self.locked then
        self.lockButton:setImage(self.chatLockedButtonTexture);
    else
        self.lockButton:setImage(self.chatUnLockedButtonTexture);
    end
end


function ISChat:setEmoteColorMenu()
    local playerObj = getSpecificPlayer(0)
    if not playerObj then return end -- player hasn't been encountered yet
    local modal = ISTextBox:new(0, 0, 520, 180, "Specify an Emote Color in RGB format: Default: 128,0,128 \n ", "", nil, ISChat.setEmoteColorMenuConfirm, nil)
    modal:initialise()
    modal:addToUIManager()
end
function ISChat:setSayColorMenu()
    local playerObj = getSpecificPlayer(0)
    if not playerObj then return end -- player hasn't been encountered yet
    local modal = ISTextBox:new(0, 0, 520, 180, "Specify a /Say Color in RGB format: Default: 177,210,187 \n ", "", nil, ISChat.setSayColorMenuConfirm, nil)
    modal:initialise()
    modal:addToUIManager()
end
function ISChat:setfoocColorMenu()
    local playerObj = getSpecificPlayer(0)
    if not playerObj then return end -- player hasn't been encountered yet
    local modal = ISTextBox:new(0, 0, 520, 180, "Specify a Faction OOC Color in RGB format: Default: 15,210,18 \n ", "", nil, ISChat.setfoocColorMenuConfirm, nil)
    modal:initialise()
    modal:addToUIManager()
end
function ISChat:setNameColorMenu()
    local playerObj = getSpecificPlayer(0)
    if not playerObj then return end -- player hasn't been encountered yet
    local modal = ISTextBox:new(0, 0, 520, 180, "Specify a Name Color in RGB format: Default: 177,210,187 \n ", "", nil, ISChat.setNameColorMenuConfirm, nil)
    modal:initialise()
    modal:addToUIManager()
end
function ISChat:setfoocColorMenuConfirm(button, value)
    local modplayerobj = getPlayer()
    local modData = modplayerobj:getModData()
	if button.internal == "OK" then
        local txt = button.parent.entry:getText()
        local color = inputSplit(txt, ",")
        if not color[1] or not color[2] or not color[3] then
            print("user forgot an argument")
            modplayerobj:addLineChatElement("Please specify colors in RGB format separated by commas.", 1, 0, 0);
            return
        end
        modData['rpfoocColor'] = "<RGB:"..color[1]..","..color[2]..","..color[3]..">"
        ISChat.instance.rpfoocColor = "<RGB:"..color[1]..","..color[2]..","..color[3]..">"
	end
end
function ISChat:setNameColorMenuConfirm(button, value)
    local modplayerobj = getPlayer()
    local modData = modplayerobj:getModData()
	if button.internal == "OK" then
        local txt = button.parent.entry:getText()
        local color = inputSplitDivisionless(txt, ",")
        if not color[1] or not color[2] or not color[3] then
            print("user forgot an argument")
            modplayerobj:addLineChatElement("Please specify colors in RGB format separated by commas.", 1, 0, 0);
            return
        end
        modData['rpColor'] = "*"..color[1]..","..color[2]..","..color[3].."*"
        ISChat.instance.rpColor = "*"..color[1]..","..color[2]..","..color[3].."*"
	end
end

function ISChat:setEmoteColorMenuConfirm(button, value)
    local modplayerobj = getPlayer()
    local modData = modplayerobj:getModData()
	if button.internal == "OK" then
        local txt = button.parent.entry:getText()
        local color = inputSplit(txt, ",")
        if not color[1] or not color[2] or not color[3] then
            print("user forgot an argument")
            modplayerobj:addLineChatElement("Please specify colors in RGB format separated by commas.", 1, 0, 0);
            return
        end
        modData['rpEmoteColor'] = "<RGB:"..color[1]..","..color[2]..","..color[3]..">"
        ISChat.instance.rpEmoteColor = "<RGB:"..color[1]..","..color[2]..","..color[3]..">"
	end
end
function ISChat:setSayColorMenuConfirm(button, value)
    local modplayerobj = getPlayer()
    local modData = modplayerobj:getModData()
	if button.internal == "OK" then
        local txt = button.parent.entry:getText()
        local color = inputSplit(txt, ",")
        if not color[1] or not color[2] or not color[3] then
            print("user forgot an argument")
            modplayerobj:addLineChatElement("Please specify colors in RGB format separated by commas.", 1, 0, 0);
            return
        end
        modData['rpSayColor'] = "<RGB:"..color[1]..","..color[2]..","..color[3]..">"
        ISChat.instance.sayColor = "<RGB:"..color[1]..","..color[2]..","..color[3]..">"
	end
end
function ISChat:onGearButtonClick()
    local context = ISContextMenu.get(0, self:getAbsoluteX() + self:getWidth() / 2, self:getAbsoluteY() + self.gearButton:getY())

    local timestampOptionName = getText("UI_chat_context_enable_timestamp");
    if self.showTimestamp then
        timestampOptionName = getText("UI_chat_context_disable_timestamp");
    end
    context:addOption(timestampOptionName, ISChat.instance, ISChat.onToggleTimestampPrefix)
    local ThemeOption = context:addOption("Chat Colors", ISChat.instance);
    local themeSubMenu = context:getNew(context);
    context:addSubMenu(ThemeOption, themeSubMenu);
    themeSubMenu:addOption("Set Emote Color(/me, /do)", ISChat.instance, ISChat.setEmoteColorMenu);
    themeSubMenu:addOption("Set /say Color", ISChat.instance, ISChat.setSayColorMenu);
    themeSubMenu:addOption("Set Name Color", ISChat.instance, ISChat.setNameColorMenu);
    themeSubMenu:addOption("Set /fooc Color", ISChat.instance, ISChat.setfoocColorMenu);

    local tagOptionName = getText("UI_chat_context_enable_tags");
    if self.showTitle then
        tagOptionName = getText("UI_chat_context_disable_tags");
    end
    context:addOption(tagOptionName, ISChat.instance, ISChat.onToggleTagPrefix)

    local fontSizeOption = context:addOption(getText("UI_chat_context_font_submenu_name"), ISChat.instance);
    local fontSubMenu = context:getNew(context);
    context:addSubMenu(fontSizeOption, fontSubMenu);
    fontSubMenu:addOption(getText("UI_chat_context_font_small"), ISChat.instance, ISChat.onFontSizeChange, "small");
    fontSubMenu:addOption(getText("UI_chat_context_font_medium"), ISChat.instance, ISChat.onFontSizeChange, "medium");
    fontSubMenu:addOption(getText("UI_chat_context_font_large"), ISChat.instance, ISChat.onFontSizeChange, "large");
    if self.chatFont == "small" then
        fontSubMenu:setOptionChecked(fontSubMenu.options[1], true)
    elseif self.chatFont == "medium" then
        fontSubMenu:setOptionChecked(fontSubMenu.options[2], true)
    elseif self.chatFont == "large" then
        fontSubMenu:setOptionChecked(fontSubMenu.options[3], true)
    end
    local languageOption = context:addOption("Language Menu", ISChat.instance);
    local languageSubMenu = context:getNew(context);
    context:addSubMenu(languageOption, languageSubMenu);
    local currentLang = ISChat.checkLanguageActive()
    if currentLang == "" or currentLang == "Empty Slot" then
        currentLang = "English"
    end
    languageSubMenu:addOption("Current Language: "..currentLang, ISChat.instance);
    local modplayerobj = getPlayer()
    local modData = modplayerobj:getModData()
    ISChat.instance.rpLanguage = ISChat.instance.rpLanguage or "Empty Slot"
    ISChat.instance.rpLanguage1 = modData['rpLanguage1'] or "Empty Slot"
    ISChat.instance.rpLanguage2 = modData['rpLanguage2'] or "Empty Slot"
    languageSubMenu:addOption("[English]", ISChat.instance, ISChat.onlanguageChange, "Empty Slot");
    if ISChat.instance.rpLanguage1 ~= "Empty Slot" then
        languageSubMenu:addOption(ISChat.instance.rpLanguage1, ISChat.instance, ISChat.onlanguageChange, ISChat.instance.rpLanguage1);
    end

    if ISChat.instance.rpLanguage2 ~= "Empty Slot" then
        languageSubMenu:addOption(ISChat.instance.rpLanguage2, ISChat.instance, ISChat.onlanguageChange, ISChat.instance.rpLanguage2);
    end

    local minOpaqueOption = context:addOption(getText("UI_chat_context_opaque_min"), ISChat.instance);
    local minOpaqueSubMenu = context:getNew(context);
    context:addSubMenu(minOpaqueOption, minOpaqueSubMenu);
    local opaques = {0, 0.25, 0.5, 0.75, 1};
    for i = 1, #opaques do
        if logTo01(opaques[i]) <= self.maxOpaque then
            local option = minOpaqueSubMenu:addOption((opaques[i] * 100) .. "%", ISChat.instance, ISChat.onMinOpaqueChange, opaques[i])
            local current = math.floor(self.minOpaque * 1000)
            local value = math.floor(logTo01(opaques[i]) * 1000)
            if current == value then
                minOpaqueSubMenu:setOptionChecked(option, true)
            end
        end
    end

    local maxOpaqueOption = context:addOption(getText("UI_chat_context_opaque_max"), ISChat.instance);
    local maxOpaqueSubMenu = context:getNew(context);
    context:addSubMenu(maxOpaqueOption, maxOpaqueSubMenu);
    for i = 1, #opaques do
        if logTo01(opaques[i]) >= self.minOpaque then
            local option = maxOpaqueSubMenu:addOption((opaques[i] * 100) .. "%", ISChat.instance, ISChat.onMaxOpaqueChange, opaques[i])
            local current = math.floor(self.maxOpaque * 1000)
            local value = math.floor(logTo01(opaques[i]) * 1000)
            if current == value then
                maxOpaqueSubMenu:setOptionChecked(option, true)
            end
        end
    end

    local fadeTimeOption = context:addOption(getText("UI_chat_context_opaque_fade_time_submenu_name"), ISChat.instance);
    local fadeTimeSubMenu = context:getNew(context);
    context:addSubMenu(fadeTimeOption, fadeTimeSubMenu);
    local availFadeTime = {0, 1, 2, 3, 5, 10};
    local option = fadeTimeSubMenu:addOption(getText("UI_chat_context_disable"), ISChat.instance, ISChat.onFadeTimeChange, 0)
    if 0 == self.fadeTime then
        fadeTimeSubMenu:setOptionChecked(option, true)
    end
    for i = 2, #availFadeTime  do
        local time = availFadeTime[i];
        option = fadeTimeSubMenu:addOption(time .. " s", ISChat.instance, ISChat.onFadeTimeChange, time)
        if time == self.fadeTime then
            fadeTimeSubMenu:setOptionChecked(option, true)
        end
    end

    local opaqueOnFocusOption = context:addOption(getText("UI_chat_context_opaque_on_focus"), ISChat.instance);
    local opaqueOnFocusSubMenu = context:getNew(context);
    context:addSubMenu(opaqueOnFocusOption, opaqueOnFocusSubMenu);
    opaqueOnFocusSubMenu:addOption(getText("UI_chat_context_disable"), ISChat.instance, ISChat.onFocusOpaqueChange, false)
    opaqueOnFocusSubMenu:addOption(getText("UI_chat_context_enable"), ISChat.instance, ISChat.onFocusOpaqueChange, true)
    opaqueOnFocusSubMenu:setOptionChecked(opaqueOnFocusSubMenu.options[self.opaqueOnFocus and 2 or 1], true)
end

function ISChat:createTab()
    local chatY = self:titleBarHeight() + self.btnHeight + 2 * self.inset;
    local chatHeight = self.textEntry:getY() - chatY;
    local chatText = ISRichTextPanel:new(0, chatY, self:getWidth(), chatHeight);
    chatText.maxLines = 500
    chatText:initialise();
    chatText.background = false;
    chatText:setAnchorBottom(true);
    chatText:setAnchorRight(true);
    chatText:setAnchorTop(true);
    chatText:setAnchorLeft(true);
    chatText.log = {};
    chatText.logIndex = 0;
    chatText.marginTop = 2
    chatText.marginBottom = 0
    chatText.onRightMouseUp = nil;
    chatText.render = ISChat.render_chatText
    chatText.autosetheight = false;
    chatText:addScrollBars();
    chatText.vscroll:setVisible(false);
    chatText.vscroll.background = false;
    chatText:ignoreHeightChange()
    chatText:setVisible(false);
    chatText.chatTextLines = {};
    chatText.chatMessages = {};
    chatText.onRightMouseUp = ISChat.onRightMouseUp;
    chatText.onRightMouseDown = ISChat.onRightMouseDown;
    chatText.onMouseUp = ISChat.onMouseUp;
    chatText.onMouseDown = ISChat.onMouseDown;
    return chatText;
end

function ISChat:initFade(durationInS)
    self.fade:init(durationInS * 1000, true);
end

function ISChat:calcAlpha(defaultMin, defaultMax, fraction)
    -- default min/max value is not percentage! It's just [0,1] alpha value.
    -- The self.maxOpaque is current percentage of min/max alpha. self.maxOpaque assigned by player in context chat menu
    local newMinAlpha = defaultMin + self.minOpaque * (defaultMax - defaultMin);
    local newMaxAlpha = defaultMin + self.maxOpaque * (defaultMax - defaultMin); -- same as previous
    return newMinAlpha + fraction * (newMaxAlpha - newMinAlpha);
end

function ISChat:makeFade(fraction)
    local min, max = ISChat.minGeneralOpaque, ISChat.maxGeneralOpaque;
    local alpha = self:calcAlpha(min, max, fraction);
    self.backgroundColor.a = alpha;

    min = ISChat.minTextOpaque;
    alpha = self:calcAlpha(min, max, fraction);
    self.chatText:setContentTransparency(alpha)
    if self.tabCnt > 1 then
        self.panel:setTextTransparency(alpha);
    end

    min = ISChat.minControlOpaque;
    alpha = self:calcAlpha(min, max, fraction);
    self.widgetTextureColor.a = alpha;
    self.closeButton.textureColor.a = alpha;
    self.lockButton.textureColor.a = alpha;
    self.gearButton.textureColor.a = alpha;
    if self.tabCnt > 1 then
        self.panel:setTabsTransparency(alpha);
    end

    max = ISChat.maxTextEntryOpaque;
    min = ISChat.minTextEntryOpaque;
    alpha = self:calcAlpha(min, max, fraction);
    self.textEntry:setFrameAlpha(alpha);
    self.textEntry.backgroundColor.a = alpha;
end

function ISChat:prerender()
    ISChat.instance = self
    self.gearButton.onclick = self.onGearButtonClick

    self:setDrawFrame(true)

    if not ISChat.focused then
        self.fade:update();
    end
    self:makeFade(self.fade:fraction());

    local a = self.backgroundColor.a;
    local r, g, b = self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b;
    self:drawRect(0, 0, self:getWidth(), self:getHeight(), a, r, g, b);
    local th = self:titleBarHeight()
    local titlebarAlpha = self:calcAlpha(ISChat.minControlOpaque, ISChat.maxGeneralOpaque, self.fade:fraction());
    self:drawTextureScaled(self.titlebarbkg, 2, 1, self:getWidth() - 4, th - 2, titlebarAlpha, 1, 1, 1);
    if self.servermsg then
        local x = getCore():getScreenWidth() / 2 - self:getX()
        local y = getCore():getScreenHeight() / 4 - self:getY();
        self:drawTextCentre(self.servermsg, x, y, 1, 0.1, 0.1, 1, UIFont.Title);
        self.servermsgTimer = self.servermsgTimer - UIManager.getMillisSinceLastRender();
        if self.servermsgTimer < 0 then
            self.servermsg = nil;
            self.servermsgTimer = 0;
        end
    end
end

function ISChat:render()
    ISCollapsableWindow.render(self);
end

function ISChat:render_chatText()
    self:setStencilRect(0, 0, self.width, self.height)
    ISRichTextPanel.render(self)
    self:clearStencilRect()
end

function ISChat:onContextClear()
    self.chatText.chatTextLines = {}
    self.chatText.text = ""
    self.chatText:paginate()
end

function ISChat:logChatCommand(command)
    self.chatText.logIndex = 0;
    if command and command ~= "" then
        local newLog = {};
        table.insert(newLog, command);
        for i,v in ipairs(self.chatText.log) do
            table.insert(newLog, v);
            if i > 20 then
                break;
            end
        end
        self.chatText.log = newLog;
    end
end

function ISChat:onCommandEntered()
    local command = ISChat.instance.textEntry:getText();
    local chat = ISChat.instance;

    ISChat.instance:unfocus();
    if not command or command == "" then
        return;
    end

    local commandProcessed = false;
    local chatCommand;
    local chatStreamName;

    for _, stream in ipairs(ISChat.allChatStreams) do
        chatCommand = nil;
        if luautils.stringStarts(command, stream.command) then
            chatCommand = stream.command;
        elseif stream.shortCommand and luautils.stringStarts(command, stream.shortCommand) then
            chatCommand = stream.shortCommand;
        end
        if chatCommand then

            if chat.currentTabID ~= stream.tabID then
                showWrongChatTabMessage(chat.currentTabID - 1, stream.tabID - 1, chatCommand); -- from one-based to zero-based
                commandProcessed = true;
                break;
            end


            chat.chatText.lastChatCommand = chatCommand;
            local originalCommand = command;
            command = string.sub(command, #chatCommand);
            if command ~= "" and command ~= " " then
                chat:logChatCommand(originalCommand);
            end
            chatStreamName = stream.name;
            break;
        end
    end
    if not chatCommand then
        if luautils.stringStarts(command, "/") then
            SendCommandToServer(command);
            chat:logChatCommand(command);
            commandProcessed = true;
        else
            local defaultStream = ISChat.defaultTabStream[chat.currentTabID];
            chatStreamName = defaultStream.name;
            chat:logChatCommand(command);
        end
    end

    if not commandProcessed then
        local modplayerobj = getPlayer()
        local modData = modplayerobj:getModData()
        -- dont send blank strings.
        if string.len(command) <= 1 then
            return;
        end
        -- .
        -- dont let people spam
        if string.len(command) >= 2048 then
            getPlayer():Say(getText("UI_length_error_roleplaychat"));
            return;
        end
        -- .
        -- grammar
        local verb = "says, ";
        local punctuation = "";
        if string.len(command) <= 9 then
            verb = "states, ";
        end
        if luautils.stringEnds(command, "?") then
            verb = "asks, ";
        end
        if luautils.stringEnds(command, "!") then
            verb = "exclaims, ";
        end
        -- .
        if chatStreamName == "yell" then
            if luautils.stringStarts(command, " ") then
                command = command:sub(2);
            end
            command = firstToUpper(command)
            if not string.find(command, "%p") then
                punctuation = "!"
            end
            local combined = ISChat.instance.rpName .. getText("UI_verb_shouts_roleplaychat") ..  "''" .. command .. punctuation .. "''";
            processShoutMessage(combined);
        -- .
        elseif chatStreamName == "whisper" then
            local name, message = string.match(command, "(\"[^\"]*%s+[^\"]*\")%s(.+)")
            if not name or not message then name, message = string.match(command, "([^\"]%S*)%s(.+)") end
            message = firstToUpper(message)
            if not string.find(command, "%p") then
                punctuation = "."
            end
            local format = "((" .. tostring(getOnlineUsername()) .. "))" .. tostring(ISChat.instance.rpName) .. getText("UI_verb_whispers_roleplaychat") .. "''" .. message .. punctuation .. "''";
            local final = name .. " " .. format;
            proceedPM(final)
        -- .
        elseif chatStreamName == "whisperme" then
            local name, message = string.match(command, "(\"[^\"]*%s+[^\"]*\")%s(.+)")
            if not name or not message then name, message = string.match(command, "([^\"]%S*)%s(.+)") end
            local format = "((" .. tostring(getOnlineUsername()) .. "))" .. "**" .. tostring(ISChat.instance.rpName) .. " " .. message;
            local final = name .. " " .. format;
            proceedPM(final)
        -- .
        elseif chatStreamName == "pm" then
            local name, message = string.match(command, "(\"[^\"]*%s+[^\"]*\")%s(.+)")
            if not name or not message then name, message = string.match(command, "([^\"]%S*)%s(.+)") end
            local format = getText("UI_PM_roleplaychat") .. tostring(getOnlineUsername()) .. "/".. tostring(ISChat.instance.rpName) .. ")): " .. message;
            local final = name .. " " .. format;
            if isAdmin() then
                format = "(Admin PM)" .. tostring(getOnlineUsername()) .. "/".. tostring(ISChat.instance.rpName) .. ")): " .. message
                final = name .. " " .. format
            end
            proceedPM(final)
        -- .
        elseif chatStreamName == "levent" then
            if getAccessLevel() ~= "" then
                local combined = getText("UI_localevent_roleplaychat") .. command;
                processShoutMessage(combined);
            else
                getPlayer():Say(getText("UI_localevent_error_roleplaychat"))
            end
        -- .
        elseif chatStreamName == "faction" then
            if luautils.stringStarts(command, " ") then
                command = command:sub(2);
            end
            command = firstToUpper(command)
            local combined = getText("UI_faction_radio_roleplaychat") .. ISChat.instance.rpName .. " " .. verb .. "''" .. command .. "''";
            command = combined
            proceedFactionMessage(command);
        -- .
        elseif chatStreamName == "safehouse" then
            if luautils.stringStarts(command, " ") then
                command = command:sub(2);
            end
            command = firstToUpper(command)
            local combined = getText("UI_safehouse_radio_roleplaychat") .. ISChat.instance.rpName .. verb .. "''" .. command .. "''";
            command = combined
            processSafehouseMessage(command);
        -- .
        elseif chatStreamName == "admin" then
            local combined = ISChat.instance.rpName .. ": " .. command;
            command = combined
            processAdminChatMessage(command);
        -- .
        elseif chatStreamName == "low" then
            -- lets trim that first space so we dont have floating quotes
            if luautils.stringStarts(command, " ") then
                command = command:sub(2);
            end
            if not string.find(command, "%p") then
                punctuation = "."
            end
            command = firstToUpper(command)
            if modData['rpLanguage'] == nil then
                modData['rpLanguage'] = ISChat.instance.rpLanguage or "Empty Slot"
            elseif ISChat.instance.rpLanguage == nil then
                ISChat.instance.rpLanguage = "Empty Slot"
            end
            if ISChat.instance.rpLanguage == "[ASL]" then
                local player = getPlayer()
                verb = " signs, "
                if string.match(command, "%!") then
                    player:playEmote("freeze")
                elseif string.match(command, "%?") then
                    player:playEmote("undecided")
                elseif string.len(command) <= 15 then
                    player:playEmote("thankyou")
                elseif string.match(command, "fuck") then
                    player:playEmote("insult")
                elseif string.match(command, "yes") then
                    player:playEmote("yes")
                elseif string.match(command, "no") then
                    player:playEmote("no")
                end
            end
            local combined = ISChat.instance.lowIdentifier .. ISChat.checkLanguageActive() .. ISChat.instance.rpColor .. " ��" .. ISChat.instance.rpName .. "���� " .. verb .. "\"" .. command .. punctuation .. "\""
            if isAdmin() then
                if modData['_hammer'] ~= "off" then
                    combined = ISChat.instance.hammer .. ISChat.instance.rpColor .. " ��" .. ISChat.instance.rpName .. "���� " .. verb .. "\"" .. command .. punctuation .. "\""
                end
            end
            command = combined;
            processSayMessage(command);
        elseif chatStreamName == "melow" then
            local mePlayer = getPlayer();
            mecurrenttime = getGameTime():getHour();
            mecooldown = mecooldown or 0;
            local combined = ISChat.instance.lowIdentifier .. ISChat.instance.rpColor .. ISChat.instance.meIdentifier .. ISChat.instance.rpName .. "��� " .. command;
            command = combined;
            processSayMessage(command);
            if command and mecooldown <= mecurrenttime then
                local stats = mePlayer:getStats()
                local mentalhealth = mePlayer:getBodyDamage()
                local hunger = stats:getHunger()
                local thirst = stats:getThirst()
                stats:setHunger(hunger - 0.2)
                stats:setThirst(thirst - 0.2)
                stats:setStressFromCigarettes(stats:getStressFromCigarettes() - 50)
                mentalhealth:setBoredomLevel(mePlayer:getBodyDamage():getBoredomLevel() - 50);
                mentalhealth:setUnhappynessLevel(mePlayer:getBodyDamage():getUnhappynessLevel() - 50);
                mecooldown = getGameTime():getHour() + 1;
            end
        -- .
        elseif chatStreamName == "melong" then
            local mePlayer = getPlayer();
            mecurrenttime = getGameTime():getHour();
            mecooldown = mecooldown or 0;
            local combined = ISChat.instance.longIdentifier .. ISChat.instance.rpColor .. ISChat.instance.meIdentifier .. ISChat.instance.rpName .. "��� " .. command;
            command = combined;
            processSayMessage(command);
            if command and mecooldown <= mecurrenttime then
                local stats = mePlayer:getStats()
                local mentalhealth = mePlayer:getBodyDamage()
                local hunger = stats:getHunger()
                local thirst = stats:getThirst()
                stats:setHunger(hunger - 0.2)
                stats:setThirst(thirst - 0.2)
                stats:setStressFromCigarettes(stats:getStressFromCigarettes() - 50)
                mentalhealth:setBoredomLevel(mePlayer:getBodyDamage():getBoredomLevel() - 50);
                mentalhealth:setUnhappynessLevel(mePlayer:getBodyDamage():getUnhappynessLevel() - 50);
                mecooldown = getGameTime():getHour() + 1;
            end
        -- .
        elseif chatStreamName == "say" then
            -- lets trim that first space so we dont have floating quotes
            if luautils.stringStarts(command, " ") then
                command = command:sub(2);
            end
            if not string.find(command, "%p") then
                punctuation = "."
            end
            command = firstToUpper(command)
            if modData['rpLanguage'] == nil then
                modData['rpLanguage'] = ISChat.instance.rpLanguage or "Empty Slot"
            elseif ISChat.instance.rpLanguage == nil then
                ISChat.instance.rpLanguage = "Empty Slot"
            end
            if ISChat.instance.rpLanguage == "[ASL]" then
                local player = getPlayer()
                verb = " signs, "
                if string.match(command, "%!") then
                    player:playEmote("freeze")
                elseif string.match(command, "%?") then
                    player:playEmote("undecided")
                elseif string.len(command) <= 15 then
                    player:playEmote("thankyou")
                elseif string.match(command, "fuck") then
                    player:playEmote("insult")
                elseif string.match(command, "yes") then
                    player:playEmote("yes")
                elseif string.match(command, "no") then
                    player:playEmote("no")
                end
            end
            local combined = ISChat.checkLanguageActive() .. ISChat.instance.rpColor .. " ��" .. ISChat.instance.rpName .. "���� " .. verb .. "\"" .. command .. punctuation .. "\"" .. ISChat.instance.sayIdentifier
            if isAdmin() then
                if modData['_hammer'] ~= "off" then
                    combined = ISChat.instance.hammer .. ISChat.instance.rpColor .. " ��" .. ISChat.instance.rpName .. "���� " .. verb .. "\"" .. command .. punctuation .. "\"";
                end
            end
            command = combined;
            processSayMessage(command);
        -- .
        -- emotes for rp
        -- we simply manipulate our string by adding the desired color and characters name. you can change this to anything based on https://projectzomboid.com/chat_colours.txt
        -- we use the unicode character � as it does not pass through in zomboid and remains invisible. this, so that the regex in use with the *color* system does not eat our important spacing.
        -- try for yourself using *color* instead of this unicode system to see what i mean; you have dialogue in quotes colored but smashed right up against the rest of the emote.
        elseif chatStreamName == "me" then
            local meplayer = getPlayer();
            mecurrenttime = getGameTime():getHour();
            mecooldown = mecooldown or 0;
            local combined = ISChat.instance.rpColor .. ISChat.instance.meIdentifier .. ISChat.instance.rpName .. "��� " .. command;
            command = combined;
            processSayMessage(command);
            if command and mecooldown <= mecurrenttime then
                local stats = meplayer:getStats()
                local mentalhealth = meplayer:getBodyDamage()
                local hunger = stats:getHunger()
                local thirst = stats:getThirst()
                stats:setHunger(hunger - 0.2)
                stats:setThirst(thirst - 0.2)
                stats:setStressFromCigarettes(stats:getStressFromCigarettes() - 50)
                mentalhealth:setBoredomLevel(meplayer:getBodyDamage():getBoredomLevel() - 50);
                mentalhealth:setUnhappynessLevel(meplayer:getBodyDamage():getUnhappynessLevel() - 50);
                mecooldown = getGameTime():getHour() + 1;
            end
        -- .
        elseif chatStreamName == "do" then
            local combined = ISChat.instance.rpColor .. "��� " .. " �**" ..  " " .. command;
            command = combined;
            processSayMessage(command);
        -- .
        -- end emotes
		-- can also use /act. this sets the name that appears when we type in chat. default is characters firstname. example usage: /name John
        elseif chatStreamName == "name" then
            if SandboxVars.RoleplayChat.ToggleNameChange then
                getPlayer():addLineChatElement("Name Changing has been disabled by an Admin.", 1, 0, 0);
                doKeyPress(false);
                ISChat.instance.timerTextEntry = 20;
                ISChat.instance:unfocus();
                return
            end
            if luautils.stringStarts(command, " ") then
                command = command:sub(2);
            end
            command = firstToUpper(command)
            ISChat.instance.rpName = command;
            getPlayer():getDescriptor():setForename(command)
            getPlayer():getDescriptor():setSurname("")
            sendPlayerStatsChange(getPlayer())
            getPlayer():Say(getText("UI_name_change_roleplaychat") .. command);
		-- for when we want to specify we are not speaking in-character. can also use /l
        elseif chatStreamName == "looc" then
            if SandboxVars.RoleplayChat.ToggleLOOC and not isAdmin() then
                getPlayer():addLineChatElement("Local OOC has been disabled by an Admin.", 1, 0, 0);
                doKeyPress(false);
                ISChat.instance.timerTextEntry = 20;
                ISChat.instance:unfocus();
                return
            end
            local combined = "*teal*" .. ISChat.instance.rpName .. ": ((" .. command .. " ))";
            if isAdmin() then
                if modData['_hammer'] ~= "off" then
                    combined = ISChat.instance.hammer .. ISChat.instance.rpName .. "*teal*".. ": ((" .. command .. " ))";
                end
            end
            command = combined;
            processSayMessage(command);
        -- .
        elseif chatStreamName == "general" then
            if SandboxVars.RoleplayChat.ToggleOOC and not isAdmin() then
                getPlayer():addLineChatElement("Global OOC has been disabled by an Admin.", 1, 0, 0);
                doKeyPress(false);
                ISChat.instance.timerTextEntry = 20;
                ISChat.instance:unfocus();
                return
            end
            local combined = ISChat.instance.rpName .. ": ((" .. command .. " ))";
            if isAdmin() then
                if modData['_hammer'] ~= "off" then
                    combined = "(Admin) ".. ISChat.instance.rpName .. ": ((" .. command .. " ))"
                end
            end
            command = combined;
            processGeneralMessage(command);
        -- .
        elseif chatStreamName == "globalradio" then
            --[[
            if SandboxVars.RoleplayChat.ToggleOOC and not isAdmin() then
                getPlayer():addLineChatElement("Global OOC has been disabled by an Admin.", 1, 0, 0);
                doKeyPress(false);
                ISChat.instance.timerTextEntry = 20;
                ISChat.instance:unfocus();
                return
            end
            --]]
            local combined = ISChat.instance.rpName .. "(111.2 MHz): " .. command .. " ";
            if isAdmin() then
                if modData['_hammer'] ~= "off" then
                    combined = "(Admin) ".. ISChat.instance.rpName .. ": ((" .. command .. " ))"
                end
            command = combined;
            processGeneralMessage(command);
            end
        end
        -- .
    end
    doKeyPress(false);
    ISChat.instance.chatText.lastChatCommand = nil
    ISChat.instance.timerTextEntry = 20;
    ISChat.instance:unfocus();
end

function ISChat:checkLanguageActive()
    local language = ISChat.instance.rpLanguage
    if language == "" or language == "English" or language == "Empty Slot" then
        return ""
    end
    return language
end

function ISChat:onOtherKey(key)
    if key == Keyboard.KEY_ESCAPE then
        ISChat.instance:unfocus();
    end
end

ISChat.onSwitchStream = function()
    if ISChat.focused then
        local curTxtPanel = ISChat.instance.chatText
        local chatStreams = curTxtPanel.chatStreams;
        for i = 0, #chatStreams do
            curTxtPanel.streamID = curTxtPanel.streamID % #chatStreams + 1;
            if checkPlayerCanUseChat(chatStreams[curTxtPanel.streamID].command) then
                break;
            end
        end
        ISChat.instance.textEntry:setText(chatStreams[curTxtPanel.streamID].command);
    end
end

ISChat.onTextChange = function()
    local t = ISChat.instance.textEntry;
    local internalText = t:getInternalText();
    if ISChat.instance.chatText.lastChatCommand ~= nil then
        for _, chat in ipairs(ISChat.instance.chatText.chatStreams) do
            local prefix;
            if chat.command and luautils.stringStarts(internalText, chat.command) then
                prefix = chat.command;
            elseif chat.shortCommand and luautils.stringStarts(internalText, chat.shortCommand) then
                prefix = chat.shortCommand;
            end
			-- modified to let us run //
            if prefix then
                if string.sub(t:getText(), prefix:len() + 1, t:getText():len()):len() <= 5
                        and luautils.stringStarts(internalText, "/")
                        and luautils.stringEnds(internalText, " /") then
                    t:setText("/");
                    return;
                end
            end
        end
        if t:getText():len() <= 5 and luautils.stringEnds(internalText, " /") then
            t:setText("/");
            return;
        end
    end
end

function ISChat:focus()
    self:setVisible(true);
    ISChat.focused = true;
    self.textEntry:setEditable(true);
    self.textEntry:focus();
    self.textEntry:ignoreFirstInput();
    self.textEntry:setText(self.chatText.lastChatCommand);
    self.fade:reset();
    self.fade:update(); --reset fraction to start value
end

function ISChat:unfocus()
    self.textEntry:unfocus();
    self.textEntry:setText("");
    if ISChat.focused then
        self.fade:reset(); -- to begin fade. unfocus called when element was unfocused also.
    end
    ISChat.focused = false;
    self.textEntry:setEditable(false);
end

function ISChat:updateChatPrefixSettings()
    updateChatSettings(self.chatFont, self.showTimestamp, self.showTitle);
    -- do not know why we waste time doing this to historical messages
    --[[
    for tabNumber, chatText in ipairs(self.tabs) do
        chatText.text = "";
        local newText = "";
        chatText.chatTextLines = {};
        for i,msg in ipairs(chatText.chatMessages) do
            local line = msg:getTextWithPrefix() .. " <LINE> ";
            table.insert(chatText.chatTextLines, line);
            if i == #chatText.chatMessages then
                line = string.gsub(line, " <LINE> $", "")
            end
            newText = newText .. line;
        end
        chatText.text = newText;
        chatText:paginate();
    end
    --]]
end

ISChat.onToggleTimestampPrefix = function()
    local chat = ISChat.instance;
    chat.showTimestamp = not chat.showTimestamp;
    if chat.showTimestamp then
        print("timestamp enabled");
    else
        print("timestamp disabled");
    end
    chat:updateChatPrefixSettings();
end

ISChat.onToggleTagPrefix = function()
    local chat = ISChat.instance;
    chat.showTitle = not chat.showTitle;
    if chat.showTitle then
        print("tags enabled");
    else
        print("tags disabled");
    end
    chat:updateChatPrefixSettings();
end

ISChat.onFontSizeChange = function(target, value)
    if target.chatFont == value then
        return;
    end
    target.chatFont = value;
    target:updateChatPrefixSettings();
    print("Font size switched to " .. value);
end
ISChat.onlanguageChange = function(target, value)
    ISChat.instance.rpLanguage = value or "Empty Slot"
    print("language switched to " .. value);
    if ISChat.instance.rpLanguage ~= "Empty Slot" then
        getPlayer():addLineChatElement("You are now using "..value, 0, 1, 1);
    else
        getPlayer():addLineChatElement("You are now using [English]", 0, 1, 1);
    end
end
ISChat.onMinOpaqueChange = function(target, value)
    target.minOpaque = logTo01(value);
    target.backgroundColor.a = target.maxOpaque;
    getCore():setOptionMinChatOpaque(target.minOpaque);
end

ISChat.onMaxOpaqueChange = function(target, value)
    target.maxOpaque = logTo01(value);
    target.backgroundColor.a = target.maxOpaque;
    getCore():setOptionMaxChatOpaque(target.maxOpaque);
end

ISChat.onFadeTimeChange = function(target, value)
    target.fadeTime = value;
    target:initFade(target.fadeTime);
    getCore():setOptionChatFadeTime(value);
end

ISChat.onFocusOpaqueChange = function(target, value)
    target.opaqueOnFocus = value;
    getCore():setOptionChatOpaqueOnFocus(value);
end

ISChat.addLineInChat = function(message, tabID)
    message:setShouldAttractZombies(false)
    local playerAuthor = getPlayerFromUsername(message:getAuthor())
    local modPlayerobj = getPlayer()
    local modData = modPlayerobj:getModData()
    local line = message:getTextWithPrefix();
    local messageRange = SandboxVars.RoleplayChat.sayRange

    line = line:gsub("%[" .. escape_pattern(message:getAuthor()) .. "%]" .. "%:", "");
    if message:isServerAlert() then
        ISChat.instance.servermsg = "";
        if message:isShowAuthor() then
            ISChat.instance.servermsg = message:getAuthor() .. ": ";
        end
        ISChat.instance.servermsg = ISChat.instance.servermsg .. message:getText();
        ISChat.instance.servermsgTimer = 5000;
    end
    if playerAuthor and modPlayerobj then
        if string.match(line, ISChat.instance.meIdentifier) then
            messageRange = SandboxVars.RoleplayChat.meRange
        elseif string.match(line, ISChat.instance.lowIdentifier) then
            messageRange = SandboxVars.RoleplayChat.lowRange
        elseif string.match(line, ISChat.instance.whisperIdentifier) then
            messageRange = SandboxVars.RoleplayChat.whisperRange
        end
        local dx = playerAuthor:getSquare():getX() - modPlayerobj:getSquare():getX()
        local dy = playerAuthor:getSquare():getY() - modPlayerobj:getSquare():getY()
        local zGood = math.abs(playerAuthor:getSquare():getZ() - modPlayerobj:getSquare():getZ()) < 2
        local dist = math.sqrt(dx*dx + dy*dy)
        print("range = "..messageRange)
        print("distance = "..dist)
        if not zGood or dist > messageRange then
            if dist > messageRange + 5 then
                message:setOverHeadSpeech(false)
            end
            return
        end
    end
    -- playable sounds via having the client check for a matching string
    if string.match(line, " Welcome to Necropolis ") and not playerAuthor then --dont let clients send this, only the motd
        NecropolisUtilities.soundIntro()
    end
    if string.match(line, "playSound2D=") and playerAuthor:getAccessLevel() == "Admin" then
        local chatbox = ISChat.instance.chatText.chatTextLines
        local soundfile = string.match(line, "=(.*)")
        soundfile = soundfile:gsub("=","")
        line = line:gsub("playSound2D=", "")
        line = line:gsub(soundfile, "")
        for i, v in ipairs(chatbox) do
            if (string.find(v, line)) then
                table.remove(chatbox, v)
            end
        end
        table.remove(chatbox, i)
        print(soundfile)
        NecropolisUtilities.adminPlaySound2D(soundfile)
    end
    -- find our invisible unicode patterns and replace them. if zomboid's above head chat bubbles parsed the strings like the chat box did, i wouldnt need these.
    -- unicode characters are invisible, and therefore, do not show up above the head and i need no further code to scrub them out
    if string.match(line, "���� ") then -- say chat
        line = line:gsub("���� ", "� �� "..ISChat.instance.sayColor)
    end
    if string.match(line, "��� ") then -- emotes
        line = line:gsub("��� ", "� �� "..ISChat.instance.rpEmoteColor)
    end
    if string.match(line, "((Faction OOC))� ") then -- guess
        line = line:gsub("((Faction OOC))� ", ISChat.instance.rpfoocColor.." �((Faction OOC))� ")
    end

    if string.match(line, " �**") then --find our emote identifiers
        line = line:gsub(' \"', '� '..ISChat.instance.sayColor..' ��� \"')
        line = line:gsub('\" ', '\"� �� '..ISChat.instance.rpEmoteColor)
    end

    --[[
    if string.match(line, "img=media/textures/bubble") then -- untested helper for chat bubble mod to delete those pesky lines extra hard
        ChatBubble.deleteMessage()
    end
    --]]

    local lineLanguage = getLineLanguage(line, ISChat.languages)
    if getPlayer() ~= playerAuthor and not isAdmin() then
        if lineLanguage == "ASL" then
            local rng = ZombRand(1,20)
            --line = line:gsub("%[ASL%]", "")
            if ISChat.instance.rpLanguage1 ~= "[ASL]" and ISChat.instance.rpLanguage2 ~= "[ASL]" then
                message:setOverHeadSpeech(false)
                local verb = " gestures in ASL."
                if rng >= 10 then
                    verb = " twirls their hands, forming a few gestures."
                else
                    verb = " forms words with their fingers."
                end
                if string.match(line, "%!") then
                    verb = " gestures emphatically."
                elseif string.match(line, "%?") then
                    verb = " seems to ask a question through various gestures."
                elseif string.match(line, "%.%.%.") then
                    verb = " seems to trail off with their hands."
                elseif string.match(line, "Fuck") or string.match(line, "Shit") then
                    verb = " appears frustrated as they form signs with their hands."
                elseif string.match(line, " Yes ") or string.match(line, "Yes.") then
                    verb = " seems to indicate approval."
                elseif string.match(line, " No ") then
                    verb = " makes a gesture indicating disapproval."
                end
                line = ISChat.instance.rpEmoteColor .. get_rpname_specific(playerAuthor) .. verb
            end
            if string.match(line, "%!") then
                playerAuthor:playEmote("freeze")
            elseif string.match(line, "%?") then
                playerAuthor:playEmote("undecided")
            elseif string.match(line, "%.%.%.") then
                playerAuthor:playEmote("thankyou")
            elseif string.match(line, "Fuck") then
                playerAuthor:playEmote("insult")
            elseif string.match(line, "Yes") then
                playerAuthor:playEmote("yes")
            elseif string.match(line, "No") then
                playerAuthor:playEmote("no")
            end
        else
            line = ISChat.parseLineLanguage(line, lineLanguage)
        end
    end

    if user and ISChat.instance.mutedUsers[user] then return end
    if not ISChat.instance.chatText then
        ISChat.instance.chatText = ISChat.instance.defaultTab;
        ISChat.instance:onActivateView();
    end
    local chatText;
    for i,tab in ipairs(ISChat.instance.tabs) do
        if tab and tab.tabID == tabID then
            chatText = tab;
            break;
        end
    end
    if chatText.tabTitle ~= ISChat.instance.chatText.tabTitle then
        local alreadyExist = false;
        for i,blinkedTab in ipairs(ISChat.instance.panel.blinkTabs) do
            if blinkedTab == chatText.tabTitle then
                alreadyExist = true;
                break;
            end
        end
        if alreadyExist == false then
            table.insert(ISChat.instance.panel.blinkTabs, chatText.tabTitle);
        end
    end
    local vscroll = chatText.vscroll
    local scrolledToBottom = (chatText:getScrollHeight() <= chatText:getHeight()) or (vscroll and vscroll.pos == 1)
    if #chatText.chatTextLines > ISChat.maxLine then
        local newLines = {};
        for i,v in ipairs(chatText.chatTextLines) do
            if i ~= 1 then
                table.insert(newLines, v);
            end
        end
        table.insert(newLines, line .. " <LINE> ");
        chatText.chatTextLines = newLines;
    else
        table.insert(chatText.chatTextLines, line .. " <LINE> ");
    end
    chatText.text = "";
    local newText = "";
    for i,v in ipairs(chatText.chatTextLines) do
        if i == #chatText.chatTextLines then
            v = string.gsub(v, " <LINE> $", "")
        end
        newText = newText .. v;
    end
    chatText.text = newText;
    table.insert(chatText.chatMessages, message);
    chatText:paginate();
    if scrolledToBottom then
        chatText:setYScroll(-10000);
    end
end

ISChat.parseLineLanguage = function(line, sourceLanguage)
    -- Remove label if empty
    if string.match(line, "%[Empty Slot%]") then
        return line:gsub("%[Empty Slot%]", "")
    end
    -- Return if user understands language 
    if ISChat.instance.rpLanguage1 == "["..sourceLanguage.."]" or ISChat.instance.rpLanguage2 == "["..sourceLanguage.."]" then
        return line
    end
    -- Russians and Ukranians understand each other <3
    if (sourceLanguage == "[Ukrainian]" and ( ISChat.instance.rpLanguage1 == "[Russian]" or ISChat.instance.rpLanguage2 == "[Russian]" )) or 
        (sourceLanguage == "[Russian]" and ( ISChat.instance.rpLanguage1 == "[Ukrainian]" or ISChat.instance.rpLanguage2 == "[Ukrainian]" )) then
        return line
    end

    -- User does not understand language
    message:setOverHeadSpeech(false)
    local verb = " says something in "..sourceLanguage.."."
    if string.match(line, "%!") then
        if ZombRand(1,5) >= 3 then
            verb = " raises their voice, speaking emphatically in "..sourceLanguage.."."
        else
            verb = " calls out in "..sourceLanguage..", their voice louder than normal."
        end
    elseif string.match(line, "%?") then
        verb = " seems to ask a question in "..sourceLanguage.."."
    elseif string.len(line) <= 70 then
        verb = " states something in "..sourceLanguage.."."
    end
    line = ISChat.instance.rpEmoteColor .. get_rpname_specific(playerAuthor) .. verb

    return line
end

ISChat.onToggleChatBox = function(key)
    if ISChat.instance==nil then return; end
    if key == getCore():getKey("Toggle chat") or key == getCore():getKey("Alt toggle chat") then
        ISChat.instance:focus();
    end
    local chat = ISChat.instance;
    if key == getCore():getKey("Switch chat stream") then
        chat.currentTabID = chat.currentTabID % chat.tabCnt + 1;
        chat.panel:activateView(chat.tabs[chat.currentTabID].tabTitle);
        ISChat.instance:onActivateView();
    end
end

ISChat.onKeyKeepPressed = function(key)
    if ISChat.instance==nil then return; end
end

function ISChat:calcTabSize()
    if ISChat.instance.tabCnt == 0 then
        return {width = self.width, height = self.textEntry:getY() - self.panel:getY()};
    elseif ISChat.instance.tabCnt > 0 then
        return {width = self.panel.width, height = self.panel.height - self.panel.tabHeight - 1};
    end
end

function ISChat:calcTabPos()
    if ISChat.instance.tabCnt == 0 then
        return {x = 0, y = self:titleBarHeight() + self.inset};
    else
        return {x = 0, y = self:titleBarHeight() + self.btnHeight + 2 * self.inset};
    end
end

ISChat.onTabAdded = function(tabTitle, tabID)
    local chat = ISChat.instance;
    local newTab = chat:createTab();
    newTab.parent = chat;
    newTab.tabTitle = tabTitle;
    newTab.tabID = tabID;
    newTab.streamID = 1;
    newTab.chatStreams = {}
    for _, stream in ipairs(ISChat.allChatStreams) do
        if stream.tabID == tabID + 1 then --tabID is zero-based index but stream.tabID is one-based index.
            table.insert(newTab.chatStreams, stream)
        end
    end
    if not newTab.lastChatCommand then
        newTab.lastChatCommand = " . . . . . "
    end
    newTab.lastChatCommand = newTab.chatStreams[newTab.streamID].command;
    newTab:setUIName("chat text panel with title '" .. tabTitle .. "'");
    local pos = chat:calcTabPos();
    local size = chat:calcTabSize();
    newTab:setY(pos.y);
    newTab:setHeight(size.height);
    newTab:setWidth(size.width);
    if chat.tabCnt == 0 then
        chat:addChild(newTab);
        chat.chatText = newTab;
        chat.chatText:setVisible(true);
    end
    if chat.tabCnt == 1 then
        chat.panel:setVisible(true);
        chat.chatText:setY(pos.y);
        chat.chatText:setHeight(size.height);
        chat.chatText:setWidth(size.width);
        chat:removeChild(chat.chatText);
        chat.panel:addView(chat.chatText.tabTitle, chat.chatText);
    end
    if chat.tabCnt >= 1 then
        chat.panel:addView(tabTitle, newTab);
        chat.minimumWidth = chat.panel:getWidthOfAllTabs() + 2 * chat.inset;
    end
    table.insert(chat.tabs, newTab);
    chat.tabCnt = chat.tabCnt + 1;
end

ISChat.onTabRemoved = function(tabTitle, tabID)
    local foundedTab;
    for i,tab in ipairs(ISChat.instance.tabs) do
        if tabID == tab.tabID then
            foundedTab = tab;
            table.remove(ISChat.instance.tabs, i);
            break;
        end
    end
    if ISChat.instance.tabCnt > 1 then
        for i,blinkedTab in ipairs(ISChat.instance.panel.blinkTabs) do
            if tabTitle == blinkedTab then
                table.remove(ISChat.instance.panel.blinkTabs, i);
                break;
            end
        end
        ISChat.instance.panel:removeView(foundedTab);
        ISChat.instance.minimumWidth = ISChat.instance.panel:getWidthOfAllTabs() + 2 * ISChat.instance.inset;

    end
    ISChat.instance.tabCnt = ISChat.instance.tabCnt - 1;
    if ISChat.instance.tabCnt == 1 then
        local lastTab = ISChat.instance.tabs[1];
        ISChat.instance.panel:setVisible(false);
        ISChat.instance.panel:removeView(lastTab);
        ISChat.instance.chatText = lastTab;
        ISChat.instance:addChild(ISChat.instance.chatText);
        ISChat.instance.chatText:setVisible(true);
    end
    ISChat.instance:onActivateView();
end

ISChat.onSetDefaultTab = function(defaultTabTitle)
    for i,v in ipairs(ISChat.instance.tabs) do
        if v.tabTitle == defaultTabTitle then
            ISChat.instance.defaultTab = v;
            ISChat.instance.currentTabID = i;
            ISChat.instance.chatText = v;
            ISChat.instance:onActivateView();
            return;
        end
    end
    ISChat.instance.defaultTab = nil;
end

function ISChat:onActivateView()
    if self.tabCnt > 1 then
        self.chatText = self.panel.activeView.view;
    end
    for i,blinkedTab in ipairs(self.panel.blinkTabs) do
        if self.chatText.tabTitle and self.chatText.tabTitle == blinkedTab then
            table.remove(self.panel.blinkTabs, i);
            break;
        end
    end
    for i,tab in ipairs(self.tabs) do
        if tab.tabTitle == self.chatText.tabTitle then
            self.currentTabID = i;
            break;
        end
    end
    focusOnTab(self.chatText.tabID)
end

function ISChat:new (x, y, width, height)
    local o = {}
    --o.data = {}
    o = ISCollapsableWindow:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
    o.x = x;
    o.y = y;
    o.borderColor = {r=1, g=1, b=1, a=0.7};
    o.backgroundColor = {r=0, g=0, b=0, a=1};
    o.width = width;
    o.height = height;
    o.anchorLeft = true;
    o.anchorRight = false;
    o.anchorTop = true;
    o.anchorBottom = false;
    o.onRightMouseUp = nil;
    o.prevBtnTxt = getTexture("media/ui/sGuidePrevBtn.png");
    o.nextBtnTxt = getTexture("media/ui/sGuideNextBtn.png");
    o.closeBtnTxt = getTexture("media/ui/sGuideCloseBtn.png");
    o.chatLockedButtonTexture = getTexture("media/ui/lock.png");
    o.chatUnLockedButtonTexture = getTexture("media/ui/lockOpen.png");
    o.background = true;
    o.timerTextEntry = 0;
    o.servermsg = "";
    o.servermsgTimer = 0;
    o.showTimestamp = true;
    o.showTitle = true;
    o.chatFont = "medium";
    o.fadeTime = 0;
    o.minOpaque = 1; -- in percentage
    o.maxOpaque = 1; -- in percentage
    o.opaqueOnFocus = true;
    o.backgroundColor.a = 1.0 * o.maxOpaque;
    o.fade = UITransition.new()
    o.fade:setIgnoreUpdateTime(true);
    ISChat.instance = o;
    Events.OnTick.Add(ISChat.ontick);
    return o
end

function ISChat:onPressDown()
    local chat = ISChat.instance;
    local chatText = chat.chatText;
    chatText.logIndex = chatText.logIndex - 1;
    if chatText.logIndex < 0 then
        chatText.logIndex = 0;
    end
    if chatText.log and chatText.log[chatText.logIndex] then
        --        print(ISChat.instance.log[ISChat.instance.logIndex]);
        chat.textEntry:setText(chatText.log[chatText.logIndex]);
    else
        chat.textEntry:setText("");
    end
end

function ISChat:onPressUp()
    local chat = ISChat.instance;
    local chatText = chat.chatText;
    chatText.logIndex = chatText.logIndex + 1;
    if chatText.logIndex > #chatText.log then
        chatText.logIndex = #chatText.log;
    end
    if chatText.log and chatText.log[chatText.logIndex] then
        --        print(ISChat.instance.log[ISChat.instance.logIndex]);
        chat.textEntry:setText(chatText.log[chatText.logIndex]);
    end
end

function ISChat:isCursorOnTitlebar(x, y)
   return y <= self:titleBarHeight();
end

function ISChat.onMouseUp(target, x, y)
    -- check if player clicked on titlebar
    if target:getUIName() == ISChat.windowName and ISChat.instance.moving then
        ISCollapsableWindow.onMouseUp(ISChat.instance, x, y);
        return true;
    end

    -- checks if player clicked on text panel
    if target:getUIName() == ISChat.textPanelName then
        -- if window focused we should ignore other handlers. if we returns true then another handlers will be ignored
        -- we ignore clicks on text
        return ISChat.focused;
    end

    -- checks if player clicked on tab panel
    if target:getUIName() == ISChat.tabPanelName then
        ISTabPanel.onMouseUp(ISChat.instance.panel, x, y)
        return ISChat.focused;
    end

    -- checks if player clicked on text entry panel
    if target:getUIName() == ISChat.textEntryName then
        return ISChat.focused;
    end

    -- checks if player clicked on bottom y resize widget
    if not ISChat.instance.locked and target:getUIName() == ISChat.yResizeWidgetName then
        ISResizeWidget.onMouseUp(ISChat.instance.resizeWidget2, x, y);
        return true
    end

    -- checks if player clicked on xy resize widget
    if not ISChat.instance.locked and target:getUIName() == ISChat.xyResizeWidgetName then
        ISResizeWidget.onMouseUp(ISChat.instance.resizeWidget, x, y);
        return true
    end

    return ISChat.focused;
end

function ISChat.onMouseDown(target, x, y)
    -- check if player clicked on titlebar
    if target:getUIName() == ISChat.windowName and not ISChat.instance.locked and ISChat.instance:isCursorOnTitlebar(x, y) then
        ISCollapsableWindow.onMouseDown(ISChat.instance, x, y);
        return true;
    end

    -- checks if player clicked on text panel
    if target:getUIName() == ISChat.textPanelName then
        -- if window focused we should ignore other handlers. if we returns true then another handlers will be ignored
        -- we ignore clicks on text
        return ISChat.focused;
    end

    -- checks if player clicked on tab panel
    if target:getUIName() == ISChat.tabPanelName then
        ISChat.ISTabPanelOnMouseDown(ISChat.instance.panel, x, y)
        return ISChat.focused;
    end

    -- checks if player clicked on text entry panel
    if target:getUIName() == ISChat.textEntryName then
        return ISChat.focused;
    end

    -- checks if player clicked on bottom y resize widget
    if not ISChat.instance.locked and target:getUIName() == ISChat.yResizeWidgetName then
        ISResizeWidget.onMouseDown(ISChat.instance.resizeWidget2, x, y);
        return true
    end

    -- checks if player clicked on xy resize widget
    if not ISChat.instance.locked and target:getUIName() == ISChat.xyResizeWidgetName then
        ISResizeWidget.onMouseDown(ISChat.instance.resizeWidget, x, y);
        return true
    end

    return ISChat.focused;
end

ISChat.ISTabPanelOnMouseDown = function(target, x, y)
    if target:getMouseY() >= 0 and target:getMouseY() < target.tabHeight then
        if target:getScrollButtonAtX(x) == "left" then
            target:onMouseWheel(-1)
            return true
        end
        if target:getScrollButtonAtX(x) == "right" then
            target:onMouseWheel(1)
            return true
        end
        local tabIndex = target:getTabIndexAtX(target:getMouseX())
        if tabIndex >= 1 and tabIndex <= #target.viewList and ISTabPanel.xMouse == -1 and ISTabPanel.yMouse == -1 then -- if we clicked on a tab, the first time we set up the x,y of the mouse, so next time we can see if the player moved the mouse (moved the tab)
            ISTabPanel.xMouse = target:getMouseX();
            ISTabPanel.yMouse = target:getMouseY();
            target.draggingTab = tabIndex - 1;
            local clickedTab = target.viewList[target.draggingTab + 1];
            target:activateView(clickedTab.name)
            return true
        end
    end
    return false
end

function ISChat:onRightMouseUp(x, y)
    if ISChat.focused then
        return true;
    end
    return false;
end

function ISChat:onRightMouseDown(x, y)
    if ISChat.focused then
        return true;
    end
    return false;
end

function ISChat:mute(username)
    if self.mutedUsers[username] then
        self.mutedUsers[username] = nil
    else
        self.mutedUsers[username] = true
    end
end

function ISChat:isMuted(username)
    return self.mutedUsers[username] ~= nil
end

-- RJ : Do this because of some delay your last key entered in chat can pop a "KeyPressed"
ISChat.ontick = function()
    if ISChat.instance and ISChat.instance.timerTextEntry > 0 then
        ISChat.instance.timerTextEntry = ISChat.instance.timerTextEntry - 1;
        if ISChat.instance.timerTextEntry == 0 then
            doKeyPress(true);
        end
    end
end

ISChat.unfocusEvent = function()
    if ISChat.instance == nil then
        return;
    end

    ISChat.instance:unfocus();
end

function ISChat:RestoreLayout(name, layout)
    ISLayoutManager.DefaultRestoreWindow(self, layout)
    if layout.locked == 'false' then
        self.locked = false;
        self.lockButton:setImage(self.chatUnLockedButtonTexture);
    else
        self.locked = true;
        self.lockButton:setImage(self.chatLockedButtonTexture);
    end
    self:recalcSize();
end

function ISChat:SaveLayout(name, layout)
    ISLayoutManager.DefaultSaveWindow(self, layout)
    if self.locked then layout.locked = 'true' else layout.locked = 'false' end
end

ISChat.createChat = function()
    if not isClient() then
        return;
    end
    ISChat.chat = ISChat:new(15, getCore():getScreenHeight() - 400, 500, 200);
    ISChat.chat:initialise();
    ISChat.chat:addToUIManager();
    ISChat.chat:setVisible(true);
    ISChat.chat:bringToTop()
    ISLayoutManager.RegisterWindow('chat', ISChat, ISChat.chat)

    ISChat.instance:setVisible(true);

    Events.OnAddMessage.Add(ISChat.addLineInChat);
    Events.OnMouseDown.Add(ISChat.unfocusEvent);
    Events.OnKeyPressed.Add(ISChat.onToggleChatBox);
    Events.OnKeyKeepPressed.Add(ISChat.onKeyKeepPressed);
    Events.OnTabAdded.Add(ISChat.onTabAdded);
    Events.OnSetDefaultTab.Add(ISChat.onSetDefaultTab);
    Events.OnTabRemoved.Add(ISChat.onTabRemoved);
    Events.SwitchChatStream.Add(ISChat.onSwitchStream)
end

function logTo01(value)
    if value < 0.0 or value > 1.0 then
        error("only [0,1] accepted!");
    end
    if value > 0.0 then
        return math.log10(value * 100) - 1;
    end
    return 0.0;
end

__classmetatables[IsoPlayer.class]["__index"]["Callout"] = function(self, doEmote)
    local range = 30
    local shoutPath = "New"
    if getCore():getGameMode() == "Tutorial" then
        shoutPath = "Tutorial"
    elseif self:isSneaking() and not ISChat.instance.rpLanguage == "[ASL]" then
        range = 10
        shoutPath = "Sneak"
        processSayMessage(string.format('*156,108,108*' .. "%s" .. getText("UI_verb_whispershouts_roleplaychat") .. '"%s"', ISChat.instance.rpName, getText("IGUI_PlayerText_Callout"..ZombRand(1,4)..shoutPath)));
        addSound(self, self:getX(), self:getY(), self:getZ(), range, range);
    elseif ISChat.instance.rpLanguage ~= "[ASL]" then
        processShoutMessage(string.format('%s' .. getText("UI_callout_shouts_roleplaychat") .. '"%s"', ISChat.instance.rpName, getText("IGUI_PlayerText_Callout"..ZombRand(1,4)..shoutPath)));
        addSound(self, self:getX(), self:getY(), self:getZ(), range, range);
    else
        range = 10
        local msg = " waves their arms frantically!"
        if ZombRand(1,8) >= 4 then
            msg = " tries their hardest to be seen!"
        end
        local message = ISChat.instance.rpName .. " " .. msg
        processShoutMessage(message);
        addSound(self, self:getX(), self:getY(), self:getZ(), range, range);
    end
    if doEmote and not ISChat.instance.rpLanguage == "[ASL]" then
        self:playEmote("shout");
    else
        self:playEmote("wave");
    end
end

function escape_pattern(text)
    return text:gsub("([^%w])", "%%%1")
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function get_rpname()
	local charDesc = getPlayer():getDescriptor()
	local name = charDesc:getForename()
	return name;
end

function getLineLanguage(line, languages) 
    -- Figure out what language this message is in
    for lang in languages do
        if string.match(line, "%["..lang.."%]") then
            return lang
        end
    end

    return "Unknown"
end

-- to get a specific player's rpname
function get_rpname_specific(player)
    local charDesc = player:getDescriptor()
	local name = charDesc:getForename()
	return name;
end

-- function for getting our RGB color value and dividing it by 255 to be in the single digit zomboid RGB style
function inputSplit(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        match = match:gsub(" ", "") --no spaces
        match = match / 255
        table.insert(result, match);
    end
    return result;
end
function inputSplitDivisionless(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        match = match:gsub(" ", "") --no spaces
        table.insert(result, match);
    end
    return result;
end

function string.igmatch(str, pattern)
    local idx = 0
    local len = #str
    return function ()
        start, fin, match = str:find(pattern, idx)
        if not fin or idx >= len then return nil end
        idx = fin + 1
        return start, fin, match
    end
end

--[[
function AddTextInChat(text, tabTitle)
    local chatText
    for i, tab in ipairs(ISChat.instance.tabs) do
      if tab and tab.tabTitle == tabTitle then
        chatText = tab
        break
      end
    end
    if chatText.tabTitle ~= ISChat.instance.chatText.tabTitle then
        local alreadyExist = false;
        for i,blinkedTab in ipairs(ISChat.instance.panel.blinkTabs) do
            if blinkedTab == chatText.tabTitle then
                alreadyExist = true;
                break;
            end
        end
        if alreadyExist == false then
            table.insert(ISChat.instance.panel.blinkTabs, chatText.tabTitle);
        end
    end
    local vscroll = chatText.vscroll
    local scrolledToBottom = (chatText:getScrollHeight() <= chatText:getHeight()) or (vscroll and vscroll.pos == 1)
    if #chatText.chatTextLines > ISChat.maxLine then
        local newLines = {};
        for i,v in ipairs(chatText.chatTextLines) do
            if i ~= 1 then
                table.insert(newLines, v);
            end
        end
        table.insert(newLines, text .. " <LINE> ");
        chatText.chatTextLines = newLines;
    else
        table.insert(chatText.chatTextLines, text .. " <LINE> ");
    end
    chatText.text = ""
    local newText = ""
    for i, v in ipairs(chatText.chatTextLines) do
      if i == #chatText.chatTextLines then
        v = string.gsub(v, " <LINE> $", "")
      end
      newText = newText .. v
    end
    chatText.text = newText
    chatText:paginate()
    if scrolledToBottom then
        chatText:setYScroll(-10000);
    end
end
--]]


Events.OnGameStart.Add(ISChat.createChat);
Events.OnChatWindowInit.Add(ISChat.initChat)
