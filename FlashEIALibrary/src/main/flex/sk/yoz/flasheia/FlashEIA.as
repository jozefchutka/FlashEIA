package sk.yoz.flasheia
{
    import flash.display.Stage;
    import flash.external.ExternalInterface;
    
    import sk.yoz.flasheia.utils.MouseEventSimulator;

    public class FlashEIA
    {
        private var stage:Stage;
        
        private static const SCRIPT:XML = <script>
            <![CDATA[
                function(){
                    window.getFlash = function(id)
                    {
                        return document.getElementById(id);
                    }
                    
                    window.clickAt = function(id, x, y)
                    {
                        window.getFlash(id).clickAt(x, y);
                    }
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
            
            notify("init");
        }
        
        public function clickAt(x:Number, y:Number):void
        {
            MouseEventSimulator.clickAt(stage, x, y);
        }
        
        public function notify(message:String):void
        {
            ExternalInterface.call("alert", message);
        }
    }
}