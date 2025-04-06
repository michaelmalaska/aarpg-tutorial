class_name Shopkeeper extends Node2D

@export var shop_inventory : Array[ ItemData ]

@onready var dialog_branch_yes: DialogBranch = $NPC/DialogInteraction/DialogChoice/DialogBranch



func _ready() -> void:
	dialog_branch_yes.selected.connect( show_shop_menu )
	pass


func show_shop_menu() -> void:
	print("Show the shop")
	ShopMenu.show_menu( shop_inventory )
	pass
