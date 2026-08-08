--!strict
-- Severe Vector Polyfill & Utility Library
-- Solves Severe external vector indexing limitations (.Magnitude, .Unit, :Dot(), :Lerp(), :Cross())

local VectorUtil = {}

-- 1. Calculates the magnitude (length) of a Vector2 or Vector3
function VectorUtil.Magnitude(v: any): number
    local x = v.X or 0
    local y = v.Y or 0
    local z = v.Z or 0
    return math.sqrt((x * x) + (y * y) + (z * z))
end

-- 2. Returns a normalized vector with a magnitude of 1 (unit vector)
function VectorUtil.Unit(v: any): any
    local mag = VectorUtil.Magnitude(v)
    if mag == 0 then
        return if v.Z ~= nil then Vector3.new(0, 0, 0) else Vector2.new(0, 0)
    end
    if v.Z ~= nil then
        return Vector3.new(v.X / mag, v.Y / mag, v.Z / mag)
    else
        return Vector2.new(v.X / mag, v.Y / mag)
    end
end

-- 3. Calculates the Dot product of two vectors
function VectorUtil.Dot(v1: any, v2: any): number
    local x1, y1, z1 = v1.X or 0, v1.Y or 0, v1.Z or 0
    local x2, y2, z2 = v2.X or 0, v2.Y or 0, v2.Z or 0
    return (x1 * x2) + (y1 * y2) + (z1 * z2)
end

-- 4. Calculates the Cross product of two Vector3s
function VectorUtil.Cross(v1: any, v2: any): any
    local x1, y1, z1 = v1.X, v1.Y, v1.Z
    local x2, y2, z2 = v2.X, v2.Y, v2.Z
    return Vector3.new(
        (y1 * z2) - (z1 * y2),
        (z1 * x2) - (x1 * z2),
        (x1 * y2) - (y1 * x2)
    )
end

-- 5. Linear interpolation (Lerp) between two vectors
function VectorUtil.Lerp(v1: any, v2: any, alpha: number): any
    local t = math.clamp(alpha, 0, 1)
    if v1.Z ~= nil and v2.Z ~= nil then
        return Vector3.new(
            v1.X + ((v2.X - v1.X) * t),
            v1.Y + ((v2.Y - v1.Y) * t),
            v1.Z + ((v2.Z - v1.Z) * t)
        )
    else
        return Vector2.new(
            v1.X + ((v2.X - v1.X) * t),
            v1.Y + ((v2.Y - v1.Y) * t)
        )
    end
end

-- 6. Calculates 2D or 3D distance between two points
function VectorUtil.Distance(v1: any, v2: any): number
    return VectorUtil.Magnitude(v2 - v1)
end

-- 7. Clamps a Vector2 point within screen bounds
function VectorUtil.Clamp(v: any, minBound: any, maxBound: any): any
    return Vector2.new(
        math.clamp(v.X, minBound.X, maxBound.X),
        math.clamp(v.Y, minBound.Y, maxBound.Y)
    )
end

return VectorUtil
