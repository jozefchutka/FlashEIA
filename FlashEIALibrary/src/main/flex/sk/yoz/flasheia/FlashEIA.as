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
                        
                        clickAt: function(id, x, y)
                        {
                            FlashEIA.getFlash(id).clickAt(x, y);
                        }
                    };
                }
            ]]>
            </script>
        
        public function init(stage:Stage):void
        {
            if(!ExternalInterface.available)
                throw new Error("ExternalInterface is not available!");
            if(!ExternalInterface.objectID)
                throw new Error("ExternalInterface.objectID is not available!");
            
            this.stage = stage;
            
            ExternalInterface.addCallback("clickAt", clickAt);
            
            ExternalInterface.call(SCRIPT);
            
            notify("FlashEIA");
        }
        
        public function notify(message:String):void
        {
            ExternalInterface.call("alert", message);
        }
        
        private function clickAt(x:Number, y:Number):void
        {
            dispatchBegin("clickAt", arguments);
            MouseEventSimulator.downAt(stage, x, y);
            MouseEventSimulator.upAt(stage, x, y);
            MouseEventSimulator.clickAt(stage, x, y);
            dispatchEnd("clickAt", arguments);
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