---lk:placeholder setup:hot

---lk:placeholder setup:hook

---lk:placeholder setup:asyncRand

---lk:placeholder setup:mouseLeftClick

---lk:placeholder setup:mouseLeftRelease

---lk:placeholder setup:mouseRightClick

---lk:placeholder setup:mouseRightRelease

---lk:placeholder setup:mouseWheel

---lk:placeholder setup:mouseMove

---lk:placeholder setup:uiEsc

---lk:placeholder setup:keyboard

---lk:placeholder setup:uiAdaptive

---lk:placeholder setup:windowResize

--- UI Kit初始化
---@param enumObj UIKit
Pool(UIKitClass):forEach(function(enumObj)
    enumObj:setup()
end)

--- UI - tooltips
for i = 0, 3 do
    UITooltips(i)
end