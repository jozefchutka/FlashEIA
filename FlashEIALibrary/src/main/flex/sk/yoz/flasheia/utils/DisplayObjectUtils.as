package sk.yoz.flasheia.utils
{
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class DisplayObjectUtils
    {
        private static const ZERO_POINT:Point = new Point;
        
        public static function getGlobalBounds(source:DisplayObject):Rectangle
        {
            var bounds:Rectangle = source.getBounds(source);
            
            var matrix:Matrix = new Matrix;
            matrix.translate(-bounds.x, -bounds.y);
            
            var width:uint = bounds.width + .5;
            var height:uint = bounds.height + .5;
            var bitmapData:BitmapData = new BitmapData(width, height, true, 0);
            bitmapData.draw(source, matrix, new ColorTransform(1, 1, 1, 1, 255, -255, -255, 255));
            
            var result:Rectangle = bitmapData.getColorBoundsRect(0xFF000000, 0xFF000000);
            result.offsetPoint(source.localToGlobal(ZERO_POINT));
            
            bitmapData.dispose();
            return result;
        }
    }
}