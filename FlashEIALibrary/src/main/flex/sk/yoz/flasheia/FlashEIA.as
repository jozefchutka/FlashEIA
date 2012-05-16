package sk.yoz.flasheia
{
    import flash.display.Stage;
    import flash.events.EventDispatcher;
    import flash.external.ExternalInterface;
    
    import sk.yoz.flasheia.events.FlashEIAEvent;
    import sk.yoz.flasheia.utils.MouseEventSimulator;

    [Event(name="executionBegin", type="sk.yoz.flasheia.events.FlashEIAEvent")]
    [Event(name="executionEnd", type="sk.yoz.flasheia.events.FlashEIAEvent")]
    public class FlashEIA extends EventDispatcher
    {
        public var silent:Boolean;
        
        private var stage:Stage;
        
        private static const SCRIPT:XML = <script>
            <![CDATA[
                function(){
                    if(window.FlashEIA)
                        return;
                    
                    window.FlashEIA = {
                        getFlash: function(id)
                        {
                            return document.getElementById(id);
                        },
                        
                        defaultize: function(argument, defaultValue)
                        {
                            return (typeof argument == 'undefined' ? defaultValue : argument);
                        },
                        
                        clickAt: function(id, x, y)
                        {
                            FlashEIA.getFlash(id).clickAt(x, y);
                        },
                        
                        dragFromTo: function(id, x0, y0, x1, y1, steps)
                        {
                            FlashEIA.getFlash(id).dragFromTo(x0, y0, x1, y1, 
                                FlashEIA.defaultize(steps, 3));
                        }
                    };
                }
            ]]>
            </script>;
        
        public function init(stage:Stage):void
        {
            if(!ExternalInterface.available)
                throw new Error("ExternalInterface is not available!");
            if(!ExternalInterface.objectID)
                throw new Error("ExternalInterface.objectID is not available!");
            if(!stage)
                throw new Error("Stage is not available!");
                
            this.stage = stage;
            
            ExternalInterface.addCallback("clickAt", clickAt);
            ExternalInterface.addCallback("dragFromTo", dragFromTo);
            
            ExternalInterface.call(SCRIPT);
            
            notify("FlashEIA");
        }
        
        public function notify(message:String):void
        {
            if(silent)
                return;
            
            ExternalInterface.call("alert", message);
        }
        
        private function clickAt(x:Number, y:Number):void
        {
            dispatchBegin("clickAt", arguments);
            
            MouseEventSimulator.downAt(stage, x, y);
            MouseEventSimulator.upAt(stage, x, y);
            MouseEventSimulator.clickAt(stage, x, y);
            MouseEventSimulator.rollOutAt(stage, x, y);
            
            dispatchEnd("clickAt", arguments);
        }
        
        private function dragFromTo(x0:Number, y0:Number, x1:Number, y1:Number, 
            steps:Number = 3):void
        {
            dispatchBegin("dragFromTo", arguments);
            
            MouseEventSimulator.downAt(stage, x0, y0);
            for(var i:uint = 0; i < steps; i++)
                MouseEventSimulator.mouseMoveAt(stage, 
                    x0 + (x1 - x0) * i / (steps - 1), 
                    y0 + (y1 - y0) * i / (steps - 1));
            MouseEventSimulator.upAt(stage, x1, y1);
            MouseEventSimulator.rollOutAt(stage, x1, y1);
            
            dispatchEnd("dragFromTo", arguments);
        }
        
        private function dispatchBegin(method:String, arguments:Array):void
        {
            dispatch(FlashEIAEvent.EXECUTION_BEGIN, method, arguments);
        }
        
        private function dispatchEnd(method:String, arguments:Array):void
        {
            dispatch(FlashEIAEvent.EXECUTION_END, method, arguments);
        }
        
        private function dispatch(type:String, method:String, arguments:Array):void
        {
            dispatchEvent(new FlashEIAEvent(type, method, arguments));
        }
    }
}