local GuiScale = 1
Tables = {}
TableNames = {}
StartTable = nil
CurrentTable = {}
CurrentModify = nil
StoredTables = {}--{["Opening"], ["StartTable"], ["CurrentTable"], ["TableNames"], ["Tables"], ["UpValue"]}
FoundLocations = {}
Searches = {}
Selected = nil
IsUpVal = false
IsConstant = false
IsProto = false
Opening = ""
local StartNumber = 13
function GetStartName(FT)
return string.sub(tostring(FT), StartNumber, StartNumber+6).."-"
end

Filters = {["number"] = true, ["function"] = true, ["boolean"] = true, ["string"] = true,
    ["Other"] = true, ["table"] = true, ["Instance"] = true, ["Name Search"] = true, ["Table Search"] = true,
["Upvalue Search"] = true, ["Value Search"] = true, ["Inside Upvalue"] = true, ["Constants Search"] = false, ["Exact Search"] = false}
Order = {"Name Search", "Table Search", "Upvalue Search", "Inside Upvalue", "Value Search", "Constants Search", "Exact Search", "boolean", "function", "Instance", "number", "Other", "string", "table"}
function GetTables(Last)
    if StartTable == nil then
        return {}
    end
if Last == -1 then
if #StoredTables > 0 then
local TempST = StoredTables[#StoredTables]
Opening = TempST["Opening"]
StartTable = TempST["StartTable"]
CurrentTable = TempST["CurrentTable"]
TableNames = TempST["TableNames"]
Tables = TempST["Tables"]
IsUpVal = TempST["UpValue"]
IsConstant = TempST["IsConstant"]
IsProto = TempST["IsProto"]
table.remove(StoredTables, #StoredTables)
if Searches[CurrentTable] ~= nil then
return Searches[CurrentTable]
end
return CurrentTable
end
elseif Last == 0 or Tables[Last] == nil then
CurrentTable = StartTable
Last = 0
else
CurrentTable = Tables[Last]
end
if Last < #Tables then
for i = 1, #Tables-Last do
    table.remove(TableNames, #Tables+1-i)
table.remove(Tables, #Tables+1-i)
end
end
if Searches[CurrentTable] ~= nil then
return Searches[CurrentTable]
end
    return CurrentTable
end

MDown = false
Mouse = game.Players.LocalPlayer:GetMouse()
FL = false
Mouse.KeyUp:connect(function(K)
    if string.byte(K) == 13 and FL == true then
        ETB.Text = ETB.Text.."\n"
        ETB:CaptureFocus()
    end
end)
function ConvertNumbers(X, Y)
TX = Mouse.ViewSizeX*X
TY = Mouse.ViewSizeY*Y
return TX, TY
end
function MoveableItem(item)
item.InputBegan:connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
MDown = true
CX, CY = ConvertNumbers(item.Position.X.Scale, item.Position.Y.Scale)
item.Position = UDim2.new(0, item.Position.X.Offset+CX, 0, item.Position.Y.Offset+CY)
StartX = Mouse.X - item.Position.X.Offset
StartY = Mouse.Y - item.Position.Y.Offset
while MDown == true do
item.Position = UDim2.new(0, Mouse.X - StartX, 0, Mouse.Y - StartY)
wait()
end
end
end)
item.InputEnded:connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
MDown = false
end
end)
end

MainScreenGui = Instance.new("ScreenGui")
if _G.GUI ~= nil then
   _G.GUI:remove()
end
_G.GUI = MainScreenGui

--Properties:

MainScreenGui.Name = "MainScreenGui"
MainScreenGui.Parent = game:GetService("CoreGui")
MainScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Viewer = Instance.new("Frame")
MoveableItem(Viewer)
Viewer.Name = "Viewer"
Viewer.Parent = MainScreenGui
Viewer.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
Viewer.BorderSizePixel = 0
Viewer.Position = UDim2.new(0.140625, 0, 0.240762815, 0)
Viewer.Size = UDim2.new(0.165*GuiScale, 0, 0.45*GuiScale, 0)
Viewer.ZIndex = 2

TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = Viewer
TopBar.BackgroundColor3 = Color3.fromRGB(108, 152, 255)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0.07, 0)

JustATextLabel = Instance.new("TextLabel")
JustATextLabel.Archivable = false
JustATextLabel.Parent = TopBar
JustATextLabel.BackgroundColor3 = Color3.fromRGB(108, 152, 255)
JustATextLabel.BackgroundTransparency = 0
JustATextLabel.BorderSizePixel = 0
JustATextLabel.Position = UDim2.new(0.2, 0, 0, 0)
JustATextLabel.Size = UDim2.new(0.6, 0, 1, 0)
JustATextLabel.Font = Enum.Font.SourceSans
JustATextLabel.Text = "Table Search"
JustATextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
JustATextLabel.TextScaled = true
JustATextLabel.TextSize = 14.000
JustATextLabel.TextWrapped = true

FilterOC = Instance.new("TextButton")
FilterOC.Parent = TopBar
FilterOC.BackgroundColor3 = Color3.fromRGB(158, 202, 255)
FilterOC.BorderSizePixel = 0
FilterOC.Position = UDim2.new(0, 0, 0, 0)
FilterOC.Size = UDim2.new(0.2, 0, 1, 0)
FilterOC.Font = Enum.Font.Code
FilterOC.Text = "Filter"
FilterOC.TextColor3 = Color3.fromRGB(0, 0, 0)
FilterOC.TextScaled = true
FilterOC.TextWrapped = true
FilterOC.MouseButton1Down:connect(function()
Filter.Visible = not Filter.Visible
Filter.Position = Viewer.Position - UDim2.new(0, 0, Filter.Size.Y.Scale, Filter.Size.Y.Offset+1)
if Filter.Visible == true then
FilterOC.BackgroundColor3 = Color3.fromRGB(108, 152, 255)
else
FilterOC.BackgroundColor3 = Color3.fromRGB(158, 202, 255)
end
end)

ConsoleOC = Instance.new("TextButton")
ConsoleOC.Parent = TopBar
ConsoleOC.BackgroundColor3 = Color3.fromRGB(158, 202, 255)
ConsoleOC.BorderSizePixel = 0
ConsoleOC.Position = UDim2.new(0.8, 0, 0, 0)
ConsoleOC.Size = UDim2.new(0.2, 0, 1, 0)
ConsoleOC.Font = Enum.Font.Code
ConsoleOC.Text = "Console"
ConsoleOC.TextColor3 = Color3.fromRGB(0, 0, 0)
ConsoleOC.TextScaled = true
ConsoleOC.TextWrapped = true
ConsoleOC.MouseButton1Down:connect(function()
ConsoleFrame.Visible = not ConsoleFrame.Visible
ConsoleFrame.Position = Viewer.Position - UDim2.new(Filter.Size.X.Scale*-1, (Filter.Size.X.Offset+1)*-1, Filter.Size.Y.Scale, Filter.Size.Y.Offset+1)
if ConsoleFrame.Visible == true then
ConsoleOC.BackgroundColor3 = Color3.fromRGB(108, 152, 255)
else
ConsoleOC.BackgroundColor3 = Color3.fromRGB(158, 202, 255)
end
end)

Searchs = Instance.new("Frame")
Searchs.Name = "Searchs"
Searchs.Parent = Viewer
Searchs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Searchs.BackgroundTransparency = 1.000
Searchs.Position = UDim2.new(0, 0, 0.0703296736, 0)
Searchs.Size = UDim2.new(1, 0, 0.129670337, 0)

TabSpot = Instance.new("TextBox")
TabSpot.Parent = Searchs
TabSpot.BackgroundColor3 = Color3.fromRGB(108, 152, 255)
TabSpot.BorderSizePixel = 0
TabSpot.Position = UDim2.new(0, 0, 0.0340000018, 0)
TabSpot.Size = UDim2.new(0.8, 0, 0.440677971, 0)
TabSpot.Font = Enum.Font.SourceSans
TabSpot.PlaceholderColor3 = Color3.fromRGB(59, 59, 59)
TabSpot.PlaceholderText = "Table"
TabSpot.Text = ""
TabSpot.TextColor3 = Color3.fromRGB(0, 0, 0)
TabSpot.TextSize = 21.000
TabSpot.TextScaled = true

Enter = Instance.new("TextButton")
Enter.Parent = TabSpot
Enter.BackgroundColor3 = Color3.fromRGB(73, 103, 173)
Enter.BorderSizePixel = 0
Enter.Position = UDim2.new(1, 0, 0, 0)
Enter.Size = UDim2.new(0.25, 0, 1, 0)
Enter.Font = Enum.Font.Code
Enter.Text = "Enter"
Enter.TextColor3 = Color3.fromRGB(0, 0, 0)
Enter.TextSize = 21.000
Enter.TextWrapped = true
Enter.TextScaled = true
Enter.MouseButton1Down:Connect(function()
Searches = {}
StoredTables = {}
Tables = {}
    TableNames = {}
IsUpValue = false
IsConstant = false
local SP = Specials(TabSpot.Text)
if SP ~= nil then
StartTable = SP
CurrentTable = SP
CurrentModify = nil
DisplayTab(StartTable)
return
end
    Opening = TabSpot.Text
    LT = loadstring("return "..TabSpot.Text)()
    StartTable = LT
    CurrentTable = LT
    CurrentModify = nil
CheckDebug(Opening)
    DisplayTab(StartTable)
end)

function Specials(IP)
local Tab = nil
if string.lower(IP) == "reg" then
Opening = "debug.getregistry()"
Tab = {}
for i, v in pairs(debug.getregistry()) do
if typeof(v) ~= "number" and typeof(v) ~= "thread" and (typeof(v) ~= "function" or is_synapse_function(v) ~= true) and tonumber(i) ~= nil then
Tab[i] = v
end
end
end
return Tab
end

function CheckDebug(Op)
if string.sub(Op, 1, 11) == "getupvalues" then
GetUpVals = true
elseif string.sub(Op, 1, 18) == "debug.getconstants" then
IsConstant = true
elseif string.sub(Op, 1, 15) == "debug.getprotos" then
IsProto = true
end
end

SearchT = Instance.new("TextBox")
SearchT.Name = "TextBox2"
SearchT.Parent = Searchs
SearchT.BackgroundColor3 = Color3.fromRGB(108, 152, 255)
SearchT.BorderSizePixel = 0
SearchT.Position = UDim2.new(0, Enter.AbsoluteSize.X, 0.5, 0)
SearchT.Size = UDim2.new(1, -Enter.AbsoluteSize.X*2, 0.440677971, 0)
SearchT.Font = Enum.Font.SourceSans
SearchT.PlaceholderColor3 = Color3.fromRGB(63, 70, 88)
SearchT.PlaceholderText = "Search in table"
SearchT.Text = ""
SearchT.TextColor3 = Color3.fromRGB(0, 0, 0)
SearchT.TextSize = 21.000
SearchT.TextWrapped = true
SearchT.TextScaled = true

ClearSearch = Instance.new("TextButton")
ClearSearch.Parent = SearchT
ClearSearch.BackgroundColor3 = Color3.fromRGB(73, 103, 173)
ClearSearch.BorderSizePixel = 0
ClearSearch.Position = UDim2.new(0, -Enter.AbsoluteSize.X, 0, 0)
ClearSearch.Size = UDim2.new(0, Enter.AbsoluteSize.X, 1, 0)
ClearSearch.Font = Enum.Font.Code
ClearSearch.Text = "Clear"
ClearSearch.TextColor3 = Color3.fromRGB(0, 0, 0)
ClearSearch.TextSize = 21.000
ClearSearch.TextWrapped = true
ClearSearch.TextScaled = true
ClearSearch.MouseButton1Down:connect(function()
if Searches[CurrentTable] ~= nil then
Searches[CurrentTable] = nil
end
DisplayTab(CurrentTable)
end)


SearchE = Instance.new("TextButton")
SearchE.Parent = SearchT
SearchE.BackgroundColor3 = Color3.fromRGB(73, 103, 173)
SearchE.BorderSizePixel = 0
SearchE.Position = UDim2.new(1, 0, 0, 0)
SearchE.Size = UDim2.new(0, Enter.AbsoluteSize.X, 1, 0)
SearchE.Font = Enum.Font.Code
SearchE.Text = "Find"
SearchE.TextColor3 = Color3.fromRGB(0, 0, 0)
SearchE.TextSize = 21.000
SearchE.TextWrapped = true
SearchE.TextScaled = true
SearchE.MouseButton1Down:connect(function()
local FoundTables = {}
    local TempTable = {}
    local LF = string.lower(SearchT.Text)
for i, v in pairs(CurrentTable) do
if Filters["Name Search"] == true and ((Filters["Exact Search"] ~= true and string.match(string.lower(tostring(i)), LF)) or (Filters["Exact Search"] == true and tostring(i) == SearchT.Text)) or Filters["Value Search"] == true and ((Filters["Exact Search"] ~= true and string.match(string.lower(tostring(v)), LF)) or (Filters["Exact Search"] == true and tostring(v) == SearchT.Text)) then
TempTable[i] = v
elseif typeof(v) == "table" and Filters["Table Search"] == true then
SearchTable(TempTable, v, v, LF, i, 0, tostring(v))
elseif typeof(v) == "function" and (Filters["Upvalue Search"] == true or Filters["Constants Search"] == true and Filters["Value Search"] == true) then
if Filters["Upvalue Search"] == true then
SearchTable(TempTable, v, getupvalues(v), LF, i, 0, "getupvalues("..tostring(v)..")", SearchT.Text)
end
if Filters["Constants Search"] == true and Filters["Value Search"] == true and islclosure(v) == true then
SearchTable(TempTable, v, debug.getconstants(v), LF, i, 0, "debug.getconstants("..tostring(v)..")", SearchT.Text)
end
end
end
Searches[CurrentTable] = TempTable
    DisplayTab(TempTable)
end)
local MaxDepth = 5
function SearchTable(StartingTable, StartingTable2, ToSearch, SearchValue, CTableName, Depth, CurrentString, ES)
if Depth >= MaxDepth or  CTableName ~= nil and StartingTable[CTableName] ~= nil then
return
end
for i, v in pairs(ToSearch) do
if (Filters["Name Search"] == true and (Filters["Exact Search"] == false and string.match(string.lower(tostring(i)), SearchValue) or Filters["Exact Search"] == true and tostring(i) == ES) or Filters["Value Search"] == true and (Filters["Exact Search"] == false and string.match(string.lower(tostring(v)), SearchValue) or Filters["Exact Search"] == true and tostring(v) == ES)) and (Filters[typeof(v)] == true or Filters[typeof(v)] == nil and Filters["Other"] == true) then
StartingTable[CTableName] = StartingTable2
CurrentString = CurrentString.."["..tostring(i).."] ("..tostring(typeof(v))
if string.match(string.lower(tostring(i)), SearchValue) and Filters["Name Search"] == true then
CurrentString = CurrentString..") - Name Search"
else
CurrentString = CurrentString..", '"..tostring(v).."') - Value Search"
end
FoundLocations[StartingTable2] = CurrentString
return
elseif typeof(v) == "table" and v ~= ToSearch then
SearchTable(StartingTable, StartingTable2, v, SearchValue, CTableName, Depth + 1, CurrentString.."["..tostring(i).."]", ES)
elseif typeof(v) == "function" and (Filters["Inside Upvalue"] == true or Filters["Constants Search"] == true and Filters["Value Search"] == true) then
if Filters["Inside Upvalue"] == true then
SearchTable(StartingTable, StartingTable2, getupvalues(v), SearchValue, CTableName, Depth + 1, "getupvalues("..CurrentString.."["..tostring(i).."])", ES)
end
if Filters["Constants Search"] == true and Filters["Value Search"] == true and islclosure(v) == true then
SearchTable(StartingTable, StartingTable2, debug.getconstants(v), SearchValue, CTableName, Depth + 1, "debug.getconstants("..CurrentString.."["..tostring(i).."])", ES)
end
end
end
end

Scroll = Instance.new("ScrollingFrame")
Scroll.Name = "Tables"
Scroll.Parent = Viewer
Scroll.Active = true
Scroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Scroll.BackgroundTransparency = 1.000
Scroll.BorderSizePixel = 0
Scroll.Position = UDim2.new(0, 0, 0.208010629, 0)
Scroll.Size = UDim2.new(1, 0, 0.707692325, 0)
Scroll.ScrollBarThickness = 0
ScrollTab = {}

DisplayTextFunction = Instance.new("TextButton")
DisplayTextFunction.Parent = Scroll
DisplayTextFunction.BackgroundColor3 = Color3.fromRGB(108, 152, 255)
DisplayTextFunction.BorderSizePixel = 0
DisplayTextFunction.Size = UDim2.new(0.768, 0, 0, 31)
DisplayTextFunction.Font = Enum.Font.Code
DisplayTextFunction.Text = "Test"
DisplayTextFunction.TextColor3 = Color3.fromRGB(0, 0, 0)
DisplayTextFunction.TextScaled = true  
DisplayTextFunction.Visible = false

DisplayText = Instance.new("TextButton")
DisplayText.Parent = Scroll
DisplayText.BackgroundColor3 = Color3.fromRGB(108, 152, 255)
DisplayText.BorderSizePixel = 0
DisplayText.Size = UDim2.new(0.96, 0, 0, 31)
DisplayText.Font = Enum.Font.Code
DisplayText.Text = "Test"
DisplayText.TextColor3 = Color3.fromRGB(0, 0, 0)
DisplayText.TextScaled = true  
DisplayText.Visible = false

GetPathButton = Instance.new("TextButton")
GetPathButton.Name = "GetPath"
GetPathButton.Parent = DisplayTextFunction
GetPathButton.BackgroundColor3 = Color3.fromRGB(73, 103, 173)
GetPathButton.BorderSizePixel = 0
GetPathButton.Position = UDim2.new(1, 0, 0, 0)
GetPathButton.Size = UDim2.new(0.25, 0, 1, 0)
GetPathButton.Font = Enum.Font.Code
GetPathButton.Text = "GetPath"
GetPathButton.TextColor3 = Color3.fromRGB(0, 0, 0)
GetPathButton.TextSize = 21.000
GetPathButton.TextWrapped = true
GetPathButton.TextScaled = true

function ClearTab()
    for i = 1, #ScrollTab do
        ScrollTab[i]:remove()
    end
    ScrollTab = {}
end
Ignores = {["thread"] = true}
function DisplayTab(Tab)
    ClearTab()
local Count = 0
    for i, v in pairs(Tab) do
if Ignores[typeof(v)] == nil and (Filters[typeof(v)] == true or Filters[typeof(v)] == nil and Filters["Other"] == true) then
if Count >= 4000 then
spawn(function()
JustATextLabel.Text = "Table Search - Warning over 4K items!"
wait(3)
JustATextLabel.Text = "Table Search"
end)
break
end
Count = Count + 1
local Button = nil
if typeof(v) == "function" or typeof(v) == "table" then
Button = DisplayTextFunction:Clone()
else
Button = DisplayText:Clone()
end
Button.Visible = true
Button.Parent = Scroll
Button.Position = UDim2.new(0.02, 0, 0, 34*#ScrollTab)
table.insert(ScrollTab, Button)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 34*(#ScrollTab+1))
Button.Text = tostring(i).." : "..tostring(typeof(v))
Button.MouseButton1Down:connect(function()
Selected = v
if typeof(v) == "table" then
table.insert(Tables, v)
if typeof(i) == "string" then
table.insert(TableNames, '"'..i..'"')
else
table.insert(TableNames, i)
end
CurrentTable = v
DisplayTab(v)
else
Editor.Visible = true
Editor.Position = Viewer.Position+UDim2.new(Viewer.Size.X.Scale, Viewer.Size.X.Offset+1, 0, 0)
CurrentModify = i
if typeof(v) == "function" then
ETB.Text = "function MainFunction(...) \nargs = {...}\n\nreturn _G[\""..GetStartName(v)..tostring(CurrentModify).."\"](unpack(args))\nend"
elseif typeof(v) == "Instance" then
_G.CurrentObject = v
ETB.Text = "local Object = _G.CurrentObject--"..tostring(v.ClassName).."\n"
else
ETB.Text = tostring(v)
end
EditorMode(typeof(v))
end
end)
if Button:FindFirstChild("GetPath") then
Button.GetPath.MouseButton1Down:connect(function()
if FoundLocations[v] ~= nil then
CPrint("Location: "..tostring(i)..": "..tostring(FoundLocations[v]))
end
end)
end
if typeof(v) ~= "table" then
Button.Text = Button.Text.." : "..tostring(v)
end
end
    end
end

--[[
UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Scroll
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 3)]]--

Back = Instance.new("TextButton")
Back.Name = "Back"
Back.Parent = Viewer
Back.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
Back.BackgroundTransparency = 0.900
Back.BorderSizePixel = 0
Back.Position = UDim2.new(0, 0, 0.915, 0)
Back.Size = UDim2.new(0.155, 0, 0.085, 0)
Back.Font = Enum.Font.SourceSans
Back.Text = "<="
Back.TextColor3 = Color3.fromRGB(255, 255, 255)
Back.TextScaled = true
Back.TextSize = 21.000
Back.TextWrapped = true
Back.MouseButton1Down:connect(function()
    DisplayTab(GetTables(#Tables-1))
end)

DisplayLocation = Instance.new("TextButton")
DisplayLocation.Name = "DisplayLocation"
DisplayLocation.Parent = Viewer
DisplayLocation.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
DisplayLocation.BackgroundTransparency = 0.900
DisplayLocation.BorderSizePixel = 0
DisplayLocation.Position = UDim2.new(0.155, 0, 0.915, 0)
DisplayLocation.Size = UDim2.new(0.845, 0, 0.085, 0)
DisplayLocation.Font = Enum.Font.SourceSans
DisplayLocation.Text = "TempNothingHere"
DisplayLocation.TextColor3 = Color3.fromRGB(255, 255, 255)
DisplayLocation.TextScaled = true
DisplayLocation.TextSize = 21.000
DisplayLocation.TextWrapped = true
DisplayLocation.MouseButton1Down:connect(function()
setclipboard(DisplayLocation.Text)
end)
spawn(function()
local TableNumber = 0
local LastOpen = Opening
while wait(0.1) do
if TableNumber ~= #Tables or LastOpen ~= Opening then
TableNumber = #Tables
LastOpen = Opining
pcall(function()
DisplayLocation.Text = GetSpecialIE(Opening, false)
end)
end
end
end)

function EditorMode(M)
EditorFunction.Visible = false
if M == "function" or M == "Instance" then
Editor.Size = UDim2.new(Viewer.Size.X.Scale*1.45, 0, Viewer.Size.Y.Scale, 0)
if M == "function" then
EditorFunction.Visible = true
end
else
Editor.Size = UDim2.new(Viewer.Size.X.Scale*0.65, 0, Viewer.Size.Y.Scale*0.35, 0)
end
end

Editor = Instance.new("Frame")
Editor.Name = "Editor"
Editor.Parent = MainScreenGui
Editor.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
Editor.BorderSizePixel = 0
Editor.Position = UDim2.new(0.323958337, 0, 0.240762815, 0)
Editor.Size = UDim2.new(Viewer.Size.X.Scale*1.45, 0, Viewer.Size.Y.Scale, 0)
Editor.Visible = false
MoveableItem(Editor)

EditorFunction = Instance.new("Frame", Editor)
EditorFunction.Name = "EditorFunction"
EditorFunction.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
EditorFunction.BorderSizePixel = 0
EditorFunction.Position = UDim2.new(0, 0, 1, 0)
EditorFunction.Size = UDim2.new(1, 0, 0.1, 0)
EditorFunction.Visible = false

TopBarEditor = Instance.new("Frame")
TopBarEditor.Name = "TopBarEditor"
TopBarEditor.Parent = Editor
TopBarEditor.BackgroundColor3 = Color3.fromRGB(108, 152, 255)
TopBarEditor.BorderSizePixel = 0
TopBarEditor.Size = UDim2.new(1, 0, 0, 0.07*Viewer.AbsoluteSize.Y+1)

TextLabel_2 = Instance.new("TextLabel")
TextLabel_2.Parent = TopBarEditor
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.BackgroundTransparency = 1.000
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Position = UDim2.new(0, 0, 0, 0)
TextLabel_2.Size = UDim2.new(1, 0, 1, 0)
TextLabel_2.Font = Enum.Font.SourceSans
TextLabel_2.Text = "Editor"
TextLabel_2.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_2.TextScaled = true
TextLabel_2.TextWrapped = true

Close = Instance.new("TextButton", Editor)
Close.Size = UDim2.new(0, 0.07*Viewer.AbsoluteSize.Y+1, 0, 0.07*Viewer.AbsoluteSize.Y+1)
Close.Position = UDim2.new(1, -(0.07*Viewer.AbsoluteSize.Y+1), 0, 0)
Close.BackgroundColor3 = Color3.new(0, 0, 0)
Close.TextColor3 = Color3.new(1, 1, 1)
Close.TextScaled = true
Close.Text = "X"
Close.BorderSizePixel = 0
Close.MouseButton1Down:connect(function()
    Editor.Visible = false
end)

ScrollSize = 1500
ETBScroll = Instance.new("ScrollingFrame")
ETBScroll.Parent = Editor
ETBScroll.Active = true
ETBScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ETBScroll.BackgroundTransparency = 1.000
ETBScroll.BorderSizePixel = 0
ETBScroll.Position = UDim2.new(0, 0, 0, 0.07*Viewer.AbsoluteSize.Y+1)
ETBScroll.Size = UDim2.new(1, 0, 0.89, -(0.07*Viewer.AbsoluteSize.Y+1))
ETBScroll.ScrollBarThickness = 0
ETBScroll.CanvasSize = UDim2.new(0, 0, 0, ScrollSize)

function GetSize(Text, FontSize, Font, XSize, MaxY)
    if typeof(Font) == "string" then
        Font = Enum.Font[Font]
    end
    local Val = game:GetService("TextService"):GetTextSize(Text, FontSize, Font, Vector2.new(XSize, MaxY*FontSize))
    return Vector2.new(XSize, Val.Y)
end

function DeterminLine()
    Pos = ETB.CursorPosition
local TempSTR = string.sub(ETB.Text, 1, Pos-1)
local SSize = GetSize(TempSTR, 20, "SourceSans", Editor.Size.X.Offset, ScrollSize/20)
Line = SSize.Y/20
    return Line
end

ETB = Instance.new("TextBox")
ETB.Parent = ETBScroll
ETB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ETB.BackgroundTransparency = 1.000
ETB.Size = UDim2.new(0.99, 0, 0, ScrollSize)
ETB.Position = UDim2.new(0.005, 0, 0, 0)
ETB.Font = Enum.Font.SourceSans
ETB.MultiLine = true
ETB.PlaceholderText = "Change goes here, if it is a function do something like function Test(...) return 'Test' end \nIf you are modifying a function please make sure the main function is named MainFunction."
ETB.Text = ""
ETB.TextColor3 = Color3.fromRGB(255, 255, 255)
ETB.TextSize = 20.000
ETB.TextWrapped = true
ETB.TextXAlignment = Enum.TextXAlignment.Left
ETB.TextYAlignment = Enum.TextYAlignment.Top
ETB.ClearTextOnFocus = false
ETB:GetPropertyChangedSignal("Text"):connect(function()
    local Spot = DeterminLine()
    if Spot > 16 and ETB:IsFocused() == true then
        ETBScroll.CanvasPosition = Vector2.new(0, 20*(Spot-16))
else
        ETBScroll.CanvasPosition = Vector2.new(0, 0)
    end
end)

function GetIE()
    local IE = Opening
    for i = 1, #Tables do
        IE = IE..'['..TableNames[i]..']'
    end
    if CurrentModify ~= nil then
if CurrentTable[tostring(CurrentModify)] ~= nil then
IE = IE..'["'..tostring(CurrentModify)..'"]'
else
IE = IE..'['..tostring(CurrentModify)..']'
end
end
    return IE
end

function GetSpecialIE(Open, Val)
    local IE = Open
    for i = 1, #Tables do
        IE = IE..'['..TableNames[i]..']'
    end
if Val == true then
if CurrentTable[tostring(CurrentModify)] ~= nil then
IE = IE..', "'..tostring(CurrentModify)..'"'
else
IE = IE..', '..tostring(CurrentModify)
end
end
    return IE
end

Apply = Instance.new("TextButton")
Apply.Name = "Apply"
Apply.Parent = Editor
Apply.BackgroundColor3 = Color3.fromRGB(108, 152, 255)
Apply.BorderSizePixel = 0
Apply.Position = UDim2.new(0, 0, 0.89, 0)
Apply.Size = UDim2.new(1, 0, 0.1, 0)
Apply.Font = Enum.Font.SourceSans
Apply.Text = "Apply"
Apply.TextColor3 = Color3.fromRGB(0, 0, 0)
Apply.TextSize = 21.000
Apply.TextScaled = true
Apply.MouseButton1Down:connect(function()
    local IE = GetIE()
    local TP = typeof(CurrentTable[CurrentModify])
    if TP == "function" then
        if _G[GetStartName(CurrentTable[CurrentModify])..tostring(CurrentModify)] == nil then
            _G[GetStartName(CurrentTable[CurrentModify])..tostring(CurrentModify)] = hookfunction(CurrentTable[CurrentModify], function(...)
                return _G[GetStartName(CurrentTable[CurrentModify])..tostring(CurrentModify)](...)
            end)
        end
        local TempFunction = loadstring(ETB.Text.." return MainFunction")()
        if TempFunction ~= nil then
            hookfunction(CurrentTable[CurrentModify], TempFunction)
        end
    end
if (IsUpVal ~= true and IsConstant ~= true and IsProto ~= true or #Tables > 0) and TP ~= "function" then
if TP == "string" then
SetThing(IE, '"'..ETB.Text..'"')
elseif TP == "CFrame" or TP == "Vector3" or TP == "Color3" or TP == "Ray" then
SetThing(IE, TP..".new("..ETB.Text..")")
elseif TP == "BrickColor" then
SetThing(IE, TP..'.new("'..ETB.Text..'")')
elseif TP == "Instance" then
if typeof(CurrentModify) == "Instance" then
IE = GetSpecialIE(Opening, false).."[_G.CurrentObject]"
end
LS(ETB.Text.."\n"..IE.." = Object")
else
SetThing(IE, ETB.Text)
end
elseif (IsUpVal == true or IsConstant == true or IsProto == true) and TP ~= "function" then
local Start = GetSpecialIE(Opening, false)
local Leng = 13
local SMode = "UpVal"
if IsConstant == true then
Leng = 20
SMode = "Constant"
elseif IsProto == true then
SMode = "Proto"
Leng = 17
end
if string.sub(Start, string.len(Start), string.len(Start)) == ")" then
Start = GetSpecialIE(string.sub(Opening, Leng, string.len(Opening)-1), true)
else
Start = GetSpecialIE(Opening, true)
end
if TP == "string" then
SetThing(Start, '"'..ETB.Text..'"', SMode)
elseif TP == "CFrame" or TP == "Vector3" or TP == "Color3" or TP == "Ray" or TP == "UDim2" then
SetThing(Start, TP..".new("..ETB.Text..")", SMode)
elseif TP == "BrickColor" then
SetThing(Start, TP..'.new("'..ETB.Text..'")', SMode)
elseif TP == "Instance" then
if IsUpVal == true then
LS(ETB.Text.."\nsetupvalue("..Start..", Object)")
elseif IsConstant == true then
LS(ETB.Text.."\ndebug.getconstants("..Start..", Object)")
else
LS(ETB.Text.."\ndebug.getprotos("..Start..", Object)")
end
else
SetThing(Start, ETB.Text, SMode)
end
local TempStartTable = LS("return "..Opening)
if TempStartTable ~= nil then
StartTable = TempStartTable
CurrentTable = StartTable
end
end
DisplayTab(CurrentTable)
end)

function SetThing(Thing, Arg, Val)
if Val == "UpVal" then
LS("setupvalue("..Thing..", "..Arg..")")
elseif Val == "Constant" then
LS("debug.setconstant("..Thing..", "..Arg..")")
elseif Val == "Proto" then
LS("debug.setproto("..Thing..", "..Arg..")")
else
LS(Thing.." = "..Arg)
end
end

function LS(LTE)
local Worked,  PossibleError = pcall(function()
return loadstring(LTE)()
end)
if Worked == false then
CError("\n--[["..tostring(PossibleError).."\n"..LTE.."]]--")
else
return PossibleError
end
end

DebugMode = Instance.new("TextButton")
DebugMode.Name = "DebugMode"
DebugMode.Parent = EditorFunction
DebugMode.BackgroundColor3 = Color3.fromRGB(108, 152, 255)
DebugMode.BorderSizePixel = 0
DebugMode.Position = UDim2.new(0, 0, 0, 0)
DebugMode.Size = UDim2.new(0.25, 0, 1, 0)
DebugMode.Font = Enum.Font.SourceSans
DebugMode.Text = "Setup\nDebug"
DebugMode.TextColor3 = Color3.fromRGB(0, 0, 0)
DebugMode.TextSize = 21.000
DebugMode.TextWrapped = true
DebugMode.TextScaled = true
DebugMode.MouseButton1Down:connect(function()
    if typeof(CurrentTable[CurrentModify]) == "function" then
        ETB.Text = "function MainFunction(...) \nargs = {...}\nCPrint('-----"..tostring(CurrentModify).."-----')\nCPrint('{'..GetValues(args)..'}')\nlocal R = _G[\""..GetStartName(CurrentTable[CurrentModify])..tostring(CurrentModify).."\"](unpack(args)) \nCPrint('--return: '..tostring(R)..' : '..typeof(R))\n\nreturn R\nend"
    end
end)

GetUpVals = Instance.new("TextButton")
GetUpVals.Name = "GetUpVals"
GetUpVals.Parent = EditorFunction
GetUpVals.BackgroundColor3 = Color3.fromRGB(108, 152, 255)
GetUpVals.BorderSizePixel = 0
GetUpVals.Position = UDim2.new(0.25, 0, 0, 0)
GetUpVals.Size = UDim2.new(0.25, 0, 1, 0)
GetUpVals.Font = Enum.Font.SourceSans
GetUpVals.Text = "Get\nUpvalues"
GetUpVals.TextColor3 = Color3.fromRGB(0, 0, 0)
GetUpVals.TextSize = 21.000
GetUpVals.TextWrapped = true
GetUpVals.TextScaled = true
GetUpVals.MouseButton1Down:connect(function()
if typeof(CurrentTable[CurrentModify]) == "function" then
local TB = MakeTempTable()
local TempOpening = "getupvalues("..GetIE()..")"
if StartOpening(TempOpening) then
table.insert(StoredTables, TB)
IsUpVal = true
IsConstant = false
IsProto = false
Opening = TempOpening
end
--{["StartTable"], ["CurrentTable"], ["TableNames"], ["Tables"], ["UpValue"], ["IsConstant"]}
end
end)

GetConst = Instance.new("TextButton")
GetConst.Name = "GetConst"
GetConst.Parent = EditorFunction
GetConst.BackgroundColor3 = Color3.fromRGB(108, 152, 255)
GetConst.BorderSizePixel = 0
GetConst.Position = UDim2.new(0.5, 0, 0, 0)
GetConst.Size = UDim2.new(0.25, 0, 1, 0)
GetConst.Font = Enum.Font.SourceSans
GetConst.Text = "Get\nConstants"
GetConst.TextColor3 = Color3.fromRGB(0, 0, 0)
GetConst.TextSize = 21.000
GetConst.TextWrapped = true
GetConst.TextScaled = true
GetConst.MouseButton1Down:connect(function()
if typeof(CurrentTable[CurrentModify]) == "function" and islclosure(CurrentTable[CurrentModify]) == true then
local TB = MakeTempTable()
local TempOpening = "debug.getconstants("..GetIE()..")"
if StartOpening(TempOpening) then
table.insert(StoredTables, TB)
IsUpVal = false
IsConstant = true
IsProto = false
Opening = TempOpening
end
end
end)

GetProto = Instance.new("TextButton")
GetProto.Name = "GetProto"
GetProto.Parent = EditorFunction
GetProto.BackgroundColor3 = Color3.fromRGB(108, 152, 255)
GetProto.BorderSizePixel = 0
GetProto.Position = UDim2.new(0.75, 0, 0, 0)
GetProto.Size = UDim2.new(0.25, 0, 1, 0)
GetProto.Font = Enum.Font.SourceSans
GetProto.Text = "Get\nProtos"
GetProto.TextColor3 = Color3.fromRGB(0, 0, 0)
GetProto.TextSize = 21.000
GetProto.TextWrapped = true
GetProto.TextScaled = true
GetProto.MouseButton1Down:connect(function()
if typeof(CurrentTable[CurrentModify]) == "function" and islclosure(CurrentTable[CurrentModify]) == true then
local TB = MakeTempTable()
local TempOpening = "debug.getprotos("..GetIE()..")"
if StartOpening(TempOpening) then
table.insert(StoredTables, TB)
IsUpVal = false
IsConstant = false
IsProto = true
Opening = TempOpening
end
end
end)

function MakeTempTable()
local TempST = {}
TempST["StartTable"] = StartTable
TempST["CurrentTable"] = CurrentTable
TempST["TableNames"] = TableNames
TempST["Tables"] = Tables
TempST["UpValue"] = IsUpVal
TempST["Opening"] = Opening
TempST["IsConstant"] = IsConstant
TempST["IsProto"] = IsProto
return TempST
end

function StartOpening(OpeningHere)
LT = LS("return "..OpeningHere)
if LT == nil then
return false
end
local Number = 0
for i, v in pairs(LT) do
Number = Number + 1
break
end
if Number < 1 then
return false
end
StartTable = LT
CurrentTable = LT
CurrentModify = nil
Tables = {}
TableNames = {}
DisplayTab(StartTable)
return true
--{["StartTable"], ["CurrentTable"], ["TableNames"], ["Tables"], ["UpValue"], ["IsConstant"], ["IsProto"]}
end

Filter = Instance.new("Frame")
Filter.Parent = MainScreenGui
Filter.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
Filter.BorderSizePixel = 0
Filter.Position = UDim2.new(0.4765625, 0, 0.2407628, 0)
Filter.Size = UDim2.new(Viewer.Size.X.Scale*0.756, 0, Viewer.Size.Y.Scale*0.65, 0)
Filter.Visible = false
MoveableItem(Filter)

FilterButton = Instance.new("TextButton")
FilterButton.Parent = Filter
FilterButton.BackgroundColor3 = Color3.fromRGB(108, 152, 255)
FilterButton.BorderSizePixel = 0
FilterButton.Position = UDim2.new(0.0996015966, 0, 0.825002134, 0)
FilterButton.Size = UDim2.new(0.796812773, 0, 0.140562251, 0)
FilterButton.Font = Enum.Font.SourceSans
FilterButton.Text = "Filter"
FilterButton.TextColor3 = Color3.fromRGB(0, 0, 0)
FilterButton.TextSize = 21.000
FilterButton.TextScaled = true
FilterButton.MouseButton1Down:connect(function()
DisplayTab(CurrentTable)
end)

FilterFrame = Instance.new("Frame")
FilterFrame.Parent = Filter
FilterFrame.BackgroundColor3 = Color3.fromRGB(108, 152, 255)
FilterFrame.BorderSizePixel = 0
FilterFrame.Size = UDim2.new(1, 0, 0.11, 0)

FilterLabel = Instance.new("TextLabel")
FilterLabel.Parent = FilterFrame
FilterLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FilterLabel.BackgroundTransparency = 1.000
FilterLabel.BorderSizePixel = 0
FilterLabel.Size = UDim2.new(1, 0, 1, 0)
FilterLabel.Font = Enum.Font.SourceSans
FilterLabel.Text = "Filter"
FilterLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
FilterLabel.TextScaled = true
FilterLabel.TextSize = 21.000
FilterLabel.TextWrapped = true
FilterLabel.TextScaled = true

FilterClose = Instance.new("TextButton", FilterLabel)
FilterClose.Size = UDim2.new(0, FilterLabel.AbsoluteSize.Y, 1, 0)
FilterClose.Position = UDim2.new(1, -(FilterLabel.AbsoluteSize.Y), 0, 0)
FilterClose.BackgroundColor3 = Color3.new(0, 0, 0)
FilterClose.TextColor3 = Color3.new(1, 1, 1)
FilterClose.TextScaled = true
FilterClose.Text = "X"
FilterClose.BorderSizePixel = 0
FilterClose.MouseButton1Down:connect(function()
    Filter.Visible = false
end)

FilterScroll = Instance.new("ScrollingFrame")
FilterScroll.Parent = Filter
FilterScroll.Active = true
FilterScroll.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
FilterScroll.BorderSizePixel = 0
FilterScroll.Position = UDim2.new(0, 0, 0.164658636, 0)
FilterScroll.Size = UDim2.new(1, 0, 0.570281148, 0)
FilterScroll.ScrollBarThickness = 0

FilterLayout = Instance.new("UIListLayout")
FilterLayout.Parent = FilterScroll
FilterLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
FilterLayout.SortOrder = Enum.SortOrder.LayoutOrder
FilterLayout.Padding = UDim.new(0, 3)

TempFilterButton = Instance.new("TextButton")
TempFilterButton.Parent = FilterScroll
TempFilterButton.BackgroundColor3 = Color3.fromRGB(132, 182, 255)
TempFilterButton.BorderSizePixel = 0
TempFilterButton.Size = UDim2.new(1, 0, 0, FilterLabel.AbsoluteSize.Y)
TempFilterButton.Font = Enum.Font.SourceSans
TempFilterButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TempFilterButton.TextSize = 14.000
TempFilterButton.Visible = false
TempFilterButton.TextScaled = true
FilterTab = {}

for a = 1, #Order do
local i = Order[a]
local v = Filters[i]
local Button = TempFilterButton:Clone()
    Button.Visible = true
    Button.Parent = FilterScroll
    Button.Text = tostring(i).." : "..tostring(v)
    Button.Position = UDim2.new(0, 0, 0, FilterLabel.AbsoluteSize.Y*(#FilterScroll:GetChildren()-2))
    FilterScroll.CanvasSize = UDim2.new(0, 0, 0, (FilterLabel.AbsoluteSize.Y+3)*(#FilterScroll:GetChildren()-2))
    FilterTab[tostring(i)] = Button
if v == false then
FilterTab[tostring(i)].BackgroundColor3 = Color3.fromRGB(108, 152, 255)
end
    Button.MouseButton1Down:connect(function()
        Filters[i] = not Filters[i]
        for i, v in pairs(Filters) do
            FilterTab[tostring(i)].Text = tostring(i).." : "..tostring(v)
FilterTab[tostring(i)].BackgroundColor3 = Color3.fromRGB(132, 182, 255)
if v == false then
FilterTab[tostring(i)].BackgroundColor3 = Color3.fromRGB(108, 152, 255)
end
        end
    end)
end

ConsoleFrame = Instance.new("Frame", MainScreenGui)
ConsoleFrame.Size = UDim2.new(Editor.Size.X.Scale+Viewer.Size.X.Scale-Filter.Size.X.Scale, 0, Filter.Size.Y.Scale, 0)
ConsoleFrame.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
ConsoleFrame.BorderSizePixel = 0
ConsoleFrame.Position = UDim2.new(0.6, 0, 0, 0)
ConsoleFrame.Visible = false
MoveableItem(ConsoleFrame)

ConsoleBar = Instance.new("TextLabel")
ConsoleBar.Parent = ConsoleFrame
ConsoleBar.BackgroundColor3 = Color3.fromRGB(108, 152, 255)
ConsoleBar.BorderSizePixel = 0
ConsoleBar.Size = UDim2.new(1, 0, 0, 32)
ConsoleBar.Text = "Console"
ConsoleBar.TextScaled = true
ConsoleBar.Font = Enum.Font.SourceSans

ConsoleClose = Instance.new("TextButton", ConsoleBar)
ConsoleClose.Size = UDim2.new(0, 32, 0, 32)
ConsoleClose.Position = UDim2.new(1, -32, 0, 0)
ConsoleClose.BackgroundColor3 = Color3.new(0, 0, 0)
ConsoleClose.TextColor3 = Color3.new(1, 1, 1)
ConsoleClose.TextScaled = true
ConsoleClose.Text = "X"
ConsoleClose.BorderSizePixel = 0
ConsoleClose.MouseButton1Down:connect(function()
    ConsoleFrame.Visible = false
end)

ConsoleScrollFrame = Instance.new("ScrollingFrame", ConsoleFrame)
ConsoleScrollFrame.Name = "Test"
ConsoleScrollFrame.Size = UDim2.new(1, 0, 1, -48)
ConsoleScrollFrame.Position = UDim2.new(0, 0, 0, 40)
ConsoleScrollFrame.BackgroundColor3 = Color3.new(100/255, 150/255, 1)
ConsoleScrollFrame.BackgroundTransparency = 0.5
ConsoleScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ScrollSize)
ConsoleScrollFrame.ScrollBarThickness = 0
ConsoleScrollFrame.BorderSizePixel = 0
ConsoleScrollFrame.BackgroundTransparency = 1.000
ConsoleScrollFrame.CanvasPosition = Vector2.new(0, ScrollSize)

ConsoleFrameUIListLayout = Instance.new("UIListLayout")
ConsoleFrameUIListLayout.Parent = ConsoleScrollFrame
ConsoleFrameUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
ConsoleFrameUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
ConsoleFrameUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ConsoleFrameUIListLayout.Padding = UDim.new(0, 3)

function MakeNewConsoleMessage(Text, TextColor, Frame, FSize, X, Y)
    local Button = Instance.new("TextButton")
    local Size = GetSize(Text, FSize, "SourceSans", X, Y)
    Button.Size = UDim2.new(0, Size.X, 0, Size.Y)
    for i, v in pairs(Frame:GetChildren()) do
        if v.ClassName ~= "UIListLayout" then
            v.Position = v.Position - UDim2.new(0, 0, 0, Size.Y)
            local Pos = v.Position.Y.Offset+(v.Position.Y.Scale*v.Parent.AbsoluteSize.Y)
            if v.Parent.ClassName == "ScrollingFrame" then
                Pos = v.Position.Y.Offset+(v.Position.Y.Scale*v.Parent.CanvasSize.Y.Offset)
            end
            if Pos < 0 then
                v:remove()
            end
        end
    end
    Button.Position = UDim2.new(0, 0, 1, -Size.Y)
    Button.Parent = Frame
    Button.BackgroundColor3 = Color3.fromRGB(108, 152, 255)
    Button.Text = Text
    Button.TextSize = FSize
    Button.TextWrapped = true
    Button.Font = Enum.Font.SourceSans
    Button.BorderSizePixel = 0
    Button.TextColor3 = TextColor
    Button.TextXAlignment = Enum.TextXAlignment.Left
Button.MouseButton1Down:connect(function()
local SC = syn_context_get()
syn_context_set(6)
setclipboard(Button.Text)
syn_context_set(SC)
end)
    if Frame.ClassName == "ScrollingFrame" and math.floor(Frame.CanvasPosition.Y+Frame.AbsoluteSize.Y)+1 < Frame.CanvasSize.Y.Offset then
        Frame.CanvasPosition = Frame.CanvasPosition - Vector2.new(0, Size.Y+3)
    end
end
local Last = nil
function CMSG(Msg, Color)
local WhatToStart = ""
if Last == nil or getfenv(2).script ~= Last then
Last = getfenv(2).script
WhatToStart = tostring(Last)..":\n"
end
local SC = syn_context_get()
syn_context_set(6)
    MakeNewConsoleMessage(WhatToStart..Msg, Color, ConsoleScrollFrame, 18, ConsoleFrame.AbsoluteSize.X, (ScrollSize/18)*0.70)
syn_context_set(SC)
end
getgenv().CError = function(Msg)
    CMSG(Msg, Color3.new(0.8, 0, 0))
end
getgenv().CWarn = function(Msg)
    CMSG(Msg, Color3.new(1, 1, 0))
end
getgenv().CPrint = function(Msg)
    CMSG(Msg, Color3.new(1, 1, 1))
end

LPlayer = game.Players.LocalPlayer
getgenv()["GetValues"] = function(args)
local Vals = args
local args = ""
for i, v in pairs(Vals) do
if tonumber(i) == nil then
args = args..'["'..tostring(i)..'"] = '
end
t = typeof(Vals[i])
if t == "string" then
args = args..StringConvert(Vals[i])
elseif t == "table" then
args = args.."{"..GetValues(v).."}"
elseif t == "Vector3" or t == "CFrame" or t == "Color3" or t == "Ray" then
args = args..t..".new("..tostring(Vals[i])..")"
elseif t == "BrickColor" then
args = args..t..'.new("'..tostring(Vals[i])..'")'
elseif t == "Instance" then
args = args..GetParent(Vals[i])
else
args = args..tostring(Vals[i])
end
args = args..", "
end
args = string.sub(args, 1, string.len(args) - 2)
return args
end

function StringConvert(S)
for i = 1, string.len(S) do
if S:sub(i, i) == '"' or S:sub(i, i) == "'" then
S = "[["..S.."]]"
return S
end
end
return '"'..S..'"'
end

function CheckForSpecial(Name)
for i = 1, string.len(Name) do
C = tonumber(string.byte(Name, i, i))
if not (C >= 65 and C <= 90 or C >= 97 and C <= 122 or C >= 48 and C <= 57) then
return false
end
end
end

function GetParent(Par)
local Names = {}
if Par == nil or Par.Parent == nil then
return tostring(Par):lower()
end
repeat
if Par == LPlayer then
table.insert(Names, 'game:GetService("Players").LocalPlayer')
break
elseif LPlayer.Character ~= nil and Par == LPlayer.Character then
table.insert(Names, 'game:GetService("Players").LocalPlayer.Character')
break
end
table.insert(Names, tostring(Par))
Par = Par.Parent
until Par == game
local TempLine = ""
for i = 1, #Names do
if CheckForSpecial(Names[#Names-i+1]) == false and i ~= 1 and Names[#Names-i+1]:sub(1, 4) ~= "game" then
Names[#Names-i+1] = '["'..Names[#Names-i+1]..'"]'
elseif i ~= 1 and Names[#Names-i+1]:sub(1, 4) ~= "game" then
Names[#Names-i+1] = '.'..Names[#Names-i+1]
elseif i == 1 and Names[#Names]:sub(1, 4) ~= "game" then
Names[#Names] = 'game:GetService("'..tostring(game[Names[#Names]].ClassName)..'")'
end
TempLine = TempLine..Names[#Names-i+1]
end
return TempLine
end
