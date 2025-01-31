---@meta

---Creates a new vector2 value.
---@param x number A floating point number representing the x value of your vector.
---@param y number A floating point number representing the y value of your vector.
---@return Vector2 vector The created vector
function vector2(x, y) end

---@class Vector2
---@field x number
---@field y number
---@field xy Vector2
---@field yx Vector2
---@operator add(Vector2|number):Vector2
---@operator sub(Vector2|number):Vector2
---@operator mul(Vector2|number):Vector2
---@operator div(Vector2|number):Vector2
---@operator unm:Vector2
---@operator len:number

---Creates a new vector3 value.
---@param x number A floating point number representing the x value of your vector.
---@param y number A floating point number representing the y value of your vector.
---@param z number A floating point number representing the z value of your vector.
---@return Vector3 vector The created vector
function vector3(x, y, z) end

---@class Vector3
---@field x number
---@field y number
---@field z number
---@field xy Vector2
---@field xz Vector2
---@field xyz Vector3
---@field xzy Vector3
---@field yx Vector2
---@field yz Vector2
---@field yxz Vector3
---@field yzx Vector3
---@field zx Vector2
---@field zy Vector2
---@field zxy Vector3
---@field zyx Vector3
---@operator add(Vector3|number):Vector3
---@operator sub(Vector3|number):Vector3
---@operator mul(Vector3|number):Vector3
---@operator div(Vector3|number):Vector3
---@operator unm:Vector3
---@operator len:number

---Creates a new vector4 value.
---@param x number A floating point number representing the x value of your vector.
---@param y number A floating point number representing the y value of your vector.
---@param z number A floating point number representing the z value of your vector.
---@param w number A floating point number representing the w value of your vector.
---@return Vector4 vector The created vector
function vector3(x, y, z, w) end

---@class Vector4
---@field x number
---@field y number
---@field z number
---@field w number
---@operator add(Vector4|number):Vector4
---@operator sub(Vector4|number):Vector4
---@operator mul(Vector4|number):Vector4
---@operator div(Vector4|number):Vector4
---@operator unm:Vector4
---@operator len:number


---Normalize the provided vector
---@param v Vector2
---@return Vector2 norm
function norm(v) end

---Normalize the provided vector
---@param v Vector3
---@return Vector3 norm
function norm(v) end

---Normalize the provided vector
---@param v Vector4
---@return Vector4 norm
function norm(v) end