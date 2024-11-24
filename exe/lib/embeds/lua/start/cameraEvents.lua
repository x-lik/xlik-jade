-- camera events
do
    local cf = japi._cameraField
    local distance = math.floor(J.GetCameraField(CAMERA_FIELD_TARGET_DISTANCE))
    local isZoom = (distance ~= cf.distance)
    cf.distance = distance
    if (isZoom) then
        event.asyncTrigger("camera", eventKind.cameraZoom)
    end
    local traX = J.GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK)
    local traZ = J.GetCameraField(CAMERA_FIELD_ROTATION)
    local isRotate = (traX ~= cf.traX or traZ ~= cf.traZ)
    cf.traX = traX
    cf.traZ = traZ
    if (isRotate) then
        event.asyncTrigger("camera", eventKind.cameraRotate)
    end
    local tx = J.GetCameraTargetPositionX()
    local ty = J.GetCameraTargetPositionY()
    local isMove = false
    if (nil ~= cf.tx) then
        isMove = vector2.distance(cf.tx, cf.ty, tx, ty) > 31
    end
    if (isRotate or cf.tx ~= tx or cf.ty ~= ty) then
        cf.tz = nil
        cf.ex = nil
        cf.ey = nil
        cf.ez = nil
    end
    cf.tx = tx
    cf.ty = ty
    if (isMove) then
        event.asyncTrigger("camera", eventKind.cameraMove)
    end
    if (isZoom or isRotate or isMove) then
        event.asyncTrigger("camera", eventKind.cameraChange)
    end
end