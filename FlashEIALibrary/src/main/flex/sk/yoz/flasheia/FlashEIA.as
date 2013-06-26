package sk.yoz.flasheia
{
    import flash.display.BitmapData;
    import flash.display.Stage;
    import flash.events.EventDispatcher;
    import flash.external.ExternalInterface;
    import flash.geom.Matrix;
    import flash.utils.ByteArray;
    
    import mx.utils.SHA256;
    
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
                        
                        defaultize: function(argument, defaultValue)
                        {
                            return (typeof argument == 'undefined' ? defaultValue : argument);
                        },
                        
                        clickAt: function(id, x, y)
                        {
                            FlashEIA.getFlash(id).clickAt(x, y);
                        },
                        
                        mouseDownAt: function(id, x, y)
                        {
                            FlashEIA.getFlash(id).mouseDownAt(x, y);
                        },
                        
                        mouseMoveAt: function(id, x, y)
                        {
                            FlashEIA.getFlash(id).mouseMoveAt(x, y);
                        },
                        
                        mouseOverAt: function(id, x, y)
                        {
                            FlashEIA.getFlash(id).mouseOverAt(x, y);
                        },
                        
                        mouseUpAt: function(id, x, y)
                        {
                            FlashEIA.getFlash(id).mouseUpAt(x, y);
                        },
                        
                        rollOutAt: function(id, x, y)
                        {
                            FlashEIA.getFlash(id).rollOutAt(x, y);
                        },
                        
                        rollOverAt: function(id, x, y)
                        {
                            FlashEIA.getFlash(id).rollOverAt(x, y);
                        },
                        
                        smartClickAt: function(id, x, y)
                        {
                            FlashEIA.getFlash(id).smartClickAt(x, y);
                        },
                        
                        smartDragFromTo: function(id, x0, y0, x1, y1, steps)
                        {
                            FlashEIA.getFlash(id).smartDragFromTo(x0, y0, x1, y1, 
                                FlashEIA.defaultize(steps, 3));
                        },
                        
                        screenshot: function(id, x, y, width, height)
                        {
                            FlashEIA.getFlash(id).screenshot(x, y, width, height);
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
            ExternalInterface.addCallback("mouseDownAt", mouseDownAt);
            ExternalInterface.addCallback("mouseMoveAt", mouseMoveAt);
            ExternalInterface.addCallback("mouseOverAt", mouseOverAt);
            ExternalInterface.addCallback("mouseUpAt", mouseUpAt);
            ExternalInterface.addCallback("rollOutAt", rollOutAt);
            ExternalInterface.addCallback("rollOverAt", rollOverAt);
            ExternalInterface.addCallback("smartClickAt", smartClickAt);
            ExternalInterface.addCallback("smartDragFromTo", smartDragFromTo);
            ExternalInterface.addCallback("screenshot", screenshot);
            
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
            MouseEventSimulator.clickAt(stage, x, y);
            dispatchEnd("clickAt", arguments);
        }
        
        private function mouseDownAt(stage:Stage, x:Number, y:Number):void
        {
            dispatchBegin("mouseDownAt", arguments);
            MouseEventSimulator.mouseDownAt(stage, x, y);
            dispatchEnd("mouseDownAt", arguments);
        }
        
        private function mouseMoveAt(stage:Stage, x:Number, y:Number):void
        {
            dispatchBegin("mouseMoveAt", arguments);
            MouseEventSimulator.mouseMoveAt(stage, x, y);
            dispatchEnd("mouseMoveAt", arguments);
        }
        
        private function mouseOverAt(stage:Stage, x:Number, y:Number):void
        {
            dispatchBegin("mouseOverAt", arguments);
            MouseEventSimulator.mouseOverAt(stage, x, y);
            dispatchEnd("mouseOverAt", arguments);
        }
        
        private function mouseUpAt(stage:Stage, x:Number, y:Number):void
        {
            dispatchBegin("mouseUpAt", arguments);
            MouseEventSimulator.mouseUpAt(stage, x, y);
            dispatchEnd("mouseUpAt", arguments);
        }
        
        private function rollOutAt(stage:Stage, x:Number, y:Number):void
        {
            dispatchBegin("rollOutAt", arguments);
            MouseEventSimulator.rollOutAt(stage, x, y);
            dispatchEnd("rollOutAt", arguments);
        }
        
        private function rollOverAt(stage:Stage, x:Number, y:Number):void
        {
            dispatchBegin("rollOverAt", arguments);
            MouseEventSimulator.rollOverAt(stage, x, y);
            dispatchEnd("rollOverAt", arguments);
        }
        
        private function smartClickAt(x:Number, y:Number):void
        {
            dispatchBegin("smartClickAt", arguments);
            
            MouseEventSimulator.mouseDownAt(stage, x, y);
            MouseEventSimulator.mouseUpAt(stage, x, y);
            MouseEventSimulator.clickAt(stage, x, y);
            MouseEventSimulator.rollOutAt(stage, x, y);
            
            dispatchEnd("smartClickAt", arguments);
        }
        
        private function smartDragFromTo(x0:Number, y0:Number, x1:Number, y1:Number, 
            steps:Number = 3):void
        {
            dispatchBegin("smartDragFromTo", arguments);
            
            MouseEventSimulator.mouseDownAt(stage, x0, y0);
            for(var i:uint = 0; i < steps; i++)
                MouseEventSimulator.mouseMoveAt(stage, 
                    x0 + (x1 - x0) * i / (steps - 1), 
                    y0 + (y1 - y0) * i / (steps - 1));
            MouseEventSimulator.mouseUpAt(stage, x1, y1);
            MouseEventSimulator.rollOutAt(stage, x1, y1);
            
            dispatchEnd("smartDragFromTo", arguments);
        }
        
        private function screenshot(x:Number, y:Number, width:Number, height:Number):void
        {
            var matrix:Matrix = new Matrix(1, 0, 0, 1, -x, -y);
            var bitmapData:BitmapData = new BitmapData(width, height, true, 0x0);
            try
            {
                bitmapData.draw(stage, matrix);
            }
            catch(error:Error)
            {
                return;
            }
            var bytes:ByteArray = bitmapData.getPixels(bitmapData.rect);
            var digest:String = SHA256.computeDigest(bytes);
            notify(digest);
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