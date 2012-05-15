package sk.yoz.flasheia.events
{
    import flash.events.Event;
    
    public class FlashEIAEvent extends Event
    {
        public static const EXECUTION_BEGIN:String = "executionBegin";
        public static const EXECUTION_END:String = "executionEnd";
        
        private var _method:String;
        private var _arguments:Array;
        
        public function FlashEIAEvent(type:String, method:String, arguments:Array)
        {
            super(type, false, true);
            
            _method = method;
            _arguments = arguments;
        }
        
        public function get method():String
        {
            return _method;
        }
        
        public function get arguments():Array
        {
            return _arguments;
        }
        
        override public function clone():Event
        {
            return new FlashEIAEvent(type, method, arguments);
        }
    }
}