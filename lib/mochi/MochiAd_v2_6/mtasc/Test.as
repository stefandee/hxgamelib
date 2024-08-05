class Test {
    static function begin(didLoad:Boolean) {
        var clickAwayMC:MovieClip = _root.createEmptyMovieClip("clickAwayMC", 100);
        var interlButton:MovieClip = _root.createEmptyMovieClip("interlButton", 110);
        var clickAwayButton:MovieClip = _root.createEmptyMovieClip("clickAwayButton", 120);
        var unloadButton:MovieClip = _root.createEmptyMovieClip("unloadButton", 130);
        
        var bTextFormat:TextFormat = new TextFormat();
        bTextFormat.align = "center";
        bTextFormat.font = "Tahoma";
        bTextFormat.size = 13;
        bTextFormat.color = 0x000000;
        
        interlButton._x = 10;
        interlButton._y = 10;
        interlButton.lineStyle(0, 0x000000, 100, true, "none", "square", "round");
        interlButton.lineTo(125, 0);
        interlButton.lineTo(125, 30);
        interlButton.lineTo(0, 30);
        interlButton.lineTo(0, 0);
        interlButton.createTextField("labelText", interlButton.getNextHighestDepth(), 0, 5, interlButton._width, 24);
        interlButton.labelText.text = "Show Interlevel Ad";
        interlButton.labelText.selectable = false;
        interlButton.labelText.antiAliasType = "advanced";
        interlButton.labelText.setTextFormat(bTextFormat);  
        interlButton.onRelease = function() {
            MochiAd.showTimedAd({id:"test", 
                                 res:"550x400", 
                                 ad_loaded: function():Void { interlButton._visible = false; clickAwayButton._visible = false; },
                                 ad_finished: function():Void { interlButton._visible = true; if (!unloadButton._visible) clickAwayButton._visible = true; } });
        }
        
        clickAwayButton._x = 10;
        clickAwayButton._y = 50;
        clickAwayButton.lineStyle(0, 0x000000, 100, true, "none", "square", "round");
        clickAwayButton.lineTo(125, 0);
        clickAwayButton.lineTo(125, 30);
        clickAwayButton.lineTo(0, 30);
        clickAwayButton.lineTo(0, 0);
        clickAwayButton.createTextField("labelText", clickAwayButton.getNextHighestDepth(), 0, 5, clickAwayButton._width, 24);
        clickAwayButton.labelText.text = "Show clickAway Ad";
        clickAwayButton.labelText.selectable = false;
        clickAwayButton.labelText.antiAliasType = "advanced";
        clickAwayButton.labelText.setTextFormat(bTextFormat);
        clickAwayButton.onRelease = function() {
            clickAwayMC._x = 160;
            clickAwayMC._y = 10;
            MochiAd.showClickAwayAd({clip:clickAwayMC, id:"test", ad_loaded: function():Void { unloadButton._visible = true; } });
            clickAwayButton._visible = false;
        }

        unloadButton._x = 10;
        unloadButton._y = 50;
        unloadButton.lineStyle(0, 0x000000, 100, true, "none", "square", "round");
        unloadButton.lineTo(125, 0);
        unloadButton.lineTo(125, 30);
        unloadButton.lineTo(0, 30);
        unloadButton.lineTo(0, 0);
        unloadButton.createTextField("labelText", unloadButton.getNextHighestDepth(), 0, 5, unloadButton._width, 24);
        unloadButton.labelText.text = "Unload clickAway Ad";
        unloadButton.labelText.selectable = false;
        unloadButton.labelText.antiAliasType = "advanced";
        unloadButton.labelText.setTextFormat(bTextFormat);
        unloadButton._visible = false;
        unloadButton.onRelease = function() {
            MochiAd.unload(clickAwayMC);
            unloadButton._visible = false;
            clickAwayButton._visible = true;
        }
    }
    
    static function main():Void {
        var did_load = false;
        _root.play = function () {
            // play is called when the ad is finished or didn't run
            Test.begin(did_load);
        };
        _root.stop = function () {
            // stop is called only if the ad starts
            did_load = true;
        };
        MochiAd.showPreGameAd({id:"test", res:"550x400"});
    }
}
