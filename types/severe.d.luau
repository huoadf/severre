--!strict
-- Severe External LuauVM Type Definitions

export type ModelData = {
    Username: string?,
    Displayname: string?,
    Userid: number?,
    Character: userdata?,
    PrimaryPart: userdata?,
    Head: userdata?,
    LeftLeg: userdata?,
    LeftArm: userdata?,
    RightLeg: userdata?,
    RightArm: userdata?,
    Torso: userdata?,
    ToolName: string?,
    TeamName: string?,
    BodyHeightScale: number?,
    RigType: number?,
    Whitelisted: boolean?,
    Archenemies: boolean?,
    Aimbot_Part: userdata?,
    Aimbot_TP_Part: userdata?,
    Triggerbot_Part: userdata?,
    Health: number?,
    MaxHealth: number?,
    body_parts_data: { [string]: any }?,
    full_body_data: { [string]: any }?,
}

export type EditModelData = {
    RigType: number?,
    Whitelisted: boolean?,
    Archenemies: boolean?,
    Aimbot_Part: userdata?,
    Aimbot_TP_Part: userdata?,
    Triggerbot_Part: userdata?,
    Health: number?,
    MaxHealth: number?,
    BodyHeightScale: number?,
}

export type LocalData = {
    LocalPlayer: userdata?,
    Displayname: string?,
    Username: string?,
    Userid: number?,
    Character: userdata?,
    Team: userdata?,
    RootPart: userdata?,
    LeftFoot: userdata?,
    Head: userdata?,
    LowerTorso: userdata?,
    Tool: userdata?,
    Humanoid: userdata?,
    Health: number?,
    MaxHealth: number?,
    RigType: number?,
}

-- Point Tracking Classes
export type PointInstance = {
    CFrame: any,
    Size: any,
    Active: boolean,
    Destroy: (self: PointInstance) -> (),
}

export type Point3D = {
    Position: any,
    Active: boolean,
    Destroy: (self: Point3D) -> (),
}

export type Cluster = {
    Destroy: (self: Cluster) -> (),
    Pause: (self: Cluster) -> (),
    Resume: (self: Cluster) -> (),
}

export type AttachmentConfig = {
    Link: (PointInstance | Point3D)?,
    From: (PointInstance | Point3D)?,
    To: (PointInstance | Point3D)?,
    Size: any?,
    AnchorPoint: any?,
}

-- Drawing Primitives
export type DrawingObject = {
    Visible: boolean,
    Color: any,
    Transparency: number,
    ZIndex: number,
    Remove: (self: DrawingObject) -> (),
    Destroy: (self: DrawingObject) -> (),
    [string]: any,
}

