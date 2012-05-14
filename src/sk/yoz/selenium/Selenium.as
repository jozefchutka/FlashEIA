package sk.yoz.selenium
{
    import flash.display.Stage;
    import flash.external.ExternalInterface;
    
    import sk.yoz.selenium.utils.MouseEventSimulator;

    public class Selenium
    {
        private var stage:Stage;
        
        private var script:XML = <script>
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
            
            ExternalInterface.call(script.toString());
        }
        
        public function clickAt(x:Number, y:Number):void
        {
            MouseEventSimulator.clickAt(stage, x, y);
        }
    }
}