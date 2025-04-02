class_name WeaponPreset extends Resource

## the preset's icon (not the weapon's)
@export var icon:Texture2D = null
## the name of the preset (not the weapon)
@export var name:String = "Preset Name"
## modifies (adds or substracts) to the weapon's base damage
@export var damage_modifier:int = 0
## sets the spread angle of the weapon
@export var base_spread:int = 15
## sets the cooldown time A.K.A the rate of fire (time in seconds inbetween shots)
@export var base_cooldown_time:float = 1
## sets the weapon's amount of projectiles per shot
@export var base_projectiles_per_shot:int = 1
## sets the weapon's projectile type (in PackedScene form)
@export var projectile_scene:PackedScene = preload("res://Scenes/Objects/Projectile/Projectile.tscn")
