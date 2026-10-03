extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var quantity_label: Label = $CenterContainer/Panel/quantity_label

func update(slot: InvSlot):
	if !slot.item:
		item_visual.visible = false
		quantity_label.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		if slot.amount > 1:
			quantity_label.visible = true
			quantity_label.text = str(slot.amount)
