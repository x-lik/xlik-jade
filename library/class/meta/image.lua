--- 地表图像
--- 此图像将显示在地形地表上
---@class Image:Meta
local _index = Meta(ImageClass)

---@protected
function _index:destruct()
    J.ShowImage(self._handle, false)
    J.DestroyImage(self._handle)
    self._handle = nil
end

--- 设置图像贴图路径
---@param path string
---@return void
function _index:texture(path)
    path = japi.AssetsImage(path)
    local h = self._handle
    J.ShowImage(h, false)
    J.DestroyImage(h)
    h = J.CreateImage(path, self._width, self._height, 0, -self._width / 2, -self._height / 2, 0, 0, 0, 0, 3)
    J.SetImageAboveWater(h, true, true)
    J.SetImageRenderAlways(h, true)
    self._handle = h
    self._texture = path
end

--- 设置图像宽高大小
---@param width number
---@param height number
---@return void
function _index:size(width, height)
    local h = self._handle
    J.ShowImage(h, false)
    J.DestroyImage(h)
    h = J.CreateImage(self._texture, width, height, 0, -width / 2, -height / 2, 0, 0, 0, 0, 3)
    J.SetImageAboveWater(h, true, true)
    J.SetImageRenderAlways(h, true)
    self._handle = h
    self._width = width
    self._height = height
end

--- 显示|隐藏图像
---@param status boolean
---@return self
function _index:show(status)
    J.ShowImage(self._handle, status)
    return self
end

--- 设置图像rgba颜色
---@param red number 取值范围[0-255]
---@param green number 取值范围[0-255]
---@param blue number 取值范围[0-255]
---@param alpha number 取值范围[0-255]
---@return void
function _index:rgba(red, green, blue, alpha)
    J.SetImageColor(self._handle, red, green, blue, alpha)
end

--- 移动图像到X,Y坐标
---@param x number|nil
---@param y number|nil
---@return void
function _index:position(x, y)
    J.SetImageConstantHeight(self._handle, false, 0)
    J.SetImagePosition(self._handle, x - self._width / 2, y - self._height / 2, 0)
end

--- 创建一个图像
--- 图像的贴图影响显示效果，当边上有非alpha像素时，容易造成渲染溢出，所以建议图四边都留1像素的透明边
---@param texture string
---@param width number
---@param height number
---@return Image
function Image(texture, width, height)
    sync.must()
    local h = J.CreateImage(texture, width, height, 0, -width / 2, -height / 2, 0, 0, 0, 0, 3)
    J.SetImageAboveWater(h, true, true)
    J.SetImageRenderAlways(h, true)
    return oMeta({ _handle = h, _texture = texture, _width = width, _height = height }, _index)
end
