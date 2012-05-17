package sk.yoz.flasheia.utils
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.InteractiveObject;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    public class MouseEventSimulator
    {
        public static function clickAt(stage:Stage, x:Number, y:Number):void
        {
            mouseAt(MouseEvent.CLICK, stage, x, y);
        }
        
        public static function mouseDownAt(stage:Stage, x:Number, y:Number):void
        {
            mouseAt(MouseEvent.MOUSE_DOWN, stage, x, y);
        }
        
        public static function mouseMoveAt(stage:Stage, x:Number, y:Number):void
        {
            mouseAt(MouseEvent.MOUSE_MOVE, stage, x, y);
        }
        
        public static function mouseOverAt(stage:Stage, x:Number, y:Number):void
        {
            mouseAt(MouseEvent.MOUSE_OVER, stage, x, y);
        }
        
        public static function mouseUpAt(stage:Stage, x:Number, y:Number):void
        {
            mouseAt(MouseEvent.MOUSE_UP, stage, x, y);
        }
        
        public static function rollOutAt(stage:Stage, x:Number, y:Number):void
        {
            mouseAt(MouseEvent.ROLL_OUT, stage, x, y);
        }
        
        public static function rollOverAt(stage:Stage, x:Number, y:Number):void
        {
            mouseAt(MouseEvent.ROLL_OVER, stage, x, y);
        }
        
        private static function mouseAt(type:String, stage:Stage, x:Number, y:Number):void
        {
            var result:InteractiveObject = getInteractiveObjectAt(stage, stage.root, x, y);
            if(!result)
                return;
            
            var local:Point = getLocal(result, x, y);
            result.dispatchEvent(new MouseEvent(type, true, true, local.x, local.y));
        }
        
        private static function getInteractiveObjectAt(stage:Stage, 
            source:DisplayObject, x:Number, y:Number):InteractiveObject
        {
            if(!source.visible)
                return null;
            
            var interactive:InteractiveObject = source as InteractiveObject;
            if(!interactive)
                return null;
            if(!interactive.mouseEnabled)
                return null;
            
            var container:DisplayObjectContainer = source as DisplayObjectContainer;
            if(container && container.mouseChildren)
            {
                for(var i:uint = container.numChildren; i--;)
                {
                    var child:DisplayObject = container.getChildAt(i);
                    var result:InteractiveObject = getInteractiveObjectAt(stage, child, x, y);
                    if(result)
                        return result;
                }
            }
            
            if(source.hitTestPoint(x, y, true) 
                && DisplayObjectUtils.getGlobalBounds(source).contains(x, y))
                return interactive;
            return null;
        }
        
        private static function getLocal(source:DisplayObject, x:Number, y:Number):Point
        {
            return source.globalToLocal(new Point(x, y));
        }
    }
}