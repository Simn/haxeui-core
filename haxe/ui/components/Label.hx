package haxe.ui.components;

import haxe.ui.components.Label.LabelLayout;
import haxe.ui.core.Behaviour;
import haxe.ui.core.IClonable;
import haxe.ui.core.InteractiveComponent;
import haxe.ui.layouts.DefaultLayout;
import haxe.ui.styles.Style;
import haxe.ui.util.Size;
import haxe.ui.util.Variant;

/**
 A general purpose component to display text
**/
@:dox(icon="/icons/ui-label.png")
class Label extends InteractiveComponent implements IClonable<Label> {
    public function new() {
        super();
        #if openfl
        mouseChildren = false;
        #end
    }

    //***********************************************************************************************************
    // Internals
    //***********************************************************************************************************
    private override function createDefaults():Void {
        _defaultBehaviours = [
            "text" => new LabelDefaultTextBehaviour(this)
        ];
        _defaultLayout = new LabelLayout();
    }

    private override function create():Void {
        super.create();
        behaviourSet("text", _text);
    }

    //***********************************************************************************************************
    // Overrides
    //***********************************************************************************************************
    private override function set_text(value:String):String {
        if (value == _text) {
            return value;
        }

        value = super.set_text(value);
        behaviourSet("text", value);
        handleBindings(["text", "value"]);
        invalidateLayout();
        return value;
    }

    private override function applyStyle(style:Style):Void {
        super.applyStyle(style);
        if (hasTextDisplay() == true) {
            if (style.color != null) {
                getTextDisplay().color = style.color;
            }
            if (style.fontName != null) {
                getTextDisplay().fontName = style.fontName;
            }
            if (style.fontSize != null) {
                getTextDisplay().fontSize = style.fontSize;
            }
        }
    }
}

//***********************************************************************************************************
// Custom layouts
//***********************************************************************************************************
@:dox(hide)
@:access(haxe.ui.components.Label)
class LabelLayout extends DefaultLayout {
    private override function resizeChildren() {
        if (component.autoWidth == false) {
            component.getTextDisplay().width = component.componentWidth;
            #if openfl // TODO: make not specific
            component.getTextDisplay().multiline = true;
            component.getTextDisplay().wordWrap = true;
            #end
        }
    }

    private override function repositionChildren():Void {
        if (component.hasTextDisplay() == true) {
            component.getTextDisplay().left = paddingLeft;
            component.getTextDisplay().top = paddingTop;
        }
    }

    public override function calcAutoSize():Size {
        var size:Size = super.calcAutoSize();
        if (component.hasTextDisplay() == true) {
            size.width += component.getTextDisplay().textWidth;
            size.height += component.getTextDisplay().textHeight;
        }
        return size;
    }
}

//***********************************************************************************************************
// Default behaviours
//***********************************************************************************************************
@:dox(hide)
@:access(haxe.ui.components.Label)
class LabelDefaultTextBehaviour extends Behaviour {
    public override function set(value:Variant) {
        if (value.isNull) {
            value = "";
        }

        var label:Label = cast _component;
        label.getTextDisplay().text = value;
        label.invalidateDisplay();
    }
}
