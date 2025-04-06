extends CanvasLayer

const ERROR = preload("res://GUI/shop_menu/audio/error.wav")
const OPEN_SHOP = preload("res://GUI/shop_menu/audio/open_shop.wav")
const PURCHASE = preload("res://GUI/shop_menu/audio/purchase.wav")
const MENU_FOCUS = preload("res://title_scene/audio/menu_focus.wav")
const MENU_SELECT = preload("res://title_scene/audio/menu_select.wav")

const SHOP_ITEM_BUTTON = preload("res://GUI/shop_menu/shop_item_button.tscn")

var currency : ItemData = preload("res://Items/gem.tres")

signal shown
signal hidden


var is_active : bool = false

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var close_button: Button = %CloseButton
@onready var shop_item_container: VBoxContainer = %ShopItemContainer
@onready var gems_label: Label = %GemsLabel
@onready var gems_animation_player: AnimationPlayer = $Control/PanelContainer/AnimationPlayer


@onready var item_image: TextureRect = %ItemImage
@onready var item_name: Label = %ItemName
@onready var item_description: Label = %ItemDescription
@onready var item_price: Label = %ItemPrice
@onready var item_held_count: Label = %ItemHeldCount




func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide_menu()
	close_button.pressed.connect( hide_menu )
	pass



func _unhandled_input( event: InputEvent ) -> void:
	if is_active == false:
		return
	
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		hide_menu()



func show_menu( items : Array[ ItemData], dialog_triggered : bool = true ) -> void:
	print( items, items.size() )
	if dialog_triggered:
		await DialogSystem.finished
	enable_menu()
	populate_item_list( items )
	update_gems()
	shop_item_container.get_child( 0 ).grab_focus()
	play_audio( OPEN_SHOP )
	shown.emit()
	pass


func hide_menu() -> void:
	enable_menu( false )
	clear_item_list()
	hidden.emit()
	pass


func enable_menu( _enabled : bool = true ) -> void:
	get_tree().paused = _enabled
	visible = _enabled
	is_active = _enabled



func update_gems() -> void:
	gems_label.text = str( get_item_quantity( currency ) )
	pass


func get_item_quantity( item : ItemData ) -> int:
	return PlayerManager.INVENTORY_DATA.get_item_held_quantity( item )



func clear_item_list() -> void:
	for c in shop_item_container.get_children():
		c.queue_free()
	pass



func populate_item_list( items : Array[ ItemData ] ) -> void:
	for item in items:
		var shop_item : ShopItemButton = SHOP_ITEM_BUTTON.instantiate()
		shop_item.setup_item( item )
		shop_item_container.add_child( shop_item )
		shop_item.focus_entered.connect( update_item_details.bind( item ) )
		shop_item.pressed.connect( purchase_item.bind( item ) )
		pass
	pass



func play_audio( _audio : AudioStream ) -> void:
	audio_stream_player.stream = _audio
	audio_stream_player.play()



func focused_item_changed( item : ItemData ) -> void:
	play_audio( MENU_FOCUS )
	if item:
		update_item_details( item )


func update_item_details( item : ItemData ) -> void:
	item_image.texture = item.texture
	item_name.text = item.name
	item_description.text = item.description
	item_price.text = str( item.cost )
	item_held_count.text = str( get_item_quantity( item ) )
	pass


func purchase_item( item : ItemData ) -> void:
	var can_purchase : bool = get_item_quantity( currency ) >= item.cost
	
	if can_purchase:
		play_audio( PURCHASE )
		var inv : InventoryData = PlayerManager.INVENTORY_DATA
		inv.add_item( item )
		inv.use_item( currency, item.cost )
		update_gems()
		update_item_details( item )
	else:
		play_audio( ERROR )
		gems_animation_player.play( "not_enough_gems" )
		gems_animation_player.seek( 0 )
	pass
