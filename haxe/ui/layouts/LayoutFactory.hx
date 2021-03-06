package haxe.ui.layouts;


class LayoutFactory {
    public static function createFromName(name:String):Layout {
        switch (name) { // TODO: change this to a map, and make populate from module.xml (like components) - would also allow other modules to add layouts (as well as manually "registering" layouts)
            case "vertical":
                return new VerticalLayout();
            case "horizontal":
                return new HorizontalLayout();
            case "absolute":
                return new AbsoluteLayout();
        }
        
        return new DefaultLayout();
    }
} 