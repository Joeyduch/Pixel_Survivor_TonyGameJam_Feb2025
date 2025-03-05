class_name BaseUpgrade extends Resource

@export var upgrade_name:String = "Base Upgrade"
@export var upgrade_icon:Texture2D = null
@export var description:String = "Base upgrade description."


func apply(receiver:Entity) -> void:
	print("APPLYING UPGRADE " + upgrade_name + " TO " + receiver.name)
