-- This funny script gives you 25k money in Classic Downhill Rush
-- Made by XploitSDS team: https://www.youtube.com/@Xploitsds

function tp(part) -- Tp player to part
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0,2,0)
    wait(0.5)
end

game:GetService("StarterGui"):SetCore("SendNotification",{ -- Send notification
	Title = "XPloitSDS",
	Text = "Enjoy your free 25k",
	Icon = "rbxassetid://14153130058"
})

-- This obby have invisible checkpoints that check whether you cheated or not
-- So the script just touch all the checkpoints and get free money lmao

local obby = workspace.obby
tp(obby.Initiate)
tp(obby:FindFirstChild("to",true))
tp(obby["to2"])
tp(obby.Sun)
wait(1)

game:GetService("StarterGui"):SetCore("SendNotification",{ -- Send notification
	Title = "Done!",
	Text = "Please note that you cannot redeem it again",
	Icon = "rbxassetid://14153130058"
})