-- Memory Library Signature Type
export type MemoryLibrary = {
    base: number,
    
    -- Integer Readers
    readi8: ((address: number) -> number) & ((source: userdata, offset: number) -> number),
    readu8: ((address: number) -> number) & ((source: userdata, offset: number) -> number),
    readi16: ((address: number) -> number) & ((source: userdata, offset: number) -> number),
    readu16: ((address: number) -> number) & ((source: userdata, offset: number) -> number),
    readi32: ((address: number) -> number) & ((source: userdata, offset: number) -> number),
    readu32: ((address: number) -> number) & ((source: userdata, offset: number) -> number),
    readi64: ((address: number) -> number) & ((source: userdata, offset: number) -> number),
    readu64: ((address: number) -> number) & ((source: userdata, offset: number) -> number),
    
    -- Float Readers
    readf32: ((address: number) -> number) & ((source: userdata, offset: number) -> number),
    readf64: ((address: number) -> number) & ((source: userdata, offset: number) -> number),
    
    -- Data Structure Readers
    readstring: ((address: number) -> string) & ((source: userdata, offset: number) -> string),
    readvector: ((address: number) -> any) & ((source: userdata, offset: number) -> any),
    readbuffer: ((address: number, size: number) -> buffer) & ((source: userdata, offset: number, size: number) -> buffer),
    
    -- Integer Writers
    writei8: ((address: number, value: number) -> ()) & ((destination: userdata, offset: number, value: number) -> ()),
    writeu8: ((address: number, value: number) -> ()) & ((destination: userdata, offset: number, value: number) -> ()),
    writei16: ((address: number, value: number) -> ()) & ((destination: userdata, offset: number, value: number) -> ()),
    writeu16: ((address: number, value: number) -> ()) & ((destination: userdata, offset: number, value: number) -> ()),
    writei32: ((address: number, value: number) -> ()) & ((destination: userdata, offset: number, value: number) -> ()),
    writeu32: ((address: number, value: number) -> ()) & ((destination: userdata, offset: number, value: number) -> ()),
    writei64: ((address: number, value: number) -> ()) & ((destination: userdata, offset: number, value: number) -> ()),
    writeu64: ((address: number, value: number) -> ()) & ((destination: userdata, offset: number, value: number) -> ()),
    
    -- Float Writers
    writef32: ((address: number, value: number) -> ()) & ((destination: userdata, offset: number, value: number) -> ()),
    writef64: ((address: number, value: number) -> ()) & ((destination: userdata, offset: number, value: number) -> ()),
    
    -- Data Structure Writers
    writestring: ((address: number, value: string) -> ()) & ((destination: userdata, offset: number, value: string) -> ()),
    writevector: ((address: number, value: any) -> ()) & ((destination: userdata, offset: number, value: any) -> ()),
    writebuffer: ((address: number, value: buffer) -> ()) & ((destination: userdata, offset: number, value: buffer) -> ()),
    
    -- Bit Operations
    readbits: ((address: number, bitOffset: number, bitSize: number) -> number) & ((source: userdata, offset: number, bitOffset: number, bitSize: number) -> number),
    writebits: ((address: number, bitOffset: number, bitSize: number, value: number) -> ()) & ((destination: userdata, offset: number, bitOffset: number, bitSize: number, value: number) -> ()),
    
    -- Advanced Memory Analysis
    rtti: ((address: number) -> string?) & ((source: userdata, offset: number) -> string?),
    changed: ((address: number, type: string, callback: (self: userdata, new: any, old: any) -> (), iterations: number?) -> userdata) & ((source: userdata, offset: number, type: string, callback: (self: userdata, new: any, old: any) -> (), iterations: number?) -> userdata),
}

-- Declare Severe Globals
declare function isrbxactive(): boolean
declare function send_notification(content: string): ()
declare function setclipboard(content: string): ()
declare function block_roblox_window(state: boolean): ()
declare function pointer_to_userdata(address: number): userdata
declare function get_overlay_fps(): number
declare function ismenuopened(): boolean

declare function is_forcefield_check_active(): boolean
declare function is_local_health_check_active(): boolean
declare function is_team_check_active(): boolean

declare function add_model_data(data: ModelData, key: string): boolean
declare function edit_model_data(data: EditModelData, key: string): boolean
declare function remove_model_data(key: string): boolean
declare function clear_model_data(): boolean

declare function override_local_data(data: LocalData): boolean
declare function clear_local_data(): boolean

-- Input Globals
declare function keypress(keycode: number): ()
declare function keyrelease(keycode: number): ()
declare function getpressedkey(): string
declare function getpressedkeys(): { string }
declare function isleftclicked(): boolean
declare function isrightclicked(): boolean
declare function isleftpressed(): boolean
declare function isrightpressed(): boolean
declare function mousemoverel(x: number, y: number): ()
declare function mousemoveabs(x: number, y: number): ()
declare function mousescroll(pixels: number): ()
declare function mouse1click(): ()
declare function mouse1press(): ()
declare function mouse1release(): ()
declare function mouse2click(): ()
declare function mouse2press(): ()
declare function mouse2release(): ()

-- Drawing Global & Constructors
declare PointInstance: {
    new: (instance: userdata) -> PointInstance,
}

declare Point3D: {
    new: (position: any) -> Point3D,
}

declare Drawing: {
    new: (shapeType: string) -> DrawingObject,
    attach: (config: { [DrawingObject]: AttachmentConfig }) -> Cluster,
}

declare memory: MemoryLibrary
