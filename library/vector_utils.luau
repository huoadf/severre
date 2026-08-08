--!strict
-- Severe Vector Utilities Helper
-- Workaround for Severe's native vector type which supports +, -, *, / but lacks .Magnitude, .Unit, :Dot(), :Cross(), :Lerp()

local VectorUtils = {}

function VectorUtils.Magnitude2D(v: any): number
    return math.sqrt(v.X * v.X + v.Y * v.Y)
end

function VectorUtils.Magnitude3D(v: any): number
    return math.sqrt(v.X * v.X + v.Y * v.Y + v.Z * v.Z)
end

function VectorUtils.Unit2D(v: any): any
    local mag = VectorUtils.Magnitude2D(v)
    if mag == 0 then return Vector2.new(0, 0) end
    return Vector2.new(v.X / mag, v.Y / mag)
end

function VectorUtils.Unit3D(v: any): any
    local mag = VectorUtils.Magnitude3D(v)
    if mag == 0 then return Vector3.new(0, 0, 0) end
    return Vector3.new(v.X / mag, v.Y / mag, v.Z / mag)
end

function VectorUtils.Dot2D(v1: any, v2: any): number
    return (v1.X * v2.X) + (v1.Y * v2.Y)
end

function VectorUtils.Dot3D(v1: any, v2: any): number
    return (v1.X * v2.X) + (v1.Y * v2.Y) + (v1.Z * v2.Z)
end

function VectorUtils.Cross3D(v1: any, v2: any): any
    return Vector3.new(
        v1.Y * v2.Z - v1.Z * v2.Y,
        v1.Z * v2.X - v1.X * v2.Z,
        v1.X * v2.Y - v1.Y * v2.X
    )
end

function VectorUtils.Lerp2D(v1: any, v2: any, alpha: number): any
    return Vector2.new(
        v1.X + (v2.X - v1.X) * alpha,
        v1.Y + (v2.Y - v1.Y) * alpha
    )
end

function VectorUtils.Lerp3D(v1: any, v2: any, alpha: number): any
    return Vector3.new(
        v1.X + (v2.X - v1.X) * alpha,
        v1.Y + (v2.Y - v1.Y) * alpha,
        v1.Z + (v2.Z - v1.Z) * alpha
    )
end

return VectorUtils
