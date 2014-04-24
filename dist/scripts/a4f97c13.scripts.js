(function(){"use strict";angular.module("cdmaSimulatorApp",["ngCookies","ngResource","ngSanitize","ngRoute"]).config(["$routeProvider",function(a){return a.when("/",{templateUrl:"views/main.html",controller:"MainCtrl"}).otherwise({redirectTo:"/"})}])}).call(this),function(){"use strict";angular.module("cdmaSimulatorApp").factory("Code",function(){var a;return a=function(){function a(a){this.input=a,this.values="string"==typeof this.input?this.split(this.input):this.input}return a.prototype.split=function(a){return a.split("").map(function(a){return parseInt(a)})},a.prototype.shift=function(){var b;return b=this.values.map(function(a){return 0===a?-1:a}),new a(b)},a.prototype.stretch=function(b){var c,d,e,f,g,h,i;for(null==b&&(b=8),d=[],i=this.values,f=0,h=i.length;h>f;f++)for(e=i[f],c=g=1;b>=g;c=g+=1)d.push(e);return new a(d)},a.prototype.repeat=function(b){var c,d,e,f,g,h,i;for(null==b&&(b=4),d=[],c=f=1;b>=f;c=f+=1)for(i=this.values,g=0,h=i.length;h>g;g++)e=i[g],d.push(e);return new a(d)},a.prototype.spread=function(b){var c,d,e,f;for(d=[],c=e=0,f=this.values.length-1;f>=e;c=e+=1)d.push(this.values[c]*b.values[c]);return new a(d)},a.prototype.overlay=function(b){var c,d,e,f;for(d=[],c=e=0,f=this.values.length-1;f>=e;c=e+=1)d.push(this.values[c]+b.values[c]);return new a(d)},a.prototype.despread=function(b){var c,d,e,f;for(d=[],c=e=0,f=this.values.length-1;f>=e;c=e+=1)d.push(this.values[c]*b.values[c]);return new a(d)},a}()})}.call(this),function(){"use strict";angular.module("cdmaSimulatorApp").factory("Panel",["Code",function(a){var b;return b=function(){function b(){}return b.prototype.performSpreading=function(){return!this.code||(this.data_signal=new a(this.code),this.data_signal=this.data_signal.shift().stretch(),!this.spread||(this.spreading_code=new a(this.spread),this.spreading_code=this.spreading_code.shift().repeat(this.code.length),this.spread.length<8))?void 0:this.spreaded_code=this.data_signal.spread(this.spreading_code)},b}()}])}.call(this),function(){"use strict";var a;a=function(){function a(){this.chip_length=10,this.border=30}return a.prototype.draw=function(a,b,c,d){var e;return null==d&&(d=0),b?(e=b.values,this.text(a,c,0,d+5),this.grid(e,c,d+20),this.code(e,c,d+20)):void 0},a.prototype.range=function(a){var b,c,d,e;return b=_.max(a),0===b&&(b=Math.abs(_.min(a))),c=-1*b,d=function(){e=[];for(var a=c;b>=c?b>=a:a>=b;b>=c?a++:a--)e.push(a);return e}.apply(this).reverse()},a.prototype.code=function(a,b,c){var d,e,f,g,h,i,j;for(d=this.border,f=[],e=this.range(a),i=0,j=a.length;j>i;i++)g=a[i],h=10+20*e.indexOf(g),f.push("L"+d+","+(c+h)+" L"+(d+this.chip_length)+","+(c+h)),d+=this.chip_length;return b.path("M"+this.border+","+(c+50)+" "+f.join(" ")).attr({stroke:"red"})},a.prototype.grid=function(a,b,c){var d,e,f,g,h,i,j,k,l,m,n,o;for(d=this.border,g=this.range(a),e=2*_.max(g)+1,h=10,j=0,l=g.length;l>j;j+=1)f=g[j],this.text(f,b,5,c+h),h+=20;for(o=[],f=k=0,m=a.length*this.chip_length,n=this.chip_length;n>0?m>=k:k>=m;f=k+=n)i=b.path("M"+(d+f)+","+(c+0)+" L"+(d+f)+","+(c+20*e)),o.push(f/this.chip_length%8===0?i.attr({stroke:"#ccc","stroke-width":"2"}):i.attr({stroke:"#ccc","stroke-width":"1",opacity:"0.5"}));return o},a.prototype.text=function(a,b,c,d){return b.text(c,d,a).attr({"font-size":14,"font-family":"monospace","text-anchor":"start"})},a}(),angular.module("cdmaSimulatorApp").service("DrawerService",a)}.call(this),function(){"use strict";angular.module("cdmaSimulatorApp").controller("MainCtrl",["$scope","Code","DrawerService","Panel",function(a,b,c,d){return a.panel1=new d,a.panel1.paper=Raphael(document.getElementById("panel1"),400,300),a.panel2=new d,a.panel2.paper=Raphael(document.getElementById("panel2"),400,300),a.panel3=new d,a.panel3.paper=Raphael(document.getElementById("panel3"),400,300),a.panel4=new d,a.panel4.paper=Raphael(document.getElementById("panel4"),400,300),a.panel5=new d,a.panel5.paper=Raphael(document.getElementById("panel5"),400,300),a.updateCode=function(b){var d,e;return b.paper.clear(),b.performSpreading(),c.draw("Data signal",b.data_signal,b.paper),c.draw("Spreading code",b.spreading_code,b.paper,100),c.draw("Transmitted (single)",b.spreaded_code,b.paper,200),a.panel1.spreaded_code&&a.panel2.spreaded_code?(a.panel3.paper.clear(),e=a.panel1.spreaded_code.overlay(a.panel2.spreaded_code),c.draw("Transmitted (overlayed)",e,a.panel3.paper),a.panel4.paper.clear(),d=e.despread(a.panel1.spreading_code),c.draw("Despreaded code",d,a.panel4.paper),a.panel5.paper.clear(),d=e.despread(a.panel2.spreading_code),c.draw("Despreaded code",d,a.panel5.paper)):void 0},a.randomSpread=function(b){var c,d;return d=_.without(a.possible_spreads,a.panel1.spread,a.panel2.spread),c=d[_.random(0,d.length-1)],b.spread=c,a.updateCode(b)},a.possible_spreads=["11111111","10101010","11001100","10011001","11110000","10100101","11000011","10010110"]}])}.call(this);